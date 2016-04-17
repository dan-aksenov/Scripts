chcp 1251

rem todo: add options for incr and full

set log=d:\tmp

IF NOT EXIST %log% MD %log%

robocopy K:\HOME_BUP K:\HOME_BUP_OLD *.* /e /unilog:"%log%\home_to_old.log" /xd YandexDisk /TEE /z /purge

set src="d:\Users\Данила"

robocopy %src% K:\HOME_BUP *.* /e /unilog:"%log%\home_to_mybook.log" /xd YandexDisk /TEE /z /purge

rem since full home is backedup not document section excluded.
rem set src="d:\Users\Данила\Documents"
rem robocopy %src% "K:\Мои документы" *.* /s /unilog:"%log%\docs_to_mybook.log" /xf Thumbs.db /TEE /z /purge

pause
