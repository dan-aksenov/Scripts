@echo off
set ORACLE_SID=gamma2
set ORACLE_HOME=G:\oracle\ora11204
set prim_db=gamma2
set std_db=gamma2_std
set cred=sys/pswd

echo ####################################################################################################
echo Refresh started at %time% 
echo .
echo ####################################################################################################

rem check current mode
%ORACLE_HOME%\bin\dgmgrl %cred%@%prim_db% "show database %std_db%" > log\role.tmp
for /f "tokens=2 delims= " %%i in ('find "Role" log\role.tmp') do set role=%%i
echo DEBUG: Database is in %role% Standby mode.
if %role% == SNAPSHOT goto :switch
if %role% == PHYSICAL goto :wait

:switch
%ORACLE_HOME%\bin\dgmgrl %cred%@%prim_db% "convert database %std_db% to %role% standby"
echo 
echo  Now we are waiting for apply to finish. It'll take some time.
echo ...

:wait 
ping 127.0.0.1 -n 30 >null
%ORACLE_HOME%\bin\dgmgrl %cred%@gamma2 "show database gamma2_std" > log\lag.tmp

for /f "tokens=3 delims= " %%i in ('find "Transport Lag" log\lag.tmp') do set tlag=%%i
echo DEBUG: Transport lag: %tlag%
if %tlag% neq 0 goto :wait

for /f "tokens=3 delims= " %%i in ('find "Apply Lag" log\lag.tmp') do set alag=%%i
echo DEBUG: Apply lag: %alag%
if %alag% neq 0 goto :wait

%ORACLE_HOME%\bin\dgmgrl %cred%@gamma2 "show database gamma2_std" | find "Lag"
echo Redo apply finished. Converting back to snapshot standby.

rem check current mode
%ORACLE_HOME%\bin\dgmgrl %cred%@%prim_db% "show database %std_db%" > log\role.tmp
for /f "tokens=2 delims= " %%i in ('find "Role" log\role.tmp') do set role=%%i
echo DEBUG: Database is in %role% Standby mode.
if %role% == SNAPSHOT goto :end

%ORACLE_HOME%\bin\dgmgrl %cred%@%prim_db% "convert database %std_db% to %role% standby"

echo ####################################################################################################
echo Refresh finished at %time%
echo .
echo ####################################################################################################