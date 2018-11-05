--create schema
CREATE SCHEMA  IF NOT EXISTS BDW_BDL;

--create user
CREATE USER user01 IDENTIFIED BY 'passwd'

--the privilege of schema
	--see the schema
	grant usage on schema BDW_BDL to user01;
	--create table in the schema
	grant create on schema BDW_BDL to user01;
	--all privilege of schema
	grant all on schema BDW_BDL to user01;

--the privilege of table( all tables in schema)
	--select
	grant select ON ALL TABLES IN SCHEMA BDW_BDL to user01;
	--insert
	grant insert ON ALL TABLES IN SCHEMA BDW_BDL to user01;
    --all
    grant all ON ALL TABLES IN SCHEMA BDW_FDL to dwadm2;