set ver off
spo .\temp\&1._&2._&3..lst
CONNECT REPADMIN/REP095@&1

DECLARE
   use_existing_object   BOOLEAN:= SYS.DIUTIL.int_to_bool (1);
   retry                 BOOLEAN := SYS.DIUTIL.int_to_bool (0);
   copy_rows             BOOLEAN := SYS.DIUTIL.int_to_bool (0);
BEGIN
   DBMS_REPCAT.create_master_repobject ('&2.',
                                        '&3.',
                                        'TABLE',
                                        use_existing_object,
                                        NULL,
                                        NULL,
                                        retry,
                                        copy_rows,
                                        '&2.'  -- !_COP!
                                       );
END;
/

DECLARE
   v_send   BOOLEAN := SYS.DIUTIL.int_to_bool (0);
   stream VARCHAR2(32000);
   j NUMBER;
   tab1 DBMS_UTILITY.uncl_array; 
BEGIN
   SELECT COLUMN_NAME BULK COLLECT INTO tab1 FROM dba_tab_columns WHERE owner='&2.' AND table_name='&3.'
   MINUS
   SELECT COLUMN_NAME FROM dba_cons_columns WHERE owner='&2.' AND table_name='&3.' AND constraint_name IN ( 
   (SELECT  constraint_name FROM dba_constraints WHERE owner='&2.' AND table_name='&3.' AND constraint_type='P'));

   dbms_utility.table_to_comma(tab1,j,stream); 

    
   DBMS_REPCAT.send_old_values ('&2',
                                '&3.',
                        	stream,
                                '*',
                                v_send
                               );
END;
/

DECLARE
   v_compare   BOOLEAN := SYS.DIUTIL.int_to_bool (0);
   stream VARCHAR2(32000);
   j NUMBER;
   tab1 DBMS_UTILITY.uncl_array; 
BEGIN
   SELECT COLUMN_NAME BULK COLLECT INTO tab1 FROM dba_tab_columns WHERE owner='&2.' AND table_name='&3.'
   MINUS
   SELECT COLUMN_NAME FROM dba_cons_columns WHERE owner='&2.' AND table_name='&3.' AND constraint_name IN ( 
   (SELECT  constraint_name FROM dba_constraints WHERE owner='&2.' AND table_name='&3.' AND constraint_type='P'));

   dbms_utility.table_to_comma(tab1,j,stream); 

   DBMS_REPCAT.compare_old_values ('&2.',
                                   '&3',
				    stream,
                                   '*',
                                   v_compare
                                  );
END;
/


DECLARE
   DISTRIBUTED              BOOLEAN := SYS.DIUTIL.int_to_bool (NULL);
   min_communication        BOOLEAN
                               := SYS.DIUTIL.int_to_bool (1);
   generate_80_compatible   BOOLEAN
                          := SYS.DIUTIL.int_to_bool (0);
BEGIN
   DBMS_REPCAT.generate_replication_support ('&2.',
                                             '&3.',
                                             'TABLE',
                                             NULL,
                                             NULL,
                                             DISTRIBUTED,
                                             NULL,
                                             min_communication,
                                             generate_80_compatible
                                            );
END;
/

BEGIN
   DBMS_REPCAT.register_statistics ('&2.', '&3.');
END;
/

spo off
exit
