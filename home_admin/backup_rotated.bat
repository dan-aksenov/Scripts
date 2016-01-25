set SRC_PATH=%1
set DST_PATH=%2
SET LOG=%date:~-10,2%%date:~-7,2%%date:~-4,4%.log
SET LOG_DIR=%DST_PATH%\BACKUP_LOG

IF NOT EXIST %LOG_DIR% MD %LOG_DIR%

ECHO copy current to previous >> %LOG_DIR%\%log%
robocopy %DST_PATH%\CURRENT %DST_PATH%\PREVIOUS /LOG+:%LOG_DIR%\%log% /NFL /NP /NDL /MIR /Z /TEE	

ECHO backup source to current  >> %LOG_DIR%\%log%
robocopy %SRC_PATH% %DST_PATH%\CURRENT /LOG+:%LOG_DIR%\%log% /NFL /NP /NDL /MIR /Z /TEE

rem clean old logs
forfiles -p "%LOG_DIR%" -s -m *.log /D -365 /C "cmd /c del @path"

exit