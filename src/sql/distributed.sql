-- DOCS
-- EN https://clickhouse.yandex/docs/en/operations/table_engines/distributed/
-- RU https://clickhouse.yandex/docs/ru/operations/table_engines/distributed/

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
ENGINE = Distributed(monit_cluster, monit, stat)

-- Distributed(monit_cluster, ..., ...) # cluster name from config
-- Distributed(..., monit, ...)         # database name on shards
-- Distributed(..., ..., stat)          # table name on shards