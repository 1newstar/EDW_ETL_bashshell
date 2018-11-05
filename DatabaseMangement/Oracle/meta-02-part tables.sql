select * from all_part_tables;

select * from all_part_key_columns;

select partition_name,HIGH_VALUE,PARTITION_POSITION,num_rows
  from ALL_TAB_PARTITIONS
where table_owner='UNIPAYUSER'
  and table_name='T_PAY_ORDER_INFO_HIS';

select 
'select /*+parallel(4)*/ count(1) from unipayuser.T_PAY_ORDER_INFO_HIS PARTITION('||partition_name||');'
from ALL_TAB_PARTITIONS
where table_owner='UNIPAYUSER'
and table_name='T_PAY_ORDER_INFO_HIS';