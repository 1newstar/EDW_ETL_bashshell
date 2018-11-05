--查看注释,列
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


 --查看建表语句
 select dbms_metadata.get_ddl(object_type => 'TABLE',name => 'ENT_CUSTINFO',schema=>'CIF') from dual;



