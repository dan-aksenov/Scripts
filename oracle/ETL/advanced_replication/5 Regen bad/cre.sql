select 'sqlplus -s /nolog @REGEN HP01 '||sname||' '||oname
from dba_repobject@BYT
where (REPLICATION_TRIGGER_EXISTS='N' or INTERNAL_PACKAGE_EXISTS='N') and sname in  (select gname from dba_repsites@HP01 where masterdef='Y' and dblink='HP01') 
order by sname;