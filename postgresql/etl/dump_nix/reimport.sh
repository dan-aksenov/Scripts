display_usage() {
        echo "Correct usage:"
        echo "1 - dest db(to be droped), 2 - owner, 3 - source db, 4 -source host(defaults to localhost) "
        }

dst_db=$1
owner=$2
src_db=$3
src_host=$4

# if less than 3 variables supplied
if [  $# -lt 3 ]
then
        display_usage
        exit 1
fi

if [ !$scr_host ]
then
        scr_host=localhost
fi

# Drop dest database, with session disconnect and empty database creation.
psql <<EOF
select pg_terminate_backend(pid) from pg_stat_activity where datname = '$dst_db';
drop database $dst_db;
create database $dst_db with owner $owner;
EOF

# Reimport database from source
# pg_dump -h "$src_host" $src_db | psql $dst_db &>/tmp/restore.log

# ssh $src_host pg_dump --format custom --compress=5 --blobs --verbose --file /tmp/$src_db.dmp $src_db
# scp $src_host:/tmp/$src_db.dmp /tmp/$src_db.dmp
# pg_restore --dbname $dst_db --verbose /tmp/$src_db.dump &>/tmp/import.log

ssh $src_host "pg_dump dbname" | psql dbname

# postsrcipt
# psql -c "UPDATE pg_language set lanpltrusted = true where lanname='pltclu'" $dst_db
# psql -c "UPDATE pg_language set lanpltrusted = true where lanname='plpythonu'" $dst_db