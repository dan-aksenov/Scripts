# Postgresql archive cleanup script
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/pgsql-9.4/bin"
PGHOME=/var/lib/pgsql/9.4
PGARCH=/u01/pgsql/9.4/backups/arch
PG_ARCHIVECLEANUP=$(which pg_archivecleanup)
AGE="-mtime +3"

for backup_label in $(find $PGARCH/*.backup $AGE -exec basename {} \;)
  do
    $PG_ARCHIVECLEANUP $PGARCH $backup_label -d
    rm $PGARCH/$backup_label
  done
