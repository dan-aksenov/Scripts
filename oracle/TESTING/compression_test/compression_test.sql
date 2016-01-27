set linesize 500
spoo log\&1._&2..log

alter index &1..&3. rebuild nocompress online;
select sum(bytes)/1024/1024 MB from dba_segments where owner = '&1.' and segment_type like 'INDEX%' and segment_name = '&3.';

set timi on
--set autotrace on
select /*+ INDEX(a &3.)*/ count(*) from &1..&2. a;
delete from &1..&2.;
rollback;
--set autotrace off
set timi off

alter index &1..&3. rebuild compress advanced low online;
select sum(bytes)/1024/1024 MB from dba_segments where owner = '&1.' and segment_type like 'INDEX%' and segment_name = '&3.';

set timi on
--set autotrace on
select /*+ INDEX(a &3.)*/ count(*) from &1..&2. a;
delete from &1..&2.;
rollback;
--set autotrace off
set timi off

spoo off
exit