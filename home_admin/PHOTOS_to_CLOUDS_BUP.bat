rem REDO THIS IN PS. like DOCS.
chcp 1251

rem logging directory
set log_dir=E:\TMP
IF NOT EXIST %log_dir% MD %log_dir%

rem set source
set src="F:\Users\danila\Pictures\Мои фотографии"

rem set YandexDisk destination
set dst="E:\Users\danila\YandexDisk\!BUPS\fotos\Мои фотографии"
set log=/unilog:"%log_dir%\photo_to_Ya.log"

robocopy %src% %dst% *.* %log% /tee /z /mir /mt
pause

rem set Wdmycloud destination
set dst="\\Wdmycloud\danila\!BUPS\fotos\Мои фотографии"
set log=/unilog:"%log_dir%\photo_to_mycloud.log"
robocopy %src% %dst% *.* %log% /tee /z /mir /mt
 
pause
