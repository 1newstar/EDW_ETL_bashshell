
/*************************************************
create schema
*************************************************/
--create schema
CREATE SCHEMA  IF NOT EXISTS BDW_BDL;
CREATE SCHEMA  IF NOT EXISTS BDW_BKBDL;
CREATE SCHEMA  IF NOT EXISTS BDW_FDL;
CREATE SCHEMA  IF NOT EXISTS BDW_DIM;
CREATE SCHEMA  IF NOT EXISTS BDW_ADL;
CREATE SCHEMA  IF NOT EXISTS TEMP;
CREATE SCHEMA  IF NOT EXISTS ETL_CFG2;


/*************************************************
create users
*************************************************/
--create user
CREATE USER etlusr IDENTIFIED BY ''

CREATE USER etlusr2 IDENTIFIED BY ''

CREATE USER rptusr2 IDENTIFIED BY ''
alter USER rptusr2 IDENTIFIED BY ''

CREATE USER dwadm2 IDENTIFIED BY ''

/*************************************************
Schema Privileges

CREATE
Allows the user to create new objects within the schema. This includes the ability to create a new object, rename existing objects, and move objects into the schema from other schemas.

USAGE
Permission to select, access, alter, and drop objects in the schema. 
The user must also be granted access to the individual objects in order to alter them. 
For example, a user would need to be granted USAGE on the schema and SELECT on a table to be able to select data from a table. 
You receive an error message if you attempt to query a table that you have SELECT privileges on, but do not have USAGE privileges for the schema that contains the table.
*************************************************/
/*************************************************
GRANT (Schema)
*************************************************/
--etlusr2
grant usage on schema BDW_BDL to etlusr2;
grant usage on schema BDW_BKBDL to etlusr2;
grant usage on schema BDW_FDL to etlusr2;
grant usage on schema BDW_DIM to etlusr2;
grant usage on schema BDW_ADL to etlusr2;
grant usage on schema TEMP to etlusr2;
grant usage on schema ETL_CFG2 to etlusr2;

grant create on schema BDW_BDL to etlusr2;
grant create on schema BDW_BKBDL to etlusr2;
grant create on schema BDW_FDL to etlusr2;
grant create on schema BDW_DIM to etlusr2;
grant create on schema BDW_ADL to etlusr2;
grant create on schema TEMP to etlusr2;

--etlusr
grant usage on schema BDW_BDL to etlusr;
grant usage on schema BDW_BKBDL to etlusr;
grant usage on schema BDW_FDL to etlusr;
grant usage on schema BDW_DIM to etlusr;
grant usage on schema BDW_ADL to etlusr;
grant usage on schema TEMP to etlusr;
grant usage on schema ETL_CFG2 to etlusr;

grant create on schema BDW_BDL to etlusr;
grant create on schema BDW_BKBDL to etlusr;
grant create on schema BDW_FDL to etlusr;
grant create on schema BDW_DIM to etlusr;
grant create on schema BDW_ADL to etlusr;
grant create on schema TEMP to etlusr;

--rptusr2
grant usage on schema BDW_DIM to rptusr2;
grant usage on schema BDW_ADL to rptusr2;

--dwadm2
grant usage on schema BDW_BDL to dwadm2;
grant usage on schema BDW_BKBDL to dwadm2;
grant usage on schema BDW_FDL to dwadm2;
grant usage on schema BDW_DIM to dwadm2;
grant usage on schema BDW_ADL to dwadm2;
grant usage on schema TEMP to dwadm2;
grant usage on schema ETL_CFG2 to dwadm2;

grant create on schema BDW_BDL to dwadm2;
grant create on schema BDW_BKBDL to dwadm2;
grant create on schema BDW_FDL to dwadm2;
grant create on schema BDW_DIM to dwadm2;
grant create on schema BDW_ADL to dwadm2;
grant create on schema ETL_CFG2 to dwadm2;

-- --all (CREATE, USAGE)
-- grant all on schema BDW_BDL to etlusr;
-- grant all on schema BDW_BKBDL to etlusr;
-- grant all on schema BDW_FDL to dwadm2;
-- grant all on schema BDW_DIM to dwadm2;
-- grant all on schema BDW_ADL to dwadm2;
-- grant all on schema BDW_ADL to dwadm2

--rptusr2
grant usage on schema BDW_DIM to rptusr2;
grant usage on schema BDW_ADL to rptusr2;

