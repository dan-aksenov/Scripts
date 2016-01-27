set linesize 500
spoo log\&1._&2..log

PROMPT TEST SETUP
create table &1..&2._DBAX as select * from &1..&2.;
declare
l_ddl varchar2(4000);
begin
l_ddl:= cast(replace(replace(dbms_metadata.get_ddl( 'INDEX', '&3.','&1.'),'&3.','&3._DBAX'),'&2.','&2._DBAX') as varchar2);
execute immediate substr(l_ddl);
end;
/

PROMPT NOCOMPRESSION
alter index &1..&3._DBAX rebuild nocompress online;
select sum(bytes)/1024/1024 MB from dba_segments where owner = '&1.' and segment_type like 'INDEX%' and segment_name = '&3._DBAX';

set timi on
--set autotrace on
insert into &1..&2._DBAX as select * from &1..&2.;
commit;
exec dbms_stats.gather_table_stats(ownname=>'&1.', tabname=>'&3._DBAX');
select /*+ INDEX(a &3._DBAX)*/ count(*) from &1..&2._DBAX a;
delete from &1..&2._DBAX;
commit;
--set autotrace off
set timi off

PROMPT COMPRESSION
alter index &1..&3._DBAX rebuild compress advanced low online;
select sum(bytes)/1024/1024 MB from dba_segments where owner = '&1.' and segment_type like 'INDEX%' and segment_name = '&3._DBAX';

set timi on
--set autotrace on
insert into &1..&2._DBAX as select * from &1..&2.;
commit;
exec dbms_stats.gather_table_stats(ownname=>'&1.', tabname=>'&2._DBAX');
select /*+ INDEX(a &3._DBAX)*/ count(*) from &1..&2._DBAX a;
delete from &1..&2._DBAX;
commit;
--set autotrace off
set timi off

drop index &3._DBAX;
drop table &2._DBAX;

spoo off
exit