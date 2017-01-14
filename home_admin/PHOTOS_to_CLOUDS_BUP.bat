chcp 1251

rem todo: add options for incr and full

set log_dir="d:\TMP"
rem set src="d:\Users\Данила"
set cp_prm=/z /purge /s /mt /unilog:%log% /xd YandexDisk
set cp_cmd=robocopy %src% %dst% *.* %cp_prm%

IF NOT EXIST %log% MD %log%

rem set dst="d:\Users\Данила\YandexDisk\!BUPS"
rem set log=%log_dir%\photo_to_Ya.log
rem start call %cp_cmd%

set src="d:\Users\Данила\Pictures\Мои фотографии"
set dst="z:\!BUPS\fotos\Мои фотографии"
set log=%log_dir%\photo_to_mycloud.log
start call %cp_cmd%

rem forfiles -p %log% -s -m *.* /D -10 /C "cmd /c del @path"
 
pause
