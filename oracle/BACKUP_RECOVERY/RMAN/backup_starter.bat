rem starts rman backup choosing appropriate cmd file basing on tag parameter
rem tags: 0,1,arch (for level 0,1 and archivelog backups)

set tag=%1

set OFFSITE=
set BKP_DIR=

rem send old logs to zip
set log=%time:~0,2%%time:~3,2%%time:~6,2%_%date:~-10,2%%date:~-7,2%%date:~-4,4%_%tag%.log
zip -g old_logs.zip *%tag%.log
del *%tag%.log -y

rem actual rman backup
rman target / @backup%tag%.cmd LOG='%log%'

rem backup backups to remote server.

net use %OFFSITE% /user:localhost\dbax p@S$w0rd
robocopy %BKP_DIR% %OFFSITE% *.* /z /s /MIR /mt /log:.\remote_backup.log
net use %OFFSITE% /delete

exit