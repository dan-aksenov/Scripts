rem REDO THIS IN PS. like DOCS.
chcp 1251
set log=d:\tmp
IF NOT EXIST %log% MD %log%

rem Exclude folders
set excl=YandexDisk "VirtualBox VMs" torrent Desktop Downloads

rem robocopy parameters for list and copy commands
set list_prm=/l /mir /njh /ndl /nfl
set copy_prm=/TEE /z /MIR /mt

set src=K:\HOME_BUP
set dst=K:\HOME_BUP_OLD

rem list diff summary for backup old
robocopy %src% %dst% *.* /xd %excl% %list_prm%

pause
rem backup to backup old
robocopy %src% %dst% *.* /unilog:"%log%\home_to_old.log" /xd %excl% %copy_prm%

pause


set src="d:\Users\Данила"
set dst=K:\HOME_BUP

rem list diff summary for backup
robocopy %src% %dst% *.* /xd %excl% %list_prm%

pause
rem backup itself
robocopy %src% %dst% *.* /unilog:"%log%\home_to_mybook.log" /xd %excl% %copy_prm%

pause
