if not exist tmp mkdir tmp

set archive=".\archive"
set staging=".\to_load"
set loaded=".\loaded"

rem get difference between archive and loaded files
robocopy %archive% %loaded% *.* -l -njh -njs -ndl -ns -tee -log:.\tmp\file.list

rem copy from archive to staging directory
FOR /F "tokens=4 delims= " %%i IN (.\tmp\file.list) do copy %%i %staging%

rem loading action here

rem move from staging to loaded
move %staging%\* %loaded%\