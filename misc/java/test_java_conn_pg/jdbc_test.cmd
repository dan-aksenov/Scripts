@set dr=%cd%
@cd "c:\Program Files\Java\jdk1.7.0_67\bin\"
@java -cp %dr%\postgresql-42.2.0.jar;%dr% %1
@pause