chcp 1251

IF NOT EXIST "d:\TMP" MD "d:\TMP"

robocopy "\\wdmycloud\danila\!BUPS\homevideos\Home_video_backup" "e:\Home_video_backup" *.* /s /unilog:"d:\tmp\videos_to_e.log" /z /purge

forfiles -p "d:\tmp" -s -m *.* /D -10 /C "cmd /c del @path"
 
pause
