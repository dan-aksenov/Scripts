chcp 1251
set log=d:\tmp
IF NOT EXIST %log% MD %log%

set excl=YandexDisk "VirtualBox VMs" torrent Desktop Downloads

set src=K:\HOME_BUP
set dst=K:\HOME_BUP_OLD
robocopy %src% %dst% *.* /xd %excl% /l /mir /njh /ndl /nfl
pause
robocopy %src% %dst% *.* /unilog:"%log%\home_to_old.log" /xd %excl% /TEE /z /MIR /mt
pause

set src="d:\Users\Данила"
set dsc=K:\HOME_BUP
robocopy %src% %dst% *.* /xd %excl% /l /mir /njh /ndl /nfl
pause
robocopy %src% %dst% *.* /unilog:"%log%\home_to_mybook.log" %excl% /TEE /z /MIR /mt
pause
