
SELECT 'select '||COLUMN_NAME||' from bdw_bdl.'||TABLE_NAME||';' AS "sql",
        TABLE_NAME
FROM columns
WHERE data_type='timestamp'
  AND table_schema='bdw_bdl'
ORDER BY TABLE_NAME