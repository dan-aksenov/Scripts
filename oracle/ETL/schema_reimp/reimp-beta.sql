declare
V_CMD varchar2(2000);
V_IMP number;
V_APP varchar2(4):='N';

begin
dbms_outupt.put_line('schema &1. will be deleted enter N to abort');
V_APP:='&3.';
if V_APP='N' then EXIT;
else
dbms_outupt.put_line('killing &&1. if connected');
select   'alter system kill session '''||sid||','||SERIAL#||'''' into V_CMD from V$SESSION where USERNAME='&&1.';
execute immediate V_CMD;
DBMS_OUTUPT.PUT_LINE('droping &&1. if exists');
execute immediate 'drop user &&1. cascade';

-- Wait for as long as it takes for all the sessions to go away
  LOOP
    SELECT COUNT(*)
      INTO l_cnt
      FROM v$session
     WHERE username = 'ABC_USER';
    EXIT WHEN l_cnt = 0;
    dbms_lock.sleep( 10 );
  END LOOP; 

-- Import
imp :=
   DBMS_DATAPUMP.open (operation   => 'IMPORT',
                          JOB_MODE    => 'SCHEMA',
                          remote_link => &2.,
                          job_name    => 'IMP_&&1.',
                          version     => 'COMPATIBLE');
   DBMS_DATAPUMP.metadata_filter (handle   => V_imp,
                                  name     => 'SCHEMA_EXPR',
                                  VALUE    => 'like (''&&1.'')');

   DBMS_DATAPUMP.add_file (handle      => h1,
                           FILENAME    => 'MYTEST.LOG',
                           directory   => 'DATAPUMP_DIR',
                           filetype    => 3);
   DBMS_DATAPUMP.START_JOB (h1);
EXCEPTION WHEN OTHERS THEN dbms_output.put_line (SQLERRM);
END;
/