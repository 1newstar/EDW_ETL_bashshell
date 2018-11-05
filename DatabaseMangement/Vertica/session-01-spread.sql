SELECT DATE_TRUNC('minute', TIME) AS TIME,
       node_name,
       ROUND((MAX(retrans) - MIN(retrans)) / (MAX(message_delivered) - MIN(message_delivered)) * 100, 2.0) AS retransmit_rate
FROM dc_spread_monitor
GROUP BY 1,
         2
HAVING ROUND((MAX(retrans) - MIN(retrans)) / (MAX(message_delivered) - MIN(message_delivered)) * 100, 2.0) > 10
ORDER BY 1 DESC,
         2;


SELECT *
FROM dc_spread_monitor
LIMIT 1;