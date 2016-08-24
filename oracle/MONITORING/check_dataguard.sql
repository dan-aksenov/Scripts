set head off
set linesize 500

select 'DATABASE_NAME -'||global_name from global_name;

PROMPT DATAGUARD STATS
select name,value,time_computed from gv$dataguard_stats;

PROMPT MANAGED STANDBY
select client_process,process,thread#,sequence#,status from gv$managed_standby where CLIENT_PROCESS='LGWR' OR PROCESS='MRP0' order by process;

exit