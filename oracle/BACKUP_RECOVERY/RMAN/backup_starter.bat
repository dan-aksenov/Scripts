rem tags: 0,1,arch (for level 0,1 and archivelog backups)

set tag=%1

rem send old logs to zip
set log=%time:~0,2%%time:~3,2%%time:~6,2%_%date:~-10,2%%date:~-7,2%%date:~-4,4%_%tag%.log
zip -g old_logs.zip *%tag%.log
del *%tag%.log -y

rem actual rman backup
rman target / @backup%tag%.cmd LOG=%log%

rem backup backups to remote server. (to do: add by parameters)
net use \\fs1\d$ /user:localhost\dbax dbax
robocopy c:\backup\rman \\fs1\d$\backup\THETA\ *.* /z /s /MIR /mt /log:.\backup_to_fs.log
net use \\fs1\d$ /delete
