pg_host=$1

ssh-copy-id postgres@$pg_host
barman receive-wal --create-slot $pg_host

# PostgreSQL connection
# on db server
createuser -h $pg_host -s -W -P -U postgres barman 
createuser -h $pg_host -s -W -P -U postgres --replication streaming_barman 

# PostgreSQL WAL archiving and replication postgresql.conf
# wal_level = 'replica' or 'hot_standby' for 9.6
ssh postgres@$pg_host sed -i -e "s/#wal_level = 'minimal'/wal_level = 'hot_standby'/g" /var/lib/pgsql/*/data/postgresql.conf

# add postgresql.conf
# max_wal_senders = 2
# max_replication_slots = 2
ssh postgres@$pg_host sed -i -e "s/#max_wal_senders = 0/max_wal_senders = 2/g" /var/lib/pgsql/*/data/postgresql.conf
ssh postgres@$pg_host sed -i -e "s/#max_replication_slots = 0/max_replication_slots = 2/g" /var/lib/pgsql/*/data/postgresql.conf

# add passw to .pgpass on barman server
cat >>.pgpass << EOF
$pg_host:5432:postgres:barman:barman
$pg_host:5432:postgres:streaming_barman:barman
EOF

# testconnection
psql -c 'SELECT version()' -U barman -h $pg_host postgres
psql -U streaming_barman -h $pg_host -c "IDENTIFY_SYSTEM" replication=1

# on barman server
# Server configuration file (on barman server) /etc/barman.d/pg.conf
# [pg]
# description =  "Our main PostgreSQL server"
# conninfo = host=pg user=barman dbname=postgres
# backup_method = postgres
# if streadming needed
# streaming_conninfo = host=pg user=streaming_barman dbname=postgres
# streaming_archiver = on
# slot_name = barman

# not working
cat > /tmp/$pg_host.conf << EOF
[$pg_host]
description =  "Some PostgreSQL server"
conninfo = host=$pg_host user=barman dbname=postgres
backup_method = postgres
streaming_conninfo = host=$pg_host user=streaming_barman dbname=postgres
streaming_archiver = on
slot_name = barman
EOF

sudo cp /tmp/$pg_host.conf /etc/barman.d/

barman cron
barman check pg

crontab -l > /tmp/cron.tmp
echo "0 1 * * * barman backup $pg_host &>/var/lib/barman/log/backup_$pg_host.log" >> /tmp/cron.tmp
crontab /tmp/cron.tmp
rm /tmp/cron.tmp

# barman receive-wal $pg_host is handled by barman cron 

# list of barman commands
# barman show-server pg
# barman backup pg
# barman list-backup pg
