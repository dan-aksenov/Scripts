#!/bin/bash
log=/var/lib/barman/log

for x in `ls /etc/barman.d/ | grep -v template | xargs -I{} echo {} | cut -d"." -f1`; do barman backup $x &>$log/$x.bkp.log; done

barman check all --nagios | mail -s "barman backup check" "aksenov_d@tii.ru"
