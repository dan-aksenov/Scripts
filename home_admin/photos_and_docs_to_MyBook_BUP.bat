chcp 1251
set log=d:\tmp
IF NOT EXIST %log% MD %log%

rem Exclude folders
set excl=YandexDisk "VirtualBox VMs" torrent Desktop Downloads

rem robocopy parameters for list and copy commands
set list_prm=/l /mir /njh /ndl /nfl
set copy_prm=/TEE /z /MIR /mt

rem backup to backup old
set src=K:\HOME_BUP
set dst=K:\HOME_BUP_OLD
robocopy %src% %dst% *.* /xd %excl% %list_prm%

pause

robocopy %src% %dst% *.* /unilog:"%log%\home_to_old.log" /xd %excl% %copy_prm%

pause

rem backup itself
set src="d:\Users\Данила"
set dst=K:\HOME_BUP
robocopy %src% %dst% *.* /xd %excl% %list_prm%

pause

robocopy %src% %dst% *.* /unilog:"%log%\home_to_mybook.log" /xd %excl% %copy_prm%

pause
