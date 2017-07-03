#!/bin/bash
adrci << EOF
spool /tmp/adr_homes.lst
show homes
spool off
exit
EOF
for home in $(tail -n+2 /tmp/adr_homes.lst); do
	adrci <<EOF
	set home $home
	SET CONTROL (shortp_policy =100)
	SET CONTROL (LONGP_POLICY =168)
	show control
	exit
EOF
done
rm /tmp/adr_homes.lst
