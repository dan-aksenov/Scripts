# postgresql installation on Centos7
# user variables section
PGVER=9.4
# end of user variables section

# postgres verstion without dots
PGVER2=$(echo $PGVER | sed -e "s/\.//g")

# Add Posgresql repo (need to check for latest verstion!)
yum localinstall http://yum.postgresql.org/$PGVER/redhat/rhel-7-x86_64/pgdg-centos$PGVER2-$PGVER-1.noarch.rpm

# Install postgres and stuff
yum -y install postgresql$PGVER2 postgresql$PGVER2-server postgresql$PGVER2-contrib postgresql$PGVER2-libs 

# Install languages
yum -y install  postgresql$PGVER2-plpython postgresql$PGVER2-pltcl postgresql$PGVER2-python

# Install devel if needed postgresql$PGVER-devel
yum -y install postgresql$PGVER2-devel 

# Initialize DB (defauld directory)
/usr/pgsql-$PGVER/bin/postgresql$PGVER2-setup initdb

# Change listen address (might need to add more)
sed -i -e "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/$PGVER/data/postgresql.conf
# Add entry to pg_hba.conf
echo 'host all all 127.0.0.1/32 md5' | sudo tee --append /var/lib/pgsql/$PGVER/data/pg_hba.conf
echo 'host all all 192.168.0.1/16 md5' | sudo tee --append /var/lib/pgsql/$PGVER/data/pg_hba.conf

# Enable autostart
systemctl enable postgresql-$PGVER
systemctl start postgresql-$PGVER

# Change dba password 
sudo -u postgres psql << EOF
alter user postgres password 'postgres';
EOF

# Change listen address
sed -i -e "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/$PGVER/data/postgresql.conf
# Add entry to pg_hba.conf
echo 'host all all 127.0.0.1/32 md5' | sudo tee --append /var/lib/pgsql/$PGVER/data/pg_hba.conf
echo 'host all all 192.168.0.1/16 md5' | sudo tee --append /var/lib/pgsql/$PGVER/data/pg_hba.conf

# Stop & disable firewall. Need to find way to edit it inplace.
systemctl stop firewalld
systemctl disable firewalld

# Restart Postgres
systemctl restart postgresql-$PGVER