MOUNT_DIR=$HOME/windows_share
REMOTE_DIR=//FS/TESK_LKK/
BACKUP_DIR=$HOME/9.4/backups/

# check if share is mounted
if mountpoint -q -- $MOUNT_DIR; 
 then
  printf '%s\n' "$dir is mounted"
 else printf '%s\n' "$dir is a mounted, exiting" && exit 1 
fi

# Copy backups to remote windows location
rsync -avz $BACKUP_DIR $MOUNT_DIR/$HOSTNAME
