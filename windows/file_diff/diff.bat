if not exist log md log
if not exist temp md temp

rem clear previous locks
del temp\*.lock
del log\*

set src=source_server

net use \\%src%\source_dir /user:user p@s$W0rd

for /f %%i in (serves.txt) do start /MIN call diff.cmd %%i

:StartLoop
ping 127.0.0.1 /n 5
if exist temp\*.lock GoTo :StartLoop

findstr /r "Older\> Newer\> New\>" "log\*.log" > log\SOFT_STAT.txt

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -file .\replace_fin.ps1 "log\SOFT_STAT.txt"

net use \\%src%\source_dir /delete /YES

copy  log\PROM_SOFT_STAT.txt c:\ext_tbls\

del c:\ext_tbls\*.log

exit