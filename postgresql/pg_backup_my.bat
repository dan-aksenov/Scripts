rem Script dumps PG database into file named as db_name_date_time.
rep password supplied via password file: "Appdata\Roaming\postgresql\pgpass.conf"

rem User supplied variables.
set hst=localhost
set prt=5432
set usr=postgres
set fmt=c
set base=TESK_LKK
rem Delete files older then keep
set keep=30

rem Variables for timestamp and file names.
set stamp=%time:~0,2%%time:~3,2%%time:~6,2%_%date:~-10,2%%date:~-7,2%%date:~-4,4%
set dmp=%base%_%stamp%.backup
set log=%base%_%stamp%.log


rem Delete old files
forfiles -p . -s -m *.* /D -%keep% /C "cmd /c del @path"

rem Backup DB
pg_dump -h %hst% -p %prt% -U "%usr%" -w -F %fmt% -b -v -f "%dmp%" "%base%" 2>"%log%"

rem Error section
IF NOT %ERRORLEVEL%==0 GOTO Error
GOTO End

rem :Error
powershell -file mail.ps1 %log%


:End