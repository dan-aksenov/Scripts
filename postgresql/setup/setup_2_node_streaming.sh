# Using My ansible roles to install postgreses
# User with passwordless ssh to targeted hosts is required

if [ "$#" -ne 4 ]; then
    echo "ERROR! Need Parameters: 1 - Postgres version, 2 - Master's name, 3 - Slave's name, 4 - Ansible inventory file" 
    exit 1
fi

# Postgresql version
pg_ver=$1
# Streaming master
master=$2
# Streaming slaves.
slave=$3
# Ansible Inventory file
inventory=$4
# Ansible user with root access
ansible_user=$USER

echo Install Master
ansible-playbook -i $inventory -l $master postgres_main.yml -e "postgresql_version=$pg_ver"
echo Install Slave
ansible-playbook -i $inventory -l $slave postgres_main.yml --tags slave -e "postgresql_version=$pg_ver"

echo Edit repmgr.conf
ssh $ansible_user@$master sudo sed -i 's/^#node_id=1/node_id=1/g' /etc/repmgr/$pg_ver/repmgr.conf
ssh $ansible_user@$slave sudo sed -i 's/^#node_id=1/node_id=2/g' /etc/repmgr/$pg_ver/repmgr.conf

echo Register Master
ssh $ansible_user@$master sudo -iu postgres /usr/pgsql-$pg_ver/bin/repmgr primary register
echo Clone Slave
ssh $ansible_user@$slave sudo -iu postgres /usr/pgsql-$pg_ver/bin/repmgr -h $master -U repmgr -d repmgr standby clone
echo Start Slave
ansible -i $inventory $slave -a "/usr/pgsql-$pg_ver/bin/pg_ctl start -D /var/lib/pgsql/$pg_ver/data" --become --become-user=postgres -u ansible 
echo Register Slave
ssh $ansible_user@$slave sudo -iu postgres /usr/pgsql-$pg_ver/bin/repmgr standby register

ssh $ansible_user@$slave sudo -iu postgres /usr/pgsql-$pg_ver/bin/repmgr cluster show
