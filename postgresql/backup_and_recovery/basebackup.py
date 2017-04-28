#!/bin/python
import sys, getopt, psycopg2, os, datetime, time
from subprocess import call
from shutil import rmtree
from glob import glob

# Backup timestamp label:
backup_label = str(datetime.date.today())

# Lockfile settings:
pid = str(os.getpid())
pidfile = "/tmp/basebackup.pid"

# Retention setting for old backup and archivelogs:
age = 1

# Get archivelog directory from current postgresql settings.
try:
    conn = psycopg2.connect("dbname='postgres' user='postgres' host='localhost'")
except:
    print "ERROR: unable to connect to the database!"
cur = conn.cursor()
cur.execute("show archive_command")
arch_dir = cur.fetchall()
# convert tuple to string
arch_dir = ''.join(arch_dir)
# split to remove trash
arch_dir = arch_dir.split(' ')
# finalize variable
arch_dir = arch_dir[2]

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

# Check if another backup is already running.
if os.path.isfile(pidfile):
    print "Another backup (pid %s) already running, exiting" % pid
    sys.exit(2)
file(pidfile, 'w').write(pid)

# Create labeled directory to hold timestamped backup.
final_dir = backup_dir + '/db_' + backup_label
if not os.path.exists(final_dir):
    os.makedirs(final_dir)

print "Creating postgresql cluster backup:"
# Create backup command string using label, directory and required parameters and run it.
backup_command = "pg_basebackup -l" + backup_label + " -U postgres -D" + final_dir + " -F t -P -v -x -z"
try:
    call(backup_command, shell=True)
except:
    print "Backup failed"
    sys.exit(2)

print "Deleting old backups according to retention policy:"
current_time = time.time()
for f in os.listdir(backup_dir):
    file = os.path.join(backup_dir, f)
    creation_time = os.path.getctime(file)
    if (current_time - creation_time) // (24 * 3600) >= age:
        rmtree(file)
        print('{} removed'.format(file))

print "Deleteing old archivelogs:"
for file in os.listdir(arch_dir):
    if file.endswith(".backup"):    
        arch_file = os.path.join(arch_dir, file)
        creation_time = os.path.getctime(arch_file)
        if (current_time - creation_time) // (24 * 3600) >= age:
            cleanup_command = "pg_archivecleanup" + arch_dir + " " + file + " -d"
            call(cleanup_command, shell=True )
            os.unlink(arch_file)
            print('{} removed'.format(file))

# remove pidfile
os.unlink(pidfile)   

