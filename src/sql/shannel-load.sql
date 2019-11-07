CREATE TABLE channel_loads
(
    `month_begin` Int32,
    `day_begin` Int32,
    `hour_begin` Int32,
    `url_protocol` String,
    `count` Int32
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(toDate(month_begin))
ORDER BY (day_begin, hour_begin)

