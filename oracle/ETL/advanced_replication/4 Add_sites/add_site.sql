set echo off verify off serveroutput on size 100000
host if not exist .\temp\ md .\temp\

spo .\temp\add_site_&2._&1..log


connect repadmin/rep095@HP01


declare
  USE_EXISTING_OBJECTS boolean := sys.DIUTIL.INT_TO_BOOL(1);
  COPY_ROWS boolean := sys.DIUTIL.INT_TO_BOOL(0);
BEGIN
   DBMS_REPCAT.ADD_MASTER_DATABASE(
     gname => '&1.',
     master => '&2',
     use_existing_objects => USE_EXISTING_OBJECTS,
     copy_rows => COPY_ROWS,
     propagation_mode => 'ASYNCHRONOUS');
END;
/


spo off
exit