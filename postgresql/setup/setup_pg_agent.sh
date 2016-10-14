yum install epel-release -y
yum install pgagent_94
systemctl enable pgagent_94.service -y

sudo -u postgres psql -f /usr/share/pgagent_94-3.4.0/pgagent.sql postgres

useradd -s /bin/false -r -M pgagent
chown pgagent:pgagent /var/log/pgagent_94.log

mkdir /home/pgagent
cat > /home/pgagent/.pgpass << EOF
localhost:5432:*:postgres:postgres
EOF

chown pgagent.pgagent /home/pgagent -R
chmod 600 /home/pgagent/.pgpass

systemctl start pgagent_94.service