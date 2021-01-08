rem REDO THIS IN PS. like DOCS.
chcp 1251

set log="e:\TMP"
set src="F:\Users\danila\Videos"

IF NOT EXIST %log% MD %log%

set dst="\\wdmycloud\danila\!BUPS\Videos"

rem get difference
robocopy %src% %dst% *.* /s /purge /l /nfl /njh /ndl
pause

rem copy itself
robocopy %src% %dst% *.* /unilog:%log%\video_to_mycloud.log /tee /z /purge /s
 
pause
