DROP TABLE IF EXISTS TEMP.TABLE_ROWS_COUNT;
CREATE TABLE TEMP.TABLE_ROWS_COUNT(
TABLE_SCHEMA VARCHAR2(100),
TABLE_NAME   VARCHAR2(100),
ROWS_COUNT   NUMBER(18),
EXEC_DATE VARCHAR2(30)
);
SELECT 'INSERT INTO TEMP.TABLE_ROWS_COUNT(TABLE_SCHEMA,TABLE_NAME,ROWS_COUNT,EXEC_DATE) SELECT '''||TABLE_SCHEMA||''','''||TABLE_NAME||''',COUNT(*),TO_CHAR(SYSDATE,''YYYY-MM-DD HH24:MI:SS'') FROM '||TABLE_SCHEMA||'.'||TABLE_NAME||';'
FROM TABLES
WHERE IS_TEMP_TABLE IS FALSE
  AND UPPER(TABLE_SCHEMA) IN ('TEMP',
                              'RISK_MANAGEMENT',
                              'RISK',
                              'MARKETING',
                              'ETL_CFG2_BAK',
                              'ETL_CFG2',
                              'ETL_CFG',
                              'BDW_SDL',
                              'BDW_MS',
                              'BDW_LAB_BAK',
                              'BDW_LAB',
                              'BDW_KPI_BAK',
                              'BDW_KPI',
                              'BDW_FDL_BAK',
                              'BDW_FDL',
                              'BDW_DX',
                              'BDW_DIM_BAK',
                              'BDW_DIM',
                              'BDW_BKBDL',
                              'BDW_BDL',
                              'BDW_AGT',
                              'BDW_ADL_BAK',
                              'BDW_ADL',
                              'AML')
ORDER BY TABLE_SCHEMA,
         TABLE_NAME;

-----------------------------------------------------------------

CREATE TABLE TEMP.PROJECTION_ROS_INFO(
SCHEMA_NAME VARCHAR2(100),
PROJECTION_NAME   VARCHAR2(100),
TOTAL_ROW_COUNT   NUMBER(18),
DELETED_ROW_COUNT NUMBER(18),
USED_BYTES_MB     NUMBER(18,2),
DELETE_VECTOR_COUNT NUMBER(18),
EXEC_DATE VARCHAR2(30)
);

insert into TEMP.PROJECTION_ROS_INFO
(
SCHEMA_NAME,
PROJECTION_NAME,
TOTAL_ROW_COUNT,
DELETED_ROW_COUNT,
USED_BYTES_MB,
DELETE_VECTOR_COUNT,
EXEC_DATE
)
SELECT SCHEMA_NAME,
       projection_name,
       sum(total_row_count),
       sum(deleted_row_count),
       round(sum(used_bytes)/1024/1024,2),
       sum(delete_vector_count),
       TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS')
FROM storage_containers
WHERE storage_type='ROS'
 -- AND SCHEMA_NAME='BDW_ADL'
GROUP BY SCHEMA_NAME,projection_name

------------------------------------------

SELECT SCHEMA_NAME,
       round(sum(used_bytes)/1024/1024/1024,2) AS size_in_gb,
       sysdate
FROM storage_containers
WHERE storage_type='ROS'
GROUP BY SCHEMA_NAME
ORDER BY 2 DESC;

------------------------------------------
SELECT node_name,
       round(sum(used_bytes)/1024/1024/1024,2) AS size_in_gb,
       sysdate
FROM v_monitor.storage_containers
GROUP BY node_name;
