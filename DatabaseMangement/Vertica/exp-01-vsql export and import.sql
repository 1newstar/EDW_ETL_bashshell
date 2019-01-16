-- http://code.mteixeira.me/SQLTools/

--01 vertica table used MB
SELECT anchor_table_name,
       sum(ROW_COUNT)/count(DISTINCT COLUMN_NAME) AS ROW_COUNT,
       round(sum(used_bytes)/1024/1024,2) AS "Used_MB"
FROM column_storage
WHERE anchor_table_schema='bdw_fdl'
    AND anchor_table_name='FDL_T02_WO_USER_AGREEMENT'
    AND projection_name LIKE '%b0'
GROUP BY anchor_table_name;


--02 拼接vsql语句
--vsql -U dbadmin -w passwd -h 192.168.31.31 -F $'|' -At -o /app/dbbackup/exp/FDL_T02_WO_USER_AGREEMENT.txt -c "select * from bdw_fdl.FDL_T02_WO_USER_AGREEMENT;"
SELECT 'vsql -U name -w password -h '||a.ip||' -F $''|'' -At -o /app/dbbackup/exp/'||a.table_name||'.txt -c "select * from '||a.table_schema||'.'||a.table_name||';"'
FROM
    (SELECT table_schema,
            TABLE_NAME,
            '192.168.31.3'||(count(TABLE_NAME) over(
                                                    ORDER BY TABLE_NAME ROWS BETWEEN unbounded preceding AND CURRENT ROW) %4) AS ip
     FROM TABLES
     WHERE table_schema='bdw_fdl') a;


--03.text file import into new database
cat /app/dbbackup/exp/FDL_T02_WO_USER_AGREEMENT.txt | vsql -U dbadmin -w passwd -h 126.126.126.30 -d dws -c "COPY bdw_fdl.FDL_T02_WO_USER_AGREEMENT FROM STDIN DELIMITER '|'";
