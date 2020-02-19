CREATE TABLE monit.agg_online_archive (
    `vcid` Int32,
    `evtp` Int32,
    `hour` DateTime('Europe/Moscow'),
    `value` Int64
)
ENGINE = ReplicatedSummingMergeTree('/clh/clickhouse/tables/{layer}-{shard}/agg_online_archive', '{replica}')
PARTITION BY toYYYYMM(toDate(hour))
ORDER BY (vcid, evtp, hour);