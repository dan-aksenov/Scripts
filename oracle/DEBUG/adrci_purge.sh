#!/bin/bash
adrci << EOF
spool adr_homes.lst
show homes
spool off
EOF
for home in $(tail -n+2 adr_homes.lst); do
	adrci <<EOF
	set home $home
	PURGE -AGE 000 -TYPE ALERT
	PURGE -AGE 000 -TYPE INCIDENT
	PURGE -AGE 000 -TYPE TRACE
EOF
done
rm adr_homes.lst
