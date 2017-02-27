read -p "Check parameters and press Enter. 1 - dest db(to be droped), 2 - owner, 3 - source db"

# Drop dest database, with session disconnect and empty database creation.
psql <<EOF
select pg_terminate_backend(pid) from pg_stat_activity where datname = '$1';
drop database $1;
create database $1 with owner $2;
EOF

# Reimport database from source
pg_dump --blobs $3 | psql $1 &>/tmp/restore.log