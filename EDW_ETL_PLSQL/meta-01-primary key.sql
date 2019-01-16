--主键
select 'create unique index ' || A.index_name || ' on ' || A.table_name || '(' ||
        WMSYS.WM_CONCAT(a.column_name) || ')' ||
        ' parallel 16 tablespace nologging;'
   from all_ind_columns A ,all_constraints B
  where A.table_owner = 'UNIPAYUSER'
    AND A.TABLE_NAME = 'T_PAY_SYSTEM_JOURNAL_HIS'
    AND A.index_name = B.constraint_name
    AND A.table_owner=b.owner
    AND A.TABLE_NAME=B.TABLE_NAME
    AND b.constraint_type ='P'
  GROUP BY A.INDEX_NAME, A.TABLE_NAME;

--create unique index PK_T_PAY_SYSTEM_JOURNAL_HIS on T_PAY_SYSTEM_JOURNAL_HIS(JOURNALNO) parallel 16 tablespace nologging;

 select 'alter table ' || a.table_name || ' add constraint ' || a.index_name ||
        ' primary key (' || wmsys.wm_concat(a.column_name) || ')' || ' ;'
   from dba_ind_columns A ,DBA_constraints B
  where A.table_owner = 'UNIPAYUSER'
    AND A.TABLE_NAME = 'T_PAY_SYSTEM_JOURNAL_HIS'
    AND A.index_name = B.constraint_name
    AND A.table_owner=b.owner
    AND A.TABLE_NAME=B.TABLE_NAME
    AND b.constraint_type ='P'
  GROUP BY A.INDEX_NAME, A.TABLE_NAME;