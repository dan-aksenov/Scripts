export https_proxy=http://cache.fors.ru:3128
export http_proxy=http://cache.fors.ru:3128
wget https://github.com/Lelik13a/Zabbix-PyOra-ActiveCheck/archive/master.zip
unzip master.zip

sudo pip install cx-Oracle
sudo pip install argparse
# or sudo yum install -y python-argparse
sudo pip install py-zabbix

sqlplus / as sysdba << EOF
CREATE USER ZABBIX IDENTIFIED BY zabbix DEFAULT TABLESPACE SYSTEM TEMPORARY TABLESPACE TEMP PROFILE DEFAULT ACCOUNT UNLOCK;
GRANT CONNECT TO ZABBIX;
GRANT RESOURCE TO ZABBIX;
ALTER USER ZABBIX DEFAULT ROLE ALL;
GRANT SELECT ANY TABLE TO ZABBIX;
GRANT CREATE SESSION TO ZABBIX;
GRANT SELECT ANY DICTIONARY TO ZABBIX;
GRANT UNLIMITED TABLESPACE TO ZABBIX;
GRANT SELECT ANY DICTIONARY TO ZABBIX;
GRANT SELECT ON V_$SESSION TO ZABBIX;
GRANT SELECT ON V_$SYSTEM_EVENT TO ZABBIX;
GRANT SELECT ON V_$EVENT_NAME TO ZABBIX;
GRANT SELECT ON V_$RECOVERY_FILE_DEST TO ZABBIX;
EOF

sudo mkdir /usr/lib/zabbix/externalscripts/ -p
sudo cp Zabbix-PyOra-ActiveCheck-master/externalscripts/* /usr/lib/zabbix/externalscripts/
sudo chmod 755 /usr/lib/zabbix/externalscripts/pyora-active.py /usr/lib/zabbix/externalscripts/pyora-discovery.py /usr/lib/zabbix/externalscripts/pyora-items-list.py

cat > /tmp/pyora_config.py << EOF
# put here user/password to connect Oracle database
username = 'zabbix'
password = 'zabbix'
EOF
sudo cp /tmp/pyora_config.py /usr/lib/zabbix/externalscripts/pyora_config.py

sudo cp Zabbix-PyOra-ActiveCheck-master/zabbix_agentd.d/oracle_pyora.conf /etc/zabbix/zabbix_agentd.d/
sudo mkdir /usr/lib/zabbix/cache
sudo chown zabbix:zabbix /usr/lib/zabbix/cache

# edit /etc/passwd zabbix home/hell

#get oracle sid
grep '^[a-z,A-Z].*:' /etc/oratab | cut -f1 -d":"

sudo crontab -eu zabbix
# */10 * * * * /usr/lib/zabbix/externalscripts/pyora-active.py  --address database_address --database database_SID

sudo service zabbix-agent restart
