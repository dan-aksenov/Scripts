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
	PURGE -AGE 000
	exit
EOF
done
rm /tmp/adr_homes.lst
