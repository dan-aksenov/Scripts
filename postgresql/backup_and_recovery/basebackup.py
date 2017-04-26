#!/bin/python
import sys, getopt, psycopg2, os
from subprocess import call

# variables to be redone for python
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/pgsql-9.4/bin"
PGHOME=/var/lib/pgsql/9.4
#PGDATA=$HOME/data # Not used for now //dbax
PGARCH=$PGHOME/backup/arch
PG_BASEBACKUP=$(which pg_basebackup)
PG_ARCHIVECLEANUP=$(which pg_archivecleanup)

backup_label = str(datetime.date.today())

AGE="-mtime +3"
LOCK="/tmp/basebackup.lock"
# /variables

def usage(): 
    print "basebackup.py usage: "
    print "    required arument: -b /dir or --basebackup=/dir backup destination"
    sys.exit(2)

try:
    opts, args = getopt.getopt(sys.argv[1:], 'b:', ['backup_directory='])
except getopt.GetoptError as err:
    usage()

if len(sys.argv) <= 1:
   print "No arguments supplied :("
   usage()

for opt, arg in opts:
    if opt in ('-b', '--backup_directory'):
        backupdir = arg
    else:
        usage()

if not os.path.isdir(backupdir):
    print "No valid directory supplied :("
    usage()

# todo: check if lock file exists
# todo: create lock file and backup directory

basebackup_params = "-F t -P -v -x -z" # will not work!
call([ "pg_basebackup", "-l", backup_label, "-U", "postgres", "-D", backupdir, basebackup_params ] )

# todo remove old backups and archivelogs
