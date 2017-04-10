rem name for archive file
set arch=%date:~-10,2%%date:~-7,2%%date:~-4,4%

rem daily or weekly backup
set tag=backup_week

rem directories
set backup_dir=d:\%tag%\dumps
set remote_dir=\\192.168.1.250\db_backups\%tag%

rem expdp and archive
rem ORACLE directory with %tag% -name presumed existing.
expdp '"sys/passwd as sysdba'"  full=y directory=%tag%
rar a -pfilatoff %backup_dir%\%arch% -m5 -df %backup_dir%\expdat.dmp %backup_dir%\export.log

rem delete old dumps
forfiles -p "%backup_dir% -s -m *.* /D -40 /C "cmd /c del @path"

rem copy to remote storage
robocopy %backup_dir% %remote_dir% *.rar /z /s /MIR /mt /log:.\backup_to_lkk.log