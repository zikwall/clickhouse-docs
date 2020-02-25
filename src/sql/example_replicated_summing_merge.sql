-- this is really a working option, it may come up as an example

-- MV забирает данные из другого MV
-- Нужно создавать на каждом узле
CREATE MATERIALIZED VIEW monit.agg_online_archive_consumer TO monit.agg_online_archive
    (`vcid` Int32, `evtp` Int32, `day_begin` Int32, `value` Int32, `app` String)
AS SELECT
    vcid,
    evtp,
    day_begin,
    toInt32(count()) AS value,
    app
FROM monit.statconsumer
WHERE adsst = 'NULL' AND action != 'opening-channel'
GROUP BY vcid, evtp, day_begin, app

-- нужно создавать на каждом узле, сюда будут складываться данные из MV agg_online_archive_consumer и далее агрегироваться
CREATE TABLE monit.agg_online_archive (
    `vcid` Int32,
    `evtp` Int32,
    `day_begin` Int32,
    `value` Int32,
    `app` String
)
ENGINE = ReplicatedSummingMergeTree('/clh/clickhouse/tables/{layer}-{shard}/agg_online_archive', '{replica}')
PARTITION BY toYYYYMM(toDate(day_begin))
ORDER BY (vcid, evtp, day_begin)

-- distributed создается на ОДНОМ узле
CREATE TABLE monit.agg_online_archive
(
    `vcid` Int32,
    `evtp` Int32,
    `day_begin` Int32,
    `value` Int32,
    `app` String
)
ENGINE = Distributed(monit_cluster, monit, agg_online_archive)

-- example query

SELECT vcid, evtp, day_begin, sum(value) as value FROM agg_online_archive GROUP BY vcid, evtp, day_begin;

-- NOTE: that for the correct generation of the result it is necessary to use the aggregation function sum,
-- otherwise there is a possibility that the click house will not have time to aggregate the data


