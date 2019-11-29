# Postgresql version
# User "ansible" with passwordless ssh to targeted hosts is required

if [ "$#" -ne 5 ]; then
    echo "ERROR. Need Parameters: 1 - Postgres version old, 2 - Postgres version new, 3 - Master's name, 4 - Slave's name, 5 - Ansible inventory file" 
    exit 1
fi

pg_ver_old=$1
pg_ver_new=$2
master=$3
slave=$4
inventory=$5

ansible-playbook -i $inventory -l $master,$slave postgres_main.yml --tags 1_repository,2_install,3_init -e "postgresql_version=$pg_ver_new"

ansible -i $inventory $master -a "/usr/pgsql-$pg_ver_old/bin/pg_ctl stop -D /var/lib/pgsql/$pg_ver_old/data" --become --become-user=postgres -u ansible

ssh ansible@$master sudo -u postgres cp /var/lib/pgsql/$pg_ver_old/data/conf.d/  /var/lib/pgsql/$pg_ver_new/data/ -R
ssh ansible@$master sudo -u postgres cp /var/lib/pgsql/$pg_ver_old/data/postgresql.conf /var/lib/pgsql/$pg_ver_new/data/postgresql.conf
ssh ansible@$master sudo -u postgres cp /var/lib/pgsql/$pg_ver_old/data/pg_hba.conf /var/lib/pgsql/$pg_ver_new/data/pg_hba.conf

cmd="/usr/pgsql-$pg_ver_new/bin/pg_upgrade -d /var/lib/pgsql/$pg_ver_old/data -D /var/lib/pgsql/$pg_ver_new/data -b /usr/pgsql-$pg_ver_old/bin/ -B /usr/pgsql-$pg_ver_new/bin/ -k"
ansible -i $inventory $master -a "$cmd" --become --become-user=postgres -u ansible 

ansible -i $inventory $slave -a "/usr/pgsql-$pg_ver_old/bin/pg_ctl stop -D /var/lib/pgsql/$pg_ver_old/data" --become --become-user=postgres -u ansible 
ssh ansible@$slave sudo rm /var/lib/pgsql/$pg_ver_new/data/* -rf

#copy recovery.conf, what about 12?
cmd="cd /var/lib/pgsql && rsync --relative --archive --hard-links --size-only $pg_ver_old/data $pg_ver_new/data root@$slave:/var/lib/pgsql/"
ssh ansible@$master $cmd
#This is temporary solution. Also mind pg-12 recovery.conf changes.
ssh ansible@$slave sudo -u postgres cp /var/lib/pgsql/$pg_ver_old/data/recovery.conf /var/lib/pgsql/$pg_ver_new/data/recovery.conf

echo Edit repmgr.conf
ssh ansible@$master sudo cp /etc/repmgr/$pg_ver_old/repmgr.conf /etc/repmgr/$pg_ver_new/repmgr.conf
ssh ansible@$slave sudo cp /etc/repmgr/$pg_ver_old/repmgr.conf /etc/repmgr/$pg_ver_new/repmgr.conf
ssh ansible@$master sudo sed -i "s/$pg_ver_old/$pg_ver_old/g" /etc/repmgr/$pg_ver_new/repmgr.conf
ssh ansible@$slave sudo sed -i "s/$pg_ver_old/$pg_ver_old/g" /etc/repmgr/$pg_ver_new/repmgr.conf

ansible-playbook -i $inventory -l $slave postgres_main.yml --tags 6_startdb -e "postgresql_version=$pg_ver_new"
ansible-playbook -i $inventory -l $master postgres_main.yml --tags 6_startdb -e "postgresql_version=$pg_ver_new"

#ansible -i $inventory $master -a "/usr/pgsql-$pg_ver_new/bin/pg_ctl start -D /var/lib/pgsql/$pg_ver_new/data" --become --become-user=postgres -u ansible 

ssh ansible@$slave sudo -iu postgres /usr/pgsql-$pg_ver_new/bin/repmgr cluster show