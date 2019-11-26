# Should use My ansible roles to install postgreses.

# Postgresql version
pg_ver=11
# Streaming master
master=cos7-sb1
# Streaming slaves.
slave=cos7-sb2

ansible-playbook -i ../ansible-hosts/test -l $master postgres_main.yml
ansible-playbook -i ../ansible-hosts/test -l $slaves postgres_main.yml --tags slave
ssh ansible@$master sudo sed -i 's/^#node_id=1/node_id=1/g' /etc/repmgr/$pg_ver/repmgr.conf
ssh ansible@$slave sudo sed -i 's/^#node_id=1/node_id=2/g' /etc/repmgr/$pg_ver/repmgr.conf
ssh ansible@$master sudo -iu postgres /usr/pgsql-$pg_ver/bin/repmgr primary register
#ssh ansible@$master sudo -iu postgres repmgr -h node1 -U repmgr -d repmgr standby clone --dry-run
ssh ansible@$slave sudo -iu postgres /usr/pgsql-$pg_ver/bin/repmgr -h $master -U repmgr -d repmgr standby clone
ssh ansible@$slave sudo -iu postgres /usr/pgsql-$pg_ver/bin/repmgr standby register
ssh ansible@$slave sudo -iu postgres /usr/pgsql-$pg_ver/bin/pg_ctl start -D /var/lib/pgsql/$pg_ver/data
ssh ansible@$slave sudo -iu postgres /usr/pgsql-$pg_ver/bin/repmgr cluster show
