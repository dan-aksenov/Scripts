spo .\temp\&1._imp3.log

conn user/password
set serveroutput on
begin
for i in 
(select table_name,constraint_name from dba_constraints where owner='&1' and constraint_type in ('R')
)
loop
begin
execute immediate 'ALTER TABLE &1..'||i.table_name||' ENABLE CONSTRAINT '||i.constraint_name;
dbms_output.put_line(i.table_name||' '||i.constraint_name||' enabled');
exception when others then dbms_output.put_line(i.table_name||' '||i.constraint_name||' '||sqlerrm);
end;
end loop;
end;
/

alter session set current_schema="&1";
exec DBMS_UTILITY.COMPILE_SCHEMA (schema  =>'&1.',compile_all     =>false);

spo off
exit