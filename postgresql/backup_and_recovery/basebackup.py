#!/bin/python
import sys, getopt, psycopg2, os, datetime
from subprocess import call

# variables to be redone for python
#PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/pgsql-9.4/bin"
#PGHOME=/var/lib/pgsql/9.4
#PGDATA=$HOME/data # Not used for now //dbax
#PGARCH=$PGHOME/backup/arch
#PG_BASEBACKUP=$(which pg_basebackup)
#PG_ARCHIVECLEANUP=$(which pg_archivecleanup)

backup_label = str(datetime.date.today())
pid = str(os.getpid())
pidfile = "/tmp/basebackup.pid"

#AGE="-mtime +3"
#LOCK="/tmp/basebackup.lock"
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

if os.path.isfile(pidfile):
    print "Another backup (pid %s) already running, exiting" % pid
    sys.exit()
file(pidfile, 'w').write(pid)

call([ "pg_basebackup", "-l", backup_label, "-U", "postgres", "-D", backupdir, "-F", "t", "-P", "-v", "-x", "-z"] )

# todo: remove old backups and archivelogs

# remove pidfile
os.unlink(pidfile)   

