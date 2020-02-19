CREATE MATERIALIZED VIEW monit.agg_online_archive_consumer TO monit.agg_online_archive
    AS SELECT
        vcid,
        evtp,
        toStartOfHour(now()) as hour,
        count() as value
    FROM statconsumer
    GROUP BY vcid, evtp, hour;