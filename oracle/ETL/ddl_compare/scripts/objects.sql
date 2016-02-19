
prompt --ALL OBJECTS COMPARE
prompt /* MISSING OBJECTS
select object_type ||': '|| object_name from dba_objects@&2. where owner = '&1.' and object_name not like 'SYS%'
minus
select object_type ||': '|| object_name from dba_objects@&4. where owner = '&3.' and object_name not like 'SYS%';
prompt */

prompt /* SURPLUS OBJECTS
select object_type ||': '|| object_name from dba_objects@&4. where owner = '&3.' and object_name not like 'SYS%'
minus
select object_type ||': '|| object_name from dba_objects@&2. where owner = '&1.' and object_name not like 'SYS%';
prompt */