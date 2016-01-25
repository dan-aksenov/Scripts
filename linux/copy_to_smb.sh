MOUNT_DIR=$HOME/windows_share/
REMOTE_DIR=//FS/TESK_LKK/
BACKUP_DIR=$HOME/9.4/backups/

test -d $MOUNT_DIR || mkdir -p $MOUNT_DIR
sudo mount.cifs $REMOTE_DIR $MOUNT_DIR -o credentials=$HOME/.smbcred
sudo rsync -avz $BACKUP_DIR $MOUNT_DIR/$HOSTNAME
sleep 5
sudo umount $MOUNT_DIR
