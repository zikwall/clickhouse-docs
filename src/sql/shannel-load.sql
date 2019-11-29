-- На каждом сервере добавляем таблички
-- В будущем нужно создать отдельный кластер для этого, чтобы не юзать на остальных...
-- monit_cluster_loads

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

-- Не забываем добавлять Distributed на одноименный сервак
-- ENGINE = Distributed(monit_cluster, monit, channel_loads)