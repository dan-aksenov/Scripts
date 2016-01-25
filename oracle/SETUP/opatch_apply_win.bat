rem Variable section #########################################
set patch_name=numeric_patch_name
set oracle_home=path_to_home
set oracle_sid=ORCL
rem ##########################################################

set path=%oracle_home%\opatch;%oracle_home%\perl\bin;%path%
rem stop all listeners and instances associated with this home
lsnrctl stop
echo shutdown immediate | sqlplus / as sysdba
net stop OracleService%oracle_sid%
net stop OracleOraDB12Home1TNSListener
rem also stop other oracle thm (scheduler, vss etc...)
net stop OracleRemExecServiceV2
net stop OracleVssWriter%oracle_sid%

sc config Winmgmt start= disabled
net stop msdtc
net stop winmgmt

cd %patch_name%
opatch apply

rem if needed run catbundle
rem catbundle.sql

sc config Winmgmt start= auto
net start msdtc
net start winmgmt
net start OracleRemExecServiceV2
net start OracleVssWriter%oracle_sid%
net start OracleService%oracle_sid%
net start OracleOraDB12Home1TNSListener

lsnrctl start
echo startup | sqlplus / as sysdba
rem if pdbs
echo alter pluggable database all open | sqlplus / as sysdba
cd %ORACLE_HOME%/OPatch
run datapatch -verbose