chcp 1251

rem todo: add options for incr and full

set log="d:\TMP"

IF NOT EXIST %log% MD %log%

set src="d:\Users\Данила\Pictures\Мои фотографии"

robocopy %src% "K:\Мои фотографии" *.* /s /unilog:"%log%\photo_to_mybook.log" /xf Thumbs.db /TEE /z /purge

set src="d:\Users\Данила\Documents"

robocopy %src% "K:\Мои документы" *.* /s /unilog:"%log%\docs_to_mybook.log" /xf Thumbs.db /TEE /z /purge

pause
