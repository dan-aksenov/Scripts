backrest_app=/bin/pgbackrest
backup_type=$1
for i in $(pgbackrest --output=json info | jq .[].name)
do echo $backrest_app --type=$backup_type --stanza=$i backup
done | bash -x
