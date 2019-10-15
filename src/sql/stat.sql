CREATE TABLE stat
(
    `vcid` Int32,
    `tz` String,
    `player` String,
    `region` Int32,
    `net` Int32,
    `host` String,
    `app` String,
    `version_name` String,
    `version_code` Int32,
    `platform` String,
    `device_id` String,
    `created_at` Int32,
    `ip` String,
    `name` String,
    `sdk` Int32,
    `guid` String,
    `quality` String,
    `fts` String,
    `vts` String,
    `evtp` Int32,
    `reg` Int32,
    `mowtime` Int32,
    `swipeV` String,
    `swipeB` String,
    `swipeC` String,
    `adsst` String,
    `adstp` String,
    `adstm` String,
    `advid` String,
    `adsid` String,
    `launch` String,
    `window` String,
    `seek` String,
    `time` String,
    `action` String,
    `idfa` String,
    `start` String,
    `month_begin` Int32,
    `day_begin` Int32
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(toDate(created_at))
ORDER BY (day_begin, created_at)

-- For replica
-- ENGINE = ReplicatedMergeTree('/clh/clickhouse/tables/{layer}-{shard}/stat', '{replica}')
-- where {layer}, {shard} and {replica} from macros.xml or macros section in main config.xml