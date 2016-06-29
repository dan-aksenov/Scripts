set echo off verify off serveroutput on size 100000
host if not exist .\temp\ md .\temp\

spo .\temp\cre_group_&1..log


connect repadmin/rep095@HP01

begin
  DBMS_REPCAT.CREATE_MASTER_REPGROUP('&1.', '&1.', NULL, NULL);
end;
/

spo off
exit