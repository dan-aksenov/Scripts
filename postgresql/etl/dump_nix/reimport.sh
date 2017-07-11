# Display usage function.
display_usage() {
        echo "Correct usage:"
        echo "1 - dest db(to be droped and reimported), 2 - destination database desired owner, 3 - source database, 4 -source host(defaults to localhost)"
        }

dst_db=$1
owner=$2
src_db=$3
src_host=$4

# If less than 3 variables supplied.
if [  $# -lt 3 ]
then
        display_usage
        exit 1
fi

# Drop dest database, with session disconnect and empty database creation.
psql <<EOF
select pg_terminate_backend(pid) from pg_stat_activity where datname = '$dst_db';
drop database $dst_db;
create database $dst_db with owner $owner;
EOF

# Reimport database from source.
if [ -z $src_host ]
then
    pg_dump $src_db | psql $dst_db &>/tmp/reimport.log
else
    ssh $src_host "pg_dump $src_db" | psql $dst_db &>/tmp/reimport.log   
fi

# Postsrcipt here.
# psql -c "UPDATE pg_language set lanpltrusted = true where lanname='pltclu'" $dst_db
# psql -c "UPDATE pg_language set lanpltrusted = true where lanname='plpythonu'" $dst_db