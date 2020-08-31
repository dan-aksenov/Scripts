# Directory where backup will be tested.
STAGE_DIR=/var/lib/pgbackrest/test_restore
PGVER=$1
STANZA=$2
PGBIN=/usr/pgsql-$PGVER/bin

# Recreate stage dir
sudo rm -rf $STAGE_DIR/$STANZA
sudo rm -rf $STAGE_DIR/ts_$STANZA
mkdir $STAGE_DIR/$STANZA -p
mkdir $STAGE_DIR/ts_$STANZA -p
chmod 700 $STAGE_DIR/$STANZA
chmod 700 $STAGE_DIR/ts_$STANZA
cd $STAGE_DIR

pgbackrest --process-max=$(nproc) --tablespace-map-all $STAGE_DIR/ts_$STANZA --pg1-path $STAGE_DIR/$STANZA --reset-pg1-host --reset-pg2-host --stanza=$STANZA restore

# Edit postgresql.conf. Change active port.
sed -i 's/port = .*/port = 54320/g' $STAGE_DIR/$STANZA/postgresql.conf
# Archive command not needed.
sed -i 's/archive_command/#archive_command/g' $STAGE_DIR/$STANZA/postgresql.conf
#Decrease shared buffers
sed -i 's/shared_buffers = .*/shared_buffers = 128MB/g' $STAGE_DIR/$STANZA/postgresql.conf
sed -i 's/huge_pages = .*/huge_pages = off/g' $STAGE_DIR/$STANZA/postgresql.conf
sed -i 's/hba_file/#hba_file/g' $STAGE_DIR/$STANZA/postgresql.conf
sed -i 's/ident_file/#ident_file/g' $STAGE_DIR/$STANZA/postgresql.conf

# Attempt start.
sudo chown postgres.postgres $STAGE_DIR/$STANZA -R
sudo chown postgres.postgres $STAGE_DIR/ts_$STANZA -R
sudo -u postgres $PGBIN/pg_ctl -w -D $STAGE_DIR/$STANZA start

# Check if db is in recovery/
for i in $(seq 0 100); do
response=$(sudo -u postgres $PGBIN/psql -qAtX -p 54320 -c "SELECT pg_is_in_recovery()::int" -U postgres postgres)
[[ $response == 0 || $i == $try ]] && break
replay_stamp=$(sudo -u postgres $PGBIN/psql -qAtX -p 54320 -c " select pg_last_xact_replay_timestamp()" -U postgres postgres)
echo "Still needs recovery. Now recovered to $replay_stamp"
sleep 60
done

echo "Restore completed at `date`."

#read -p "Press [Enter] to stop test server and delete stage data"
sudo -u postgres $PGBIN/pg_ctl -D $STAGE_DIR/$STANZA stop
sudo rm -rf $STAGE_DIR/$STANZA
sudo rm -rf $STAGE_DIR/ts_$STANZA
