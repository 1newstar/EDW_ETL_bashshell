--oracle查看表的列,类型,注释,创建注释
select t1.owner as TAB_OWNER,
       t1.table_name,
       t2.comments as TAB_COMMENT,
       t2.table_type,
       t1.column_id,
       t1.column_name,
       t3.comments as COL_COMMENT,
       t1.data_type,
       t1.data_length,
       t1.data_precision,
       case when 
          t3.comments is not null
       then
          'comment on column ETL_'||t1.table_name||'.'||t1.column_name||' is '''||t3.comments||''';'
       else
          t3.comments
       end as create_comment
  from all_tab_cols t1, all_tab_comments t2, all_col_comments t3
 where t1.owner='CIF' 
   and t1.table_name='ENT_CERTIFICATE'
   and t1.owner = t2.OWNER
   and t1.TABLE_NAME = t2.table_name
   and t1.owner = t3.OWNER
   and t1.TABLE_NAME = t3.TABLE_NAME
   and t1.COLUMN_NAME = t3.COLUMN_NAME
 order by t1.owner, t1.table_name, t1.column_id;


 --oracle查看建表语句
 select dbms_metadata.get_ddl(object_type => 'TABLE',name => 'ENT_CUSTINFO',schema=>'CIF') from dual;


--oracle使用正则表达式,repexp_like,repexp_replace
--etl 元数据的修改
--regexp_replace + regexp_like
create table command_chwj_adl_replace
as 
select sys_cod,brn_cod,cmd_seq,cmd_id,
       cmd_str,regexp_replace(CMD_DES,'(程文君:xxx)','(宁钢:xxx)') as new_CMD_DES
FROM command
where sys_cod='EDWADL'
and regexp_like(CMD_DES,'(程文君:xxx)');

update command a
set a.CMD_DES = (select b.new_CMD_DES 
from command_chwj_adl_replace b
where a.sys_cod=b.sys_cod
and   a.brn_cod=b.brn_cod
and   a.cmd_seq=b.cmd_seq
and   a.cmd_id=b.cmd_id)
where exists (
  select 1
  from command_chwj_adl_replace b
where a.sys_cod=b.sys_cod
  and   a.brn_cod=b.brn_cod
  and   a.cmd_seq=b.cmd_seq
  and   a.cmd_id=b.cmd_id
);
commit

 SELECT * 
FROM command
where sys_cod='EDWADL'
and regexp_like(CMD_DES,'(宁钢:xxxxxx)');

--etl元数据,查看月度加工情况
select INF_TYP as "状态" ，msg_app as "错误描述",
       cmd_des as "调度描述",sys_cod as "系统号",brn_cod as "机构号",
       DAT_DTE as "日切时间",cmd_id as "命令号",cmd_str as "命令",
       to_char(str_tim,'yyyy-mm-dd hh24:mi:ss') as "开始",
       to_char(end_tim,'yyyy-mm-dd hh24:mi:ss') as "结束"
  from ETLCTRL.ETL_LOG a
 where DAT_DTE = to_char(sysdate-1,'yyyy-mm-dd')                         
 --and INF_TYP = 'E' --报错的状态
 and exists(
      select b.grp_id 
      from ETLCTRL.GRP_STATE B where grp_sty='MonthBgn_1'
      and b.sys_cod=a.sys_cod
      and b.brn_cod=a.brn_cod)
  order by 10 desc

select *
from ETLCTRL.GRP_STATE b
where grp_sty='MonthBgn_1'--18
and  not exists(
        select 1
        from ETLCTRL.ETL_LOG a
      where DAT_DTE = to_char(sysdate-1,'yyyy-mm-dd') 
      and b.sys_cod=a.sys_cod
      and b.brn_cod=a.brn_cod)

--oracle 查看索引列的注释情况
select a.index_name,a.column_name,A.COLUMN_POSITION,b.index_type,C.comments
from all_IND_COLUMNS a,all_indexes b,all_col_comments C 
where a.table_name='T_PAY_ORDER_INFO_HIS'
  and b.table_name=a.table_name
  and c.table_name=a.table_name 
  and a.table_owner='UNIPAYUSER'
  and b.owner=a.table_owner
  and c.owner=a.table_owner
  and a.index_name=b.index_name(+)
  and a.column_name=c.column_name;


--oracle 分区表查看
    select * from all_part_tables;
    select * from all_part_key_columns;
    select partition_name,HIGH_VALUE,PARTITION_POSITION,num_rows,
    'select /*+parallel(4)*/ count(1) from '||table_owner||'.'||table_name||'T_PAY_ORDER_INFO_HIS PARTITION('||partition_name||');'
    from ALL_TAB_PARTITIONS
    where table_owner='UNIPAYUSER'
     and table_name='T_PAY_ORDER_INFO_HIS';

--Oracle查看开发包
select * from user_source where name='MD5_MIBAO'


--oracle主键查看
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

--oracle索引查看
 select 'create index ' || index_name || ' on ' || table_name || '(' ||
        WMSYS.WM_CONCAT(column_name) || ')' ||
        ' parallel 32 tablespace TS_LDM_IDX nologging;'
   from dba_ind_columns
  where table_owner = 'J1_LDM'
    AND TABLE_NAME = 'LDMT02_JBXX_YZCWSBQC'
  GROUP BY INDEX_NAME, TABLE_NAME;

--查看会话,杀死会话
SELECT distinct
       s.username,
       s.inst_id,
       o.object_name,
       s.wait_class,
       'alter system kill session ''' || s.sid || ',' || s.serial# ||
       ''' immediate;' as sql_kill_session,
       'ps -ef | grep ' || p.spid || ' | grep -v grep' as shell_grep_proc,
       'kill -9 ' || p.spid as shell_kill_proc,
       s.blocking_session,
       s.seconds_in_wait,
       machine,
       p.program,
       s.sql_id
  FROM gv$locked_object l, dba_objects o, gv$session s, gv$process p
 WHERE l.object_id = o.object_id
   AND l.session_id = s.sid
   and s.paddr = p.addr
   and s.username in ('J1_DW','J1_LDCX','J1_LDM','J1_G3_ZBQ')
   --and machine='fjstj1ap01'
   --and s.inst_id = '1';
   order by o.object_name,s.username;
  
-- alter system kill session '594,49230' immediate;

SELECT p.sql_fulltext
  FROM gv$locked_object l, gv$session s, gv$sqlarea p
 WHERE l.session_id = s.sid
   and s.sql_id = p.sql_id;

--查看dblink
select * from dba_db_links where owner='PUBLIC'

--查看表空间使用情况

SELECT a.tablespace_name,
       round(a.bytes / (1024 * 1024 * 1024)) total_GB,
       round(b.bytes / (1024 * 1024 * 1024)) used_GB,
       round(c.bytes / (1024 * 1024 * 1024)) free_GB 
  FROM sys.sm$ts_avail a, sys.sm$ts_used b, sys.sm$ts_free c
 WHERE a.tablespace_name = b.tablespace_name
   AND a.tablespace_name = c.tablespace_name
   and (a.tablespace_name LIKE 'TS_ZBQ%' OR
       a.tablespace_name LIKE 'TS_LDM%' OR a.tablespace_name LIKE 'TS_DW%' OR
       a.tablespace_name LIKE 'TS_LDCX%')
 order by a.tablespace_name desc;

 --dbms_job
 declare
   job number;
begin
  sys.dbms_job.submit(job       => job,
                      what      => 'Declare
                                       an_rownum number;
                                    begin
           -- Call the procedure
                                     end;',
                      --修改date,select sysdate from dual;
                      next_date => to_date('2016/9/6 16:42:30','yyyy/mm/dd hh24:mi:ss'),
                      interval  => 'sysdate+99999');
  commit;
  DBMS_OUTPUT.PUT_LINE(job);
end;

--sql优化
--c.report_tuning_task
declare
  lv_task_name varchar2(30);
begin
  --select instance_name,instance_number from v$instance;
  lv_task_name := DBMS_SQLTUNE.create_tuning_task(sql_id => '5xjgmarn516vv',
                                                  scope       => 'comprehensive',
                                                  time_limit  => '60',
                                                  task_name   => 'INFT04_SB_GRSDS_SRNSMX',
                                                  description => 'task to tune a query');
  dbms_output.put_line(lv_task_name);
  DBMS_SQLTUNE.execute_tuning_task(task_name => 'INFT04_SB_GRSDS_SRNSMX');
end;
select dbms_sqltune.report_tuning_task('INFT04_SB_GRSDS_SRNSMX') from dual;


---插入表
CREATE OR REPLACE PROCEDURE J1_LDM.P_GRSDS_SRNSMX IS
begin
  execute immediate 'alter session enable parallel ddl';
  execute immediate 'truncate table j1_ldm.LDMT04_SB_GRSDS_SRNSMX';
  
/*  --前提是：COLUMN_ID
  SELECT COLUMN_NAME,COLUMN_ID FROM DBA_TAB_COLUMNS WHERE TABLE_NAME='LDMT04_SB_GRSDS_SRNSMX'
  MINUS
  SELECT COLUMN_NAME,COLUMN_ID FROM DBA_TAB_COLUMNS WHERE TABLE_NAME='INFT04_SB_GRSDS_SRNSMX'
*/

  insert /*+append parallel(32) */
  into j1_ldm.LDMT04_SB_GRSDS_SRNSMX
  select /*+parallel(32) */* 
  from J1_g3_zbq.INFT04_SB_GRSDS_SRNSMX;
  commit;
end;


declare
  job number;
begin
  sys.dbms_job.submit(job  => job,
                      what => '
begin
  -- Call the procedure
  J1_LDM.P_GRSDS_SRNSMX;
end;
',
                      --修改date,select sysdate from dual;
                      next_date => to_date('2016/9/7 16:10:09',
                                           'yyyy/mm/dd hh24:mi:ss'),
                      interval  => 'sysdate+99999');
  commit;
  DBMS_OUTPUT.PUT_LINE(job);
end;

--搜集表的统计信息

BEGIN
  dbms_stats.gather_table_stats('J1_LDM',
                                'LDMT02_YE_SFXX',
                                degree           => 32,
                                cascade          => TRUE,
                                force            => TRUE,
                                estimate_percent => '30',
                                granularity      => 'all',
                                method_opt       => 'for all indexed columns');
END;

/********************************************************************
--统计信息更新
********************************************************************/
select distinct 'exec dbms_stats.gather_table_stats(''J1_DW'',''' ||
                table_name ||
                ''',degree=>32,cascade=>TRUE,force=>TRUE,estimate_percent => dbms_stats.auto_sample_size,granularity => ''all'',method_opt => ''for all indexed columns'')',
                table_name
  from dba_tab_statistics t
 where owner = 'J1_DW'
   AND (last_analyzed is null or stale_stats = 'YES')
 order by table_name;
 
select distinct 'exec dbms_stats.gather_table_stats(''J1_LD'',''' ||
                table_name ||
                ''',degree=>32,cascade=>TRUE,force=>TRUE,estimate_percent => dbms_stats.auto_sample_size,granularity => ''all'',method_opt => ''for all indexed columns'')',
                table_name
  from dba_tab_statistics t
 where owner = 'J1_LDM'
   AND (last_analyzed is null or stale_stats = 'YES')
 order by table_name desc;

--sql profle
begin
  dbms_sqltune.accept_sql_profile(task_name  => 'TMP_ETL_DW1_QGJ_FIRSTLAST',
                                  task_owner => 'SYSTEM',
                                  replace    => TRUE);
end;