/*************************************************
table Privileges

SELECT

INSERT
INSERT tuples into the specified table and to use the COPY command to load the table.

UPDATE
UPDATE tuples in the specified table.

DELETE
Allows DELETE of a row from the specified table

REFERENCES
外键引用约束

ALL
all PRIVILEGES 
Applies to all privileges

---------------------------------------------------

ON ALL TABLES IN SCHEMA
Grants privileges on all tables (and by default all views) within one or more schemas to a user and/or role.

username
Grants the privilege to the specified user.

role
Grants the privilege to the specified role.

PUBLIC
Grants the privilege to all users.

*************************************************/

grant all ON ALL TABLES IN SCHEMA BDW_BDL to etlusr;
grant all ON ALL TABLES IN SCHEMA BDW_BKBDL to etlusr;

grant all ON ALL TABLES IN SCHEMA BDW_BDL to etlusr2;
grant all ON ALL TABLES IN SCHEMA BDW_BKBDL to etlusr2;

grant all ON ALL TABLES IN SCHEMA BDW_BDL to dwadm2;
grant all ON ALL TABLES IN SCHEMA BDW_BKBDL to dwadm2;

grant all ON ALL TABLES IN SCHEMA ETL_CFG2 to dwadm2;

grant all ON ALL TABLES IN SCHEMA BDW_FDL to dwadm2;
grant all ON ALL TABLES IN SCHEMA BDW_DIM to dwadm2;
grant all ON ALL TABLES IN SCHEMA BDW_ADL to dwadm2;

grant select ON ALL TABLES IN SCHEMA BDW_ADL to Rptusr1;

--报表用户权限

grant select ON ALL TABLES IN SCHEMA BDW_ADL to rptusr2;
grant select ON ALL TABLES IN SCHEMA BDW_DIM to rptusr2;

/*************************************************
role
*************************************************/
--create rolse
create role R_BDWDIM_QRY;
create role R_BDWDIM_DML;

create role R_BDWBDL_QRY;
create role R_BDWBDL_DML;

create role R_BDWBKBDL_QRY;
create role R_BDWBKBDL_DML;

create role R_BDWFDL_QRY;
create role R_BDWFDL_DML;

create role R_BDWADL_QRY;
create role R_BDWADL_DML;



--建表语句的时候
--Granting Access to Database Roles
--Grant privileges to the new role on the comments table:
GRANT SELECT ON   BDW_FDL.FDL_T02_BINDCARD_JOURNAL TO R_BDWFDL_QRY;
GRANT SELECT,INSERT,UPDATE,DELETE ON   BDW_FDL.FDL_T02_BINDCARD_JOURNAL TO R_BDWFDL_DML;



/*****************************************
select * from roles
where name in
('r_bdwdim_qry',
'r_bdwdim_dml',
'r_bdwbdl_qry',
'r_bdwbdl_qry',
'r_bdwbkbdl_qry',
'r_bdwbkbdl_dml',
'r_bdwfdl_qry',
'r_bdwfdl_dml',
'r_bdwadl_qry',
'r_bdwadl_dml')

45035996289222368	r_bdwadl_qry
45035996289222370	r_bdwadl_dml
45035996289222372	r_bdwbdl_qry
45035996289222376	r_bdwfdl_qry
45035996289222378	r_bdwfdl_dml
45035996289222380	r_bdwbkbdl_qry
45035996289222382	r_bdwbkbdl_dml
45035996289222384	r_bdwdim_qry
45035996289222386	r_bdwdim_dml
******************************************/
--grant role

grant role R_BDWBDL_QRY to  etlusr2;
grant role R_BDWBKBDL_QRY to  etlusr2;
grant role R_BDWFDL_QRY to  dwadm2;
grant role R_BDWDIM_QRY to  dwadm2;
grant role R_BDWADL_QRY to  dwadm2;
grant role R_BDWFDL_QRY to  rptusr2;
grant role R_BDWDIM_QRY to  rptusr2;
grant role R_BDWADL_QRY to  rptusr2;

grant role R_BDWBDL_DML to etlusr2;
grant role R_BDWBKBDL_DML to  etlusr2;
grant role R_BDWFDL_DML to  dwadm2;
grant role R_BDWDIM_DML to  dwadm2;
grant role R_BDWADL_DML to dwadm2;  