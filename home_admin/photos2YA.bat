rem chcp 1251

rem logging directory
set log_dir=D:\TMP
IF NOT EXIST %log_dir% MD %log_dir%

rem set source
set src="F:\Users\danila\Pictures\Мои фотографии"

rem set YandexDisk destination
set dst="D:\Users\danila\YandexDisk\!BUPS\fotos\Мои фотографии"
set log=/unilog:"%log_dir%\photo_to_Ya.log"

robocopy %src% %dst% *.* %log% /tee /z /mir
pause