spo .\temp\err_&1..log

conn sys/orcl01@&1. as sysdba
--conn repadmin/rep095@&1.

grant select on sys.v_$session to repadmin;
conn repadmin/rep095@&1.

drop trigger REPADMIN.TR_APPLICATION_ERR; 
drop table REPADMIN.error_log;
drop SEQUENCE REPADMIN.SEQ_DB_ERROR;


CREATE TABLE REPADMIN.ERROR_LOG
(
ERR_ID NUMBER,
--ERR_NBR NUMBER(10),
ERR_DTTM DATE,
ERR_USERNAME VARCHAR2(30 BYTE),
ERR_OSUSER VARCHAR2(30 BYTE),
ERR_MACHINE VARCHAR2(64 BYTE),
ERR_PROCESS VARCHAR2(12 BYTE),
ERR_PROGRAM VARCHAR2(64 BYTE),
ERR_CLIENTIP VARCHAR2(50 BYTE),
ERR_MSG VARCHAR2(4000 BYTE),
ERR_SQL_TEXT VARCHAR2(4000 BYTE)
);



CREATE SEQUENCE REPADMIN.SEQ_DB_ERROR
START WITH 1
MAXVALUE 9999999999999999999999
MINVALUE 1
CYCLE
CACHE 20
NOORDER;


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
stmt VARCHAR2 (4000);
sql_text ora_name_list_t;
l VARCHAR2(4000);
BEGIN
  SELECT min(username)
INTO v_username
FROM sys.v_$session
  where audsid =  sys_context( 'userenv', 'sessionid' ) and username is not null;
IF  (V_USERNAME = 'SYS' or  V_USERNAME ='' or  V_USERNAME = 'SYSMAN') then null;
else
SELECT username, osuser, machine, process, program,(select   sys_context('USERENV', 'IP_ADDRESS') from dual)
INTO v_username, v_osuser, v_machine, v_process, v_program ,v_ip
FROM sys.v_$session
  where audsid =  sys_context( 'userenv', 'sessionid' )
and (username <> 'SYS' or  username <>'' or username <> 'SYSMAN'
);
IF
((ora_is_servererror(4043)) OR (ora_is_servererror(1017)))
THEN
stmt := 'no error stack found';
ELSE
l := ora_sql_txt(sql_text);
FOR i IN 1..l LOOP
if length(stmt||sql_text(i))<=4000 
then stmt :=stmt||sql_text(i);
else null;
end if;
END LOOP;
END IF;
IF 1=0 --(ora_is_servererror(918)) OR (ora_is_servererror(1446)) OR (ora_is_servererror(1445))
THEN
NULL;
ELSE
FOR n IN 1..ora_server_error_depth LOOP
INSERT INTO repadmin.ERROR_LOG VALUES (repadmin.seq_db_error.NEXTVAL,
--ora_server_error(n),
SYSDATE, ora_login_user, v_osuser, v_machine, v_process,
v_program, v_ip,--ora_client_ip_address,
SUBSTR(ora_server_error_msg(n),1,3900),SUBSTR(stmt,1,3900));
END LOOP;
END IF;
end if;
END tr_application_err;
/




select 1/0 from dual;

select ERR_SQL_TEXT from repadmin.error_log;

spo off


exit