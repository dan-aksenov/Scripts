# Postgresql installation on Centos7
# Variables section
PGVER=$1
# User default postgres version if not set
if [ -z "$PGVER" ]; then PGVER=9.5; fi
# Postgres version without dots.
PGVER2=$(echo $PGVER | sed -e "s/\.//g")
# Determine Distribution name
DIST=$(cat /etc/*-release | grep ^NAME)
if [[ $DIST == *"CentOS"* ]]; then DIST=centos;
	elif [[ $DIST == *"Oracle"* ]]; then DIST=oraclelinux;
	else echo echo "Could not determine distribution name. Setup aborted." && exit 1;
fi
# End of variables section.

# Check connection
wget --spider http://yum.postgresql.org
if [ "$?" != 0 ]; then
  echo "Unable to connect to yum.postgresql.org. Check network of proxy settints."
fi

# Add Posgresql repo
yum -y localinstall http://yum.postgresql.org/$PGVER/redhat/rhel-7-x86_64/pgdg-$DIST$PGVER2-$PGVER-1.noarch.rpm
# Check for latest repo verstion. And update if found one.
yum -y update pgdg-centos$PGVER2

# Install postgres main stuff
yum -y install postgresql$PGVER2 postgresql$PGVER2-server postgresql$PGVER2-contrib postgresql$PGVER2-libs 

# Install some languages if needed (I need:))
yum -y install  postgresql$PGVER2-plpython postgresql$PGVER2-pltcl postgresql$PGVER2-python

# Install devel if needed (might be usefull sometimes)
yum -y install postgresql$PGVER2-devel 

# Update-alternatives. do we need this?
a=0
ls /usr/pgsql-$PGVER/bin/ | grep -v postmaster | xargs -I{} sudo update-alternatives --install /usr/bin/{} pgsql-{}  /usr/pgsql-$PGVER/bin/{} $PGVER2$a

# Add firewall exception for postgres. 
firewall-cmd --permanent --zone=public --add-service=postgresql
firewall-cmd --reload

read -p "Initialize new database cluster (y/n):" INIT_FLAG
if [ $INIT_FLAG = "y" ];
	then
	# Initialize DB (defauld directory)
	/usr/pgsql-$PGVER/bin/postgresql$PGVER2-setup initdb
	# Edit postgresql.conf: change listen address (might need to add more)
	sed -i -e "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/$PGVER/data/postgresql.conf
	# Add entries to pg_hba.conf
	echo 'host all all 127.0.0.1/32 md5' | sudo tee --append /var/lib/pgsql/$PGVER/data/pg_hba.conf
	echo 'host all all 192.168.0.1/16 md5' | sudo tee --append /var/lib/pgsql/$PGVER/data/pg_hba.conf
	# Enable and start daemon
	systemctl enable postgresql-$PGVER
	systemctl start postgresql-$PGVER
	# Change superuser password
	sudo -u postgres psql -c "alter user postgres password 'postgres'";
	
	# Install and run pgtune on database cluster
	PGCONF=/var/lib/pgsql/$PGVER/data/postgresql.conf # get it dynamical somehow
	yum install epel-release -y
	yum install pgtune -y
	pgtune -i $PGCONF -o $PGCONF.tuned -T Mixed -c 100
	mv $PGCONF $PGCONF.orig
	mv $PGCONF.tuned $PGCONF

	cat >> $PGCONF << EOF
#add stat_statements to libs
shared_preload_libraries = 'pg_stat_statements'

#add activities tracking
track_activities = on
track_counts = on
track_io_timing = on
track_functions = all
log_autovacuum_min_duration = 0		

#custom setting for stat_statements
pg_stat_statements.track = all
EOF
chown postgres.postgres $PG_CONF
fi
	

