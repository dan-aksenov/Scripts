chcp 1251

set log="d:\TMP"
set src="j:\Home_video_backup"

IF NOT EXIST %log% MD %log%

set dst="\\wdmycloud\danila\!BUPS\homevideos\Home_video_backup"

robocopy %src% %dst% *.* /s /unilog:%log%\photo_to_Ya.log /z /purge

forfiles -p %log% -s -m *.* /D -10 /C "cmd /c del @path"
 
pause
