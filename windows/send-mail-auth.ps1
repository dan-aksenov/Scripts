$From = "alarm@dbax.ru"
$To = "dbax@dbax.ru"
$SMTPServer = "192.168.1.25"
$SMTPPort = "25"
$Username = "dbax"
$Password = "dbax"
$subject = "Email Subject"
$body = "Insert body text here"

$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);

$smtp.EnableSSL = $false
$smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
$smtp.Send($From, $To, $subject, $body);