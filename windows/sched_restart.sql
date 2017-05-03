-- win scheduler restart
conn dba/psw
spoo restart.log
exec dbms_java.set_output(10000);
exec rc('SC STOP SCHEDULE');
exec rc('SC START SCHEDULE');
spoo off
exit