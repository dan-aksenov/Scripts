#!/usr/bin/env bash
# Create basebackup of postgresql server cluster.
# Make sure that you can connect to the postgres.
# Script perform remove old basebackup copies older then $AGE period.

# N.B. Original script got from git@github.com:lesovsky/uber-scripts.git
# Added few minor tweeks for my setup. Vaildation from original script removed. //dbax

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/pgsql-9.4/bin"
PGHOME=/var/lib/pgsql/9.4
#PGDATA=$HOME/data # Not used for now //dbax
PGARCH=/$(psql -c "show archive_command" | grep cp | cut -d"/" -f2- | cut -d"%" -f1)
PG_BASEBACKUP=$(which pg_basebackup)
PG_ARCHIVECLEANUP=$(which pg_archivecleanup)
CURRENT="db-$(date +%m-%d-%Y_%H)"
AGE="-mtime +3"
LOCK="/tmp/basebackup.lock"

usage (){
echo "basebackup.sh usage: "
echo " -b, --backupdir     backupdir, basebackup destination (required)"
}

# perform sanity checks, check options.
if [ "$#" -eq 0 ]; then echo "basebackup.sh: parameters is not specified."; usage; exit; fi
if ! grep -qE '\-b=|\-\-backupdir=' <<< $@
  then echo "basebackup.sh: backupdir parameter is not specified."; usage; exit; 
fi

# processing parameters
for param in "$@"
  do
    case $param in
      -b=*|--backupdir=*)
      BACKUPDIR=$(echo $param | sed 's/[-a-zA-Z0-9]*=//')
      ;;
      *)
      echo "basebackup.sh: unknown parameter specified."; usage; exit
     ;;
    esac
  done

# Main 
if [ -f $LOCK ]; 
   then echo "Another pg_basebackup is running. Quit."; exit 1;
fi

touch $LOCK
mkdir $BACKUPDIR/$CURRENT

# -F t and -z added to compress backup. //dbax
# -x added for backup xlog also. //dbax
$PG_BASEBACKUP -l "basebackup $(date +%m-%d-%Y_%H)" -U postgres -D $BACKUPDIR/$CURRENT -F t -P -v -x -z
chmod 700 $BACKUPDIR/$CURRENT

# remove old backups
# because archive may be somewhere else instead of $PGDATA/archive new variable PGARCH was implemented //dbax
/usr/bin/find $BACKUPDIR -maxdepth 1 -type d $AGE -name "db-*" | xargs rm -rf
for backup_label in $(find $PGARCH/*.backup $AGE -exec basename {} \;)
  do
    $PG_ARCHIVECLEANUP $PGARCH $backup_label -d
    rm $PGARCH/$backup_label
  done

rm $LOCK