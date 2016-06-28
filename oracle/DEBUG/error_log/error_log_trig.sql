spo .\temp\err_&1..log

conn system/man01@&1.



CREATE OR REPLACE TRIGGER REPADMIN.TR_APPLICATION_ERR
AFTER servererror
ON DATABASE
DECLARE
v_username VARCHAR2(30);
v_osuser VARCHAR2(30);
v_machine VARCHAR2(64);
v_process VARCHAR2(12);
v_program VARCHAR2(64);
v_ip VARCHAR2(64);
stmt VARCHAR2 (2000);
sql_text ora_name_list_t;
l VARCHAR2(2000);
BEGIN
  SELECT min(username) 
INTO v_username
FROM sys.v_$session
  where audsid =  sys_context( 'userenv', 'sessionid' ) and username is not null;
IF  (V_USERNAME = 'SYS' or  V_USERNAME ='') then null;
else
SELECT username, osuser, machine, process, program,(select   sys_context('USERENV', 'IP_ADDRESS') from dual)
INTO v_username, v_osuser, v_machine, v_process, v_program ,v_ip
FROM sys.v_$session
  where audsid =  sys_context( 'userenv', 'sessionid' )
and (username <> 'SYS' or  username <>'');
IF
((ora_is_servererror(4043)) OR (ora_is_servererror(1017)))
THEN
stmt := 'no error stack found';
ELSE
l := ora_sql_txt(sql_text);
FOR i IN 1..l LOOP
stmt :=stmt||sql_text(i);
END LOOP;
END IF;
IF (ora_is_servererror(918)) OR (ora_is_servererror(1446)) OR
(ora_is_servererror(1445))
THEN
NULL;
ELSE
FOR n IN 1..ora_server_error_depth LOOP
INSERT INTO repadmin.ERROR_LOG VALUES (repadmin.seq_db_error.NEXTVAL,
--ora_server_error(n),
SYSDATE, ora_login_user, v_osuser, v_machine, v_process,
v_program, v_ip,--ora_client_ip_address,
ora_server_error_msg(n),SUBSTR(stmt,1,900));
END LOOP;
END IF;
end if;
END tr_application_err;
/


select 1/0 from dual;

select ERR_SQL_TEXT from repadmin.error_log;

spo off


exit