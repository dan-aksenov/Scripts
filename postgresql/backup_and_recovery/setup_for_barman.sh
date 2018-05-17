# This script should be runned from backup server.
# pg_host - is the PostgreiSQL server being added to barman's infrastructure.
pg_host=$1

# Barman should be able to connect to database server via ssh
ssh-copy-id postgres@$pg_host

# Creating database server configuration file.
cat > /tmp/$pg_host.conf << EOF
[$pg_host]
description =  "$pg_host PostgreSQL server"
conninfo = host=$pg_host user=barman dbname=postgres
backup_method = postgres
streaming_conninfo = host=$pg_host user=streaming_barman dbname=postgres
streaming_archiver = on
slot_name = barman
EOF
sudo cp /tmp/$pg_host.conf /etc/barman.d/

# Creating barman users in target database.
createuser -h $pg_host -s -W -P -U postgres barman 
createuser -h $pg_host -s -W -P -U postgres --replication streaming_barman 

# Add passw to .pgpass on barman server
cat >>.pgpass << EOF
$pg_host:5432:postgres:barman:barman
$pg_host:5432:postgres:streaming_barman:barman
EOF

# Add pg_hba on target
# get IP
ip=$(ip a | grep global | cut -f6 -d" ")
ssh postgres@$pg_host 'echo "host all barman $ip md5" >> /var/lib/pg*/*/data/pg_hba.conf'
ssh postgres@$pg_host 'echo "host replication streaming_barman $ip trust" >> /var/lib/pg*/*/data/pg_hba.conf'

# Check if barman can actually connect to target database.
psql -c 'SELECT version()' -U barman -h $pg_host postgres
psql -U streaming_barman -h $pg_host -c "IDENTIFY_SYSTEM" replication=1

# PostgreSQL WAL archiving and replication postgresql.conf
# Should be configured in initial postgres.conf!
# ssh postgres@$pg_host sed -i -e "s/#wal_level = 'minimal'/wal_level = 'hot_standby'/g" /var/lib/pgsql/*/data/postgresql.conf
# ssh postgres@$pg_host sed -i -e "s/#max_wal_senders = 0/max_wal_senders = 2/g" /var/lib/pgsql/*/data/postgresql.conf
# ssh postgres@$pg_host sed -i -e "s/#max_replication_slots = 0/max_replication_slots = 2/g" /var/lib/pgsql/*/data/postgresql.conf

# Create replication slot on barman server
barman receive-wal --create-slot $pg_host

# Force initial xlog switch
barman switch-xlog --force $pg_host

echo Barman commands cheatsheet:
echo barman cron
echo barman switch-xlog --force $pg_host
echo barman check $pg_host
echo barman backup $pg_host
