chcp 1251

set log="d:\TMP"
set src="h:\Users\Данила\Videos"

IF NOT EXIST %log% MD %log%

set dst="\\wdmycloud\danila\!BUPS\Videos"

robocopy %src% %dst% *.* /s /purge /l /nfl /njh /ndl
pause

robocopy %src% %dst% *.* /unilog:%log%\video_to_mycloud.log /z /purge /s
forfiles -p %log% -s -m *.* /D -10 /C "cmd /c del @path"
 
pause
