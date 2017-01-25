rem Script create basebackup of PG claster.

rem User supplied variables.

set LC_MESSAGES=en

set hst=localhost
set prt=5432
set usr=postgres
rem set fmt=c
rem set base=%1
rem Delete files older then keep
set keep=30

set OFFSITE=\\192.168.1.250\db_backups\Postgres
set BKP_DIR=D:\postgres_bkp\basebackup\backup
set ARC_DIR=D:\postgres_bkp\basebackup\arch

rem Variables for timestamp and file names.
set stamp=%time:~0,2%%time:~3,2%%time:~6,2%_%date:~-10,2%%date:~-7,2%%date:~-4,4%
set dmp="%BKP_DIR%\%base%_%stamp%.backup"
set log="%BKP_DIR%\%base%_%stamp%.log"


rem Delete old files
forfiles -p %BKP_DIR% -s -m *.* /D -%keep% /C "cmd /c del @path"
forfiles -p %ARC_DIR% -s -m *.* /D -%keep% /C "cmd /c del @path"

rem Backup DB
IF NOT EXIST Backup MD Backup
mkdir %BKP_DIR%\%stamp%
pg_basebackup -l "basebackup_%stamp%" -U postgres -D %BKP_DIR%\%stamp% -F t -P -v -x -z

rem Error section
IF NOT %ERRORLEVEL%==0 GOTO Error
GOTO End

:Error
rem powershell -file mail.ps1 %log%

:End
rem Copy to FS
robocopy %BKP_DIR% %OFFSITE% *.* /z /s /MIR /mt /log:.\remote_backup.log
