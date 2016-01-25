#!/bin/bash
adrci << EOF
spool adr_homes.lst
show homes
spool off
EOF
for home in $(tail -n+2 adr_homes.lst); do
	adrci <<EOF
	set home $home
	SET CONTROL (shortp_policy =100)
	SET CONTROL (LONGP_POLICY =168)
	show control
EOF
done
rm adr_homes.lst
