# postgresql reimport srcipt
display_usage() {
        echo "Correct usage:"
        echo "reimp.sh source_host source_db destination_db_owner"
        }

# if less than 3 variables supplied
if [  $# -ne 3 ]
then
        display_usage
        exit 1
fi

src_host=$1
src_db=$2
db_owner=$3

# source
ssh $src_host pg_dump --format custom --blobs --verbose --file /tmp/$src_db.dmp $src_db
scp $src_host:/tmp/$src_db.dmp /tmp/$src_db.dmp

# target
# recreate db
psql -c "select pg_terminate_backend(pid) from pg_stat_activity where datname = 'src_db'"
psql -c "drop database $src_db"
psql -c "create database $src_db WITH OWNER = $db_owner"

# restore
pg_restore --dbname $src_db --verbose /tmp/$src_db.dmp

# postsrcipt
psql -c "UPDATE pg_language set lanpltrusted = true where lanname='pltclu'" $src_db
psql -c "UPDATE pg_language set lanpltrusted = true where lanname='plpythonu'" $src_db