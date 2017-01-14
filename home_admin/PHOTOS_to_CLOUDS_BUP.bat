chcp 1251

rem todo: add options for incr and full

set log_dir="d:\TMP"
set src="d:\Users\Данила"
set cp_prm="/z /purge /mt /xd YandexDisk"

IF NOT EXIST %log% MD %log%

set dst="d:\Users\Данила\YandexDisk\!BUPS"
set log=%log_dir%\photo_to_Ya.log
start call robocopy %src% %dst% *.* /s /unilog:%log% %cp_prm%

set dst="\\wdmycloud\danila\!BUPS"
set log=%log_dir%\photo_to_mycloud.log
start call robocopy %src% %dst% *.* /s /unilog:%log% %cp_prm%

rem forfiles -p %log% -s -m *.* /D -10 /C "cmd /c del @path"
 
pause
