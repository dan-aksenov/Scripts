#!/bin/python
import sys, getopt, psycopg2, os, datetime, time
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
age=1

# Function to display command usage.
def usage(): 
    print "basebackup.py usage: "
    print "    required arument: -b /dir or --basebackup=/dir backup destination"
    sys.exit(2)

# Check for arguments.
try:
    opts, args = getopt.getopt(sys.argv[1:], 'b:', ['backup_directory='])
except getopt.GetoptError as err:
    usage()

if len(sys.argv) <= 1:
   print "No arguments supplied :("
   usage()

for opt, arg in opts:
    if opt in ('-b', '--backup_directory'):
        backup_dir = arg
    else:
        usage()

# Check if supplied backup directory exists.
if not os.path.isdir(backup_dir):
    print "No valid directory supplied :("
    usage()

# Check if another backpu is already running.
if os.path.isfile(pidfile):
    print "Another backup (pid %s) already running, exiting" % pid
    sys.exit()
file(pidfile, 'w').write(pid)

# Create labeled directory to hold timestamped backup
final_dir = backup_dir + '/' + backup_label
if not os.path.exists(final_dir):
    os.makedirs(final_dir)

# Create backup command string using label, directory and required parameters and run it.
backup_command = "pg_basebackup -l" + backup_label + " -U postgres -D" + final_dir + " -F t -P -v -x -z"
call(backup_command, shell=True)

# todo: remove old backups and archivelogs.
# not working as expected. revision needed
current_time = time.time()
for f in os.listdir(backup_dir):
    file = os.path.join(backup_dir, f)
    creation_time = os.path.getctime(file)
    if (current_time - creation_time) // (24 * 3600) >= age:
        os.unlink(file)
        print('{} removed'.format(file))

# remove pidfile
os.unlink(pidfile)   

