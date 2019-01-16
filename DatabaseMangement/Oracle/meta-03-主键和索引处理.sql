--------------------------------------------------
--step01���鿴����

--------------------------------------------------
select owner, constraint_name, index_name, constraint_type, table_name
  from DBA_constraints
 where table_name = 'LDMT02_JBXX_YZCWSBQC'
   AND OWNER = 'J1_LDM'
   and constraint_type = 'P';  --PK_LDMT02_JBXX_YZCWSBQ

--------------------------------------------------------------------
--��������
 select 'create bitmap index ' || index_name || ' on ' || table_name || '(' ||
        column_name || ')' ||
        ' local parallel 32 tablespace TS_LDM_IDX nologging;'
   from dba_ind_columns
  where table_owner = 'J1_LDM'
    AND TABLE_NAME = 'LDMT02_JBXX_YZCWSBQC'
    --�ų�����
    AND index_name <> 'PK_LDMT02_JBXX_YZCWSBQC';
 --result:
----------------------------------------------------------------
--ɾ������
  SELECT 'drop index J1_LDM.' || index_name || ';'
   FROM DBA_IND_COLUMNS
  WHERE table_owner = 'J1_LDM'
    AND TABLE_NAME = 'LDMT02_JBXX_YZCWSBQC'
    AND index_name <> 'PK_LDMT02_JBXX_YZCWSBQC';

--ɾ��
----------------------------------------------------------------
--����Ψһ����
--Ψһ����
 select 'create unique index ' || index_name || ' on ' || table_name || '(' ||
        WMSYS.WM_CONCAT(column_name) || ')' ||
        ' parallel 32 tablespace TS_LDM_IDX nologging;'
   from dba_ind_columns
  where table_owner = 'J1_LDM'
    AND TABLE_NAME = 'LDMT02_JBXX_YZCWSBQC'
    AND index_name = 'PK_LDMT02_JBXX_YZCWSBQC'
  GROUP BY INDEX_NAME, TABLE_NAME;
-----------------------------------------------------
--reulst:
create unique index PK_LDMT02_JBXX_YZCWSBQC on LDMT02_JBXX_YZCWSBQC(NSRZHDAH,WSPZXH,YWXH) parallel 32 tablespace TS_LDM_IDX nologging;
--------------------------------------------------------------------
--��������
--add primary key 
 select 'alter table ' || table_name || ' add constraint ' || index_name ||
        ' primary key (' || wmsys.wm_concat(column_name) || ')' || ' ;'
   from dba_ind_columns
  where table_owner = 'J1_LDM'
    AND TABLE_NAME = 'LDMT02_JBXX_YZCWSBQC'
    AND index_name = 'PK_LDMT02_JBXX_YZCWSBQC'
  group by index_name, table_name;
 
--result:  
alter table LDMT02_JBXX_YZCWSBQC add constraint PK_LDMT02_JBXX_YZCWSBQC primary key (NSRZHDAH,WSPZXH,YWXH) ;
----------------------------------------------------------------------
--ɾ������Ψһ����
alter table LDMT02_JBXX_YZCWSBQC drop primary key;
drop index PK_LDMT02_JBXX_YZCWSBQC



