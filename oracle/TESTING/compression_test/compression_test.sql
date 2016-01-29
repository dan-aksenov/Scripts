WHENEVER SQLERROR EXIT
set serveroutput on
set term off
SET VER OFF
set linesize 500

grant dba to COMP_TEST identified by test;
alter session set current_schema=COMP_TEST;

--TEST SETUP
create table COMP_TEST.&2. as select * from &1..&2. where 1=0;
declare
l_ddl varchar2(4000);
begin
l_ddl:= cast(replace(dbms_metadata.get_ddl( 'INDEX', '&3.','&1.'),'&1.','COMP_TEST') as varchar2);
--dbms_output.put_line(l_ddl);
execute immediate l_ddl;
end;
/

alter index COMP_TEST.&3. rebuild nocompress online;
spoo log\&1._&2._&3..log
PROMPT Testing compression for User &1. Table &2. Index &3.
set timi on
--set autotrace on
PROMPT Notcompressed index Insert
insert into COMP_TEST.&2. (select * from &1..&2.);
set timi off
commit;
exec dbms_stats.gather_table_stats(ownname=>'COMP_TEST', tabname=>'&2.');
select 'Not compressed index Size(MB):'||sum(bytes)/1024/1024 MB from dba_segments where owner = 'COMP_TEST' and segment_type like 'INDEX%' and segment_name = '&3.';
set timi on
PROMPT Not compressed index Select
select /*+ INDEX(a &3.)*/ count(*) from COMP_TEST.&2. a;
PROMPT Not compressed index Delete
delete from COMP_TEST.&2.;
PROMPT TAG1
set timi off
commit;
--set autotrace off

alter index COMP_TEST.&3. rebuild compress advanced low online;
set timi on
--set autotrace on
PROMPT Compressed index Insert
insert into COMP_TEST.&2. (select * from &1..&2.);
set timi off
commit;
exec dbms_stats.gather_table_stats(ownname=>'COMP_TEST', tabname=>'&2.');
select 'Compressed index Size(MB):'||sum(bytes)/1024/1024 MB from dba_segments where owner = 'COMP_TEST' and segment_type like 'INDEX%' and segment_name = '&3.';
set timi on
PROMPT Compressed index Select
select /*+ INDEX(a &3.)*/ count(*) from COMP_TEST.&2. a;
PROMPT Compressed index Delete
delete from COMP_TEST.&2.;
set timi off
commit;
--set autotrace off

drop user COMP_TEST cascade;

spoo off
exit