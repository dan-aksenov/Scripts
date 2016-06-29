spo .\temp\conf_&1._&2._&3..lst
set ver off trims on
CONNECT REPADMIN/REP095@&1.


BEGIN
if '&3'='PROM_SUBABONENT_STATUS_HIST' then
 DBMS_REPCAT.ADD_UNIQUE_RESOLUTION(
 sname => '&2',
 oname => '&3',
 constraint_name => 'PROM_SUBABON_STATUS_HIST_KEY' ,
 sequence_no => 3,
 method => 'DISCARD',
 parameter_column_name => '*',
 function_name => NULL
);
else
 DBMS_REPCAT.ADD_UNIQUE_RESOLUTION(
 sname => '&2',
 oname => '&3',
 constraint_name => '&3._KEY' ,
 sequence_no => 3,
 method => 'DISCARD',
 parameter_column_name => '*',
 function_name => NULL
); 
end if;
END;
/


BEGIN
if '&3'='ACC_DELLOG' then
    DBMS_REPCAT.ADD_DELETE_RESOLUTION  (
      sname => '&2',
      oname => '&3',
      sequence_no => 4,
      parameter_column_name	=> 'ID_ROW',
      function_name		=> 'REPADMIN.DEL_IGNORE'
);
else
    DBMS_REPCAT.ADD_DELETE_RESOLUTION  (
      sname => '&2',
      oname => '&3',
      sequence_no => 4,
      parameter_column_name	=> 'ID_ABN',
      function_name		=> 'REPADMIN.DEL_IGNORE'
); 
end if; 
END;
/

BEGIN 
    DBMS_REPCAT.GENERATE_REPLICATION_SUPPORT (
      sname => '&2.',
      oname => '&3.', 
      type => 'TABLE',
      min_communication => TRUE); 
END;
/



BEGIN
   DBMS_REPCAT.register_statistics ('&2.', '&3');
END;
/
spo off
exit