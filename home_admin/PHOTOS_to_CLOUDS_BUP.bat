chcp 1251

set log_dir="d:\TMP"

IF NOT EXIST %log_dir% MD %log_dir%

rem set dst="d:\Users\Данила\YandexDisk\!BUPS"
rem set log=%log_dir%\photo_to_Ya.log
rem start call %cp_cmd%

set src="d:\Users\Данила\Pictures\Мои фотографии"
set dst="\\Wdmycloud\danila\!BUPS\fotos\Мои фотографии"
set log=%log_dir%\photo_to_mycloud.log
robocopy %src% %dst% *.* %cp_prm% /unilog:%log% /tee /z /purge /s /mt /xd YandexDisk

rem forfiles -p %log% -s -m *.* /D -10 /C "cmd /c del @path"
 
pause
