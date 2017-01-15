chcp 1251

set log_dir=d:\TMP

IF NOT EXIST %log_dir% MD %log_dir%

set src="d:\Users\Данила\Pictures\Мои фотографии"
set dst="d:\Users\Данила\YandexDisk\!BUPS\fotos\Мои фотографии"
set log=/unilog:"%log_dir%\photo_to_Ya.log"

robocopy %src% %dst% *.* %log% /tee /z /mir /mt

pause

set src="d:\Users\Данила\Pictures\Мои фотографии"
set dst="\\Wdmycloud\danila\!BUPS\fotos\Мои фотографии"
set log=/unilog:"%log_dir%\photo_to_mycloud.log"
robocopy %src% %dst% *.* %log% /tee /z /mir /mt

rem forfiles -p %log% -s -m *.* /D -10 /C "cmd /c del @path"
 
pause
