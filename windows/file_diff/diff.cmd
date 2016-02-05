@echo off

set src=source_srv

ping %1 /n 1 || (echo workstation is OFFLINE >"log\%1.log" & goto end)

FOR /F "tokens=2,3" %%A IN ('ping %1 -n 1 -4') DO IF "from"== "%%A" set "IP=%%~B"
set dst=\\%IP:~0,-1%\dir


net use %src% /user:user password
net use %dst% /user:user password || (echo "net use failed" > "log\%1.log" & goto end)

echo null > temp\%1.lock

robocopy %src% %dst% *.* /e /XF Thumbs.db /r:1 /w:1 /LOG:"log\%1.log" /NP /NDL /L /NJH /NJS /BYTES /X

net use %dst% /delete /y
net use %src% /delete /y

del temp\%1.lock

:END
exit