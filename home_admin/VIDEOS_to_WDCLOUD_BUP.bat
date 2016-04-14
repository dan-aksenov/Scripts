chcp 1251

set log="d:\TMP"
set src="h:\Users\Данила\Videos"

IF NOT EXIST %log% MD %log%

set dst="\\wdmycloud\danila\!BUPS\homevideos"

robocopy %src% %dst% *.* /s /unilog:%log%\video_to_mycloud.log /z /purge

forfiles -p %log% -s -m *.* /D -10 /C "cmd /c del @path"
 
pause
