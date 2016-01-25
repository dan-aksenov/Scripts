rem set nls_lang=russian_cis.CL8MSWIN1251
rem set nls_lang=russian_cis.ru8pc866
rem set nls_lang=russian_cis.UTF8
sqlldr dbax/dbax@mybase control=control.ctl data=in_file.csv skip=1
