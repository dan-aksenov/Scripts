#!/bin/bash

#INITIALIZE EVIRONMENT
#ORACLE_SID=orcl
#ORAENV_ASK=NO
#. oraenv
. /home/oracle/.bash_profile
#source backup.conf
#CONTENTS_METADATA=
CONTENTS_ALL=SCHEMA1,SCHEMA2
#TABLE_ONLY=REPORT.WD_SQLSTORE
DATE=$(date +\%Y-\%m-\%d)
ORA_DIR=BACKUP
DIRECTORY=$(sqlplus -S / as sysdba <<EOF
set head off
select directory_path from dba_directories where directory_name='$ORA_DIR';
exit
EOF
)

#### SETTINGS FOR ROTATED BACKUPS ####
# Which day to take the weekly backup from (1-7 = Monday-Sunday)
DAY_OF_WEEK_TO_KEEP=5
# Number of days to keep daily backups
DAYS_TO_KEEP=7
# How many weeks to keep weekly backups
WEEKS_TO_KEEP=4


function perform_backups()
{
	SUFFIX=$1
	ORADIR=$DATE"-"$SUFFIX
	FINAL_BACKUP_DIR=$DIRECTORY/$ORADIR/

#MAKE DIRECTORY
	if ! mkdir -p $FINAL_BACKUP_DIR; then
		echo "Cannot create backup directory in $FINAL_BACKUP_DIR. Go and fix it!" 1>&2
		exit 1;
	fi;
	
#EXPORT ONLY METADATA
#if [ ! -z "$CONTENTS_METADATA" ]; then
#	for SCHEMA in ${CONTENTS_METADATA//,/ }
#	do
#		expdp "'/ as sysdba'" schemas=$SCHEMA dumpfile=$SCHEMA directory=$ORA_DIR logfile=$SCHEMA reuse_dumpfiles=yes #compression=all content=metadata_only
#		mv $DIRECTORY/$SCHEMA.* $FINAL_BACKUP_DIR/
#		perform_logging
#	done
#fi

#EXPORT DATA ALONG WITH METADATA
if [ ! -z "$CONTENTS_ALL" ]; then
	for SCHEMA in ${CONTENTS_ALL//,/ }
	do
		expdp "'/ as sysdba'" schemas=$SCHEMA dumpfile=$SCHEMA directory=$ORA_DIR logfile=$SCHEMA reuse_dumpfiles=yes compression=all
		mv $DIRECTORY/$SCHEMA.* $FINAL_BACKUP_DIR/
		perform_logging
	done
fi

#EXPORT 1 TABLE
#if [ ! -z "$TABLE_ONLY" ]; then
#	for SCHEMA in ${TABLE_ONLY//,/ }
#	do
#		expdp "'/ as sysdba'" tables=$SCHEMA dumpfile=$SCHEMA.dmp logfile=$SCHEMA.log directory=BACKUP reuse_dumpfiles=yes #compression=all
#		mv $DIRECTORY/$SCHEMA.* $FINAL_BACKUP_DIR/
#		perform_logging
#	done
#fi
}

#LOGGING FUNCTION. To be called inside backup function.
function perform_logging()
{
cd $FINAL_BACKUP_DIR 
ERRORS=$(grep -c ORA- $SCHEMA.log)
sqlplus / as sysdba <<EOF
delete from log.export_log where tag='$SUFFIX' and sch='$SCHEMA';
insert into log.EXPORT_LOG values ('$DATE','$SCHEMA','$ERRORS','$SUFFIX');
commit;
EOF

}

### PERFORM BACKUP ITSELF ###
# WEEKLY BACKUPS
DAY_OF_WEEK=`date +%u` #1-7 (Monday-Sunday)
EXPIRED_DAYS=`expr $((($WEEKS_TO_KEEP * 7) + 1))`
 
if [ $DAY_OF_WEEK = $DAY_OF_WEEK_TO_KEEP ];
then
	# Delete all expired weekly directories
	find $DIRECTORY -maxdepth 1 -mtime +$EXPIRED_DAYS -name "*-weekly" -exec rm -rf '{}' ';'
 
	perform_backups "weekly"
 
	exit 0;
fi
 
# DAILY BACKUPS
# Delete daily backups 7 days old or more
find $DIRECTORY -maxdepth 1 -mtime +$DAYS_TO_KEEP -name "*-daily" -exec rm -rf '{}' ';'

perform_backups "daily" 