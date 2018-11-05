/* 磁盘容量*/
SELECT node_name,
       round(sum(used_bytes)/1024,2) AS size_in_kb
FROM v_monitor.storage_containers
GROUP BY node_name /*节点情况*/
SELECT node_name,
       host_name
FROM node_resources;

