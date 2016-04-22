#send mail with file as body
param([string]$file)
$mailto=("dbax@dbax.ru","boss@dbax.ru)
$MailBody=[IO.File]::ReadAllText($file)
send-mailmessage -smtpserver 192.168.1.2 -from dbax-inform@dbax.ru -to $mailto -Subject "Subject" -Body $mailBody