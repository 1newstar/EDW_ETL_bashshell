SELECT ordinal_position,
       COLUMN_NAME,
       data_type
FROM columns a
WHERE table_schema='TEMP'
  AND TABLE_NAME='BDL_T_PAY_ORDER_INFO_HIS'
ORDER BY ordinal_position;


SELECT ordinal_position,
       COLUMN_NAME,
       data_type
FROM columns
WHERE table_schema='bdw_bdl'
  AND TABLE_NAME='BDL_T_PAY_ORDER_INFO_HIS'
ORDER BY ordinal_position;


SELECT a.ordinal_position,
       a.column_name,
       a.data_type,
       a.column_name=b.column_name,
       a.data_type=b.data_type
FROM columns a,
     columns b
WHERE a.table_schema='TEMP'
  AND a.table_name='BDL_T_PAY_ORDER_INFO_HIS'
  AND b.table_schema='bdw_bdl'
  AND b.table_name='BDL_T_PAY_ORDER_INFO_HIS'
  AND b.ordinal_position=a.ordinal_position;


INSERT INTO bdw_bdl.BDL_T_PAY_ORDER_INFO_HIS
SELECT *
FROM TEMP.BDL_T_PAY_ORDER_INFO_HIS;

