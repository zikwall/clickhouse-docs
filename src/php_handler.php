#!/usr/bin/php

<?php

require_once ("/var/www/monit/log/include/functions.php");
require_once ("/var/www/monit/log/classes/Service.php");
require_once ("/var/www/monit/log/vendor/autoload.php");

use Kafka\ProducerConfig;
use Kafka\Producer;

function decode_code($code)
{
    return preg_replace_callback(
        "(\\\\x([0-9a-f]{2}))i",
        function ($a) {return chr(hexdec($a[1]));},
        $code
    );
}

function getItems($fullStr)
{
    $fullStr = urldecode($fullStr);
    $getArr = explode('|', $fullStr);

    $mainItems = [];
    $userAgentItems = [];
    $getArr[7] = trim($getArr[7]);

    if ($getArr[7] !== '-' && isJson($getArr[7])) {
        $userAgent = $getArr[7];
    } else {
        $userAgent = $getArr[6];
    }

    try {
        $decode = trim(decode_code($userAgent));
        $userAgentItems = json_decode($decode, true);
    } catch (Exception $e) {
        $userAgentItems['name'] = 'UNDECODE';
    }

    $mainString =  explode('**', $getArr[5]);
    $arr = explode(':', $mainString[1]);

    $c = count($arr);

    for ($i = 0; $i <= $c; $i++) {
        if ($i === $c) {
            break;
        }

        $mainItems[$arr[$i++]] = $arr[$i];
    }

    if (!is_array($userAgentItems)) {
        $userAgentItems = [];
    }

    if (!is_array($mainItems)) {
        $mainItems = [];
    }

    return array_merge($userAgentItems, $mainItems, [
        'ip' => $getArr[2]
    ]);
}

function isJson($string)
{
    $json = json_decode($string, true);
    return json_last_error() == JSON_ERROR_NONE && !empty($json);
}

function stdin_stream()
{
    while ($line = fgets(STDIN)) {
        yield $line;
    }
}

$rk = new RdKafka\Producer();
$rk->setLogLevel(LOG_DEBUG);
$rk->addBrokers("ip:port");
$topic = $rk->newTopic("statopic01");

foreach (stdin_stream() as $stream) {
    $data = Service::dispatch(getItems($stream));
    $jsonRow = json_encode($data);
    $topic->produce(RD_KAFKA_PARTITION_UA, 0, $jsonRow); //
    //$rk->poll(0);
}