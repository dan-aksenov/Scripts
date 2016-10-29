# pgagent installation on Centos 7
# User variables section
PGVER=$1
if [ -z "$PGVER" ]; then echo "Database version is not set. Setup aborted." && exit 1; fi
# Postgres verstion without dots.
PGVER2=$(echo $PGVER | sed -e "s/\.//g")

yum install epel-release -y
yum install pgagent_$PGVER2 -y
systemctl enable pgagent_$PGVER2

sudo -u postgres psql -f /usr/share/pgagent_94-3.4.0/pgagent.sql postgres

useradd -s /bin/false -r -M pgagent
chown pgagent:pgagent /var/log/pgagent_$PGVER2.log

mkdir /home/pgagent
cat > /home/pgagent/.pgpass << EOF
localhost:5432:*:postgres:postgres
EOF

chown pgagent.pgagent /home/pgagent -R
chmod 600 /home/pgagent/.pgpass

systemctl start pgagent_$PGVER2