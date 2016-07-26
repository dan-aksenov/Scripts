set mailfrom "alarm@dbax.ru"
set mailto "dbax@dbax.ru"
set mailsubject "TEST"
set mailmessage "TEST"
set domainname ""
set myHost "exchange3"
set myPort "25"
set myLoginBase64 ""
set myPasswordBase64 ""
set myChapset "Windows-1251"
set defnull "bnVsbA=="
set mySock [socket $myHost $myPort]
set toemailaddress_start [string first "<" $mailto]
if {$toemailaddress_start != -1} {
	set toemailaddress_finish [string first ">" $mailto]
	set toemailaddress_start [expr $toemailaddress_start + 1]
	set toemailaddress_finish [expr $toemailaddress_finish - 1]
	set toemailaddress [string range $mailto $toemailaddress_start $toemailaddress_finish]
} else {
	set toemailaddress $mailto
}
set fromemailaddress_start [string first "<" $mailfrom]
if {$fromemailaddress_start != -1} {
	set fromemailaddress_finish [string first ">" $mailfrom]
	set fromemailaddress_start [expr $fromemailaddress_start + 1]
	set fromemailaddress_finish [expr $fromemailaddress_finish - 1]
	set fromemailaddress [string range $mailfrom $fromemailaddress_start $fromemailaddress_finish]
} else {
	set fromemailaddress $mailfrom
}
fileevent $mySock writable [list svcHandler $mySock]
fconfigure $mySock -buffering line
puts $mySock "HELO $domainname"
gets $mySock name
if {![string equal $myLoginBase64 $defnull ] && ![string equal $myPasswordBase64 $defnull ]} then {
puts $mySock "AUTH LOGIN"
gets $mySock name
puts $mySock $myLoginBase64
gets $mySock name
puts $mySock $myPasswordBase64
gets $mySock name
} 
puts $mySock "MAIL FROM: $fromemailaddress"
gets $mySock name
puts $mySock "RCPT TO: $toemailaddress"
gets $mySock name
puts $mySock "DATA"
gets $mySock name
puts $mySock "From: $mailfrom"
puts $mySock "To: $mailto"
puts $mySock "Subject: $mailsubject"
puts $mySock "MIME-Version: 1.0"
puts $mySock "Content-type: text/html; charset=$myChapset"
puts $mySock "Content-Transfer-Encoding: 8bit"
puts $mySock ""
puts $mySock "$mailmessage"
puts $mySock ""
puts $mySock "."
gets $mySock name
puts $mySock "QUIT"
gets $mySock name
close $mySock
return 1
