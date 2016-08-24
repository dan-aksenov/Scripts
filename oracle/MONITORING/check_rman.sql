set head off
set linesize 500

select 'DATABASE_NAME -'||global_name from global_name;

PROMPT FULL BACKUPS LAST 7 DAYS
SELECT
b.status as "Status", 
TO_CHAR(b.start_time, 'MON DD, YYYY HH12:MI:SS PM') as "Start Time", 
b.input_type as "Type" 
FROM 
V$RMAN_BACKUP_JOB_DETAILS b where start_time > sysdate - 7 and input_type in ('DB INCR','DB FULL')
ORDER BY b.start_time DESC;    

PROMPT ARCHIVELOG BACKUPS LAST 6 HOURS
SELECT
b.status as "Status", 
TO_CHAR(b.start_time, 'MON DD, YYYY HH12:MI:SS PM') as "Start Time", 
b.input_type as "Type"
FROM 
V$RMAN_BACKUP_JOB_DETAILS b where start_time > sysdate - 6/24 and input_type = 'ARCHIVELOG'
ORDER BY b.start_time DESC;
exit