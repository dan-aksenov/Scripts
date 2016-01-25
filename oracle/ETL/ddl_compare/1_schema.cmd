@echo off
rem set NLS_LANG=RUSSIAN_CIS.RU8PC866

rem sqlplus -s /nolog @disable_fk %1 %4 

set /a tries = 0


if exist .\temp\attempts_%1_%2_%3.log del .\temp\attempts_%1_%2_%3.log

:BEGIN



tnsping %4 > nul || (echo %4 out of a coverage > .\temp\attempts_%1_%2_%3.log   & goto END)
tnsping %2 > nul || (echo %2 out of a coverage > .\temp\attempts_%1_%2_%3.log   & goto END)


set par6=%~6
set par7=%~7
set par8=%~8
set par9=%~9

if "%par6%" == "" set par6=X
if "%par7%" == "" set par7=X
if "%par8%" == "" set par8=X
if "%par9%" == "" set par9=X


set s_parallel=AUTO
set d_parallel=AUTO
set inc_ex=NONE


if "%par6:~0,2%" == "-s" set s_parallel=%par6:~2,10%
if "%par7:~0,2%" == "-s" set s_parallel=%par7:~2,10%
if "%par8:~0,2%" == "-s" set s_parallel=%par8:~2,10%
if "%par9:~0,2%" == "-s" set s_parallel=%par9:~2,10%

if "%par6:~0,2%" == "-d" set d_parallel=%par6:~2,10%
if "%par7:~0,2%" == "-d" set d_parallel=%par7:~2,10%
if "%par8:~0,2%" == "-d" set d_parallel=%par8:~2,10%
if "%par9:~0,2%" == "-d" set d_parallel=%par9:~2,10%

if "%par6:~0,2%" == "-i" set inc_ex=-i%par7%
if "%par7:~0,2%" == "-i" set inc_ex=-i%par8%
if "%par8:~0,2%" == "-i" set inc_ex=-i%par9%

if "%par6:~0,2%" == "-e" set inc_ex=-e%par7%
if "%par7:~0,2%" == "-e" set inc_ex=-e%par8%
if "%par8:~0,2%" == "-e" set inc_ex=-e%par9%

@echo on
set NLS_LANG=RUSSIAN_CIS.RU8PC866
sqlplus -s /nolog @ddl_comp.sql %1 %2 %3 %4 %5 %s_parallel% %d_parallel% %inc_ex%
@echo off


if %ERRORLEVEL%==0 goto END 
if %tries% equ 10 goto END



echo %tries%>>.\temp\attempts_%1_%2_%3.log
SET /A tries=%tries%+1
goto begin


:END
rem sqlplus -s /nolog @enable_fk %1 %4 
exit