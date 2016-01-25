rem #######################################
rem remote archiving with copy and datapump
rem #######################################
rem variable section
set rem_hst=my-remote-host
set rem_dir=oracle\ora11\RDBMS\log
set rem_usr=localhost\dbax
set rem_psw=p@$Sw0rd
set ora_cred=dbax/dbax
rem passwords on both hosts presumed to be the same :)
rem #######################################
rem remote datapump export and archiving
expdp %ora_cred%@%rem_hst% dumpfile=%1.dmp schemas=%1 logfile=%1.log reuse_dumpfiles=yes
wmic /node:"%rem_hst%" /user:%rem_usr% /password:"%rem_psw%" process call create "zip E:\%rem_dir%\%1.zip E:\%rem_dir%\%1.dmp"
rem #######################################
rem copy
net use \\%rem_hst%\e$ /user:%rem_usr% %rem_psw%
:copy
copy \\%rem_hst%\e$\%rem_dir%\%1.zip c:\app\oracle\datapump\ /z
if  %ERRORLEVEL%  NEQ 0 goto :copy
net use \\%rem_hst%\e$ /delete
rem #######################################
rem import
unzip -j c:\app\oracle\admin\orcl\dpdump\%1.zip -d c:\app\oracle\admin\orcl\dpdump\
impdp %ora_cred% dumpfile=%1.dmp schemas=%1 logfile=%1.log directory=DataPump
rem #######################################
rem clear trash
del c:\app\oracle\admin\orcl\dpdump\%1.zip
wmic /node:"%rem_hst%" /user:%rem_usr% /password:"%rem_psw%" process call create "cmd /c del E:\%rem_dir%\%1.zip E:\%rem_dir%\%1.dmp"
rem #######################################