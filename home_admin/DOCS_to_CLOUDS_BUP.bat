chcp 1251

rem logging directory
set log_dir=F:\TMP
IF NOT EXIST %log_dir% MD %log_dir%

rem set source
set src="f:\Users\danila\Documents"

rem set Wdmycloud destination
set dst="\\WDMYCLOUD\danila\!BUPS\Documents"
set log=/unilog:"%log_dir%\photo_to_mycloud.log"

robocopy %src% %dst% *.* %log% /tee /z /mir /mt
 
pause
