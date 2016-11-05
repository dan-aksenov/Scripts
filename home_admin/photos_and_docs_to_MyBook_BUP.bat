chcp 1251

rem todo: add options for incr and full

set log=d:\tmp

IF NOT EXIST %log% MD %log%

set src=K:\HOME_BUP
set dst=K:\HOME_BUP_OLD
robocopy %src% %dst% *.* /e /unilog:"%log%\home_to_old.log" /xd YandexDisk "VirtualBox VMs"  /TEE /z /purge

set src="d:\Users\Данила"
set dsc=K:\HOME_BUP
robocopy %src% %dst% *.* /e /unilog:"%log%\home_to_mybook.log" /xd YandexDisk "VirtualBox VMs" /TEE /z /purge

pause
