backrest_app=/bin/pgbackrest
for STANZA in $(pgbackrest --output=json info | jq -r '.[].name')
do
PGVER=$($backrest_app --stanza=$STANZA --output=json info | jq -r .[].db[].version)
echo /home/pgbackrest/validate_backup.sh $PGVER $STANZA
done | bash -x
