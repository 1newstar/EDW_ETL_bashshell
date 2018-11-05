
/******************************************
导出表2.0
*******************************************/
-------------------------------------------------------------
--export grant
select 'grant '||privileges_description||' on '||object_schema||'.'||object_name||' to '||grantee||';'
 from grants
 where grantee in ('r_bdwbdl_qry','r_bdwbdl_dml')
 order by object_name,privileges_description;

--------------------------------------------------------------
--export comment
select  
'COMMENT ON TABLE '||object_schema||'.'||object_name||' IS '||comment||';'
from comments
where object_schema='bdw_bdl'

-----------------------------------------------------------------
--export all table
select node_name from current_session;--v_dws_node0003

select export_objects('/tmp/bdw_adl.sql','bdw_adl');
select export_objects('/tmp/bdw_bdl.sql','bdw_bdl');
select export_objects('/tmp/bdw_bkbdl.sql','bdw_bkbdl');

select export_objects('/tmp/bdw_fdl.sql','bdw_fdl');
select export_objects('/tmp/bdw_bdl.sql','bdw_bdl');
select export_objects('/tmp/bdw_bkbdl.sql','bdw_fdl');

-------------------------------------------------------------------
--An empty string (' ') exports all non-virtual table objects to which the user has access, including table schemas, sequences, and constraints.
SELECT EXPORT_TABLES('/tmp/tmp.sql ','');
-------------------------------------------------------------------
--export a table
SELECT EXPORT_TABLES('/tmp/tmp.sql ','store.store_orders_fact');
