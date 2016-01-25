rem very simple export script for logical backup on windows
set arch=%date:~-10,2%%date:~-7,2%%date:~-4,4%

exp userid= '"sys/passwd as sysdba'"  full=y log=log.txt direct=y

rar a -parchpasswd %arch% -m5 expdat.dmp log.txt
move %arch%.rar dumps\

rem delete older dumps
forfiles -p ".\dumps" -s -m *.* /D -30 /C "cmd /c del @path"
