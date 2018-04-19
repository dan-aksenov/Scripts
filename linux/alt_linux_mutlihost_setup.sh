#keys
for i in $hosts; do ssh-copy-id $i; done
for i in $hosts; do scp /etc/hosts $i:/etc/hosts; done

#repos
for i in $hosts; do scp /etc/apt/sources.list.d/sources.list $i:/etc/apt/sources.list.d/sources.list; done
for i in $hosts; do scp /etc/apt/sources.list.d/alt.list $i:/etc/apt/sources.list.d/alt.list; done
for i in $hosts; do ssh $i apt-get update; done

#update
for i in $hosts; do ssh $i apt-get dist-upgrade -y; done
for i in $hosts; do ssh $i update-kernel; done
for i in $hosts; do ssh $i init 6; done
for i in $hosts; do ssh $i uname -r; done

#ntp
for i in $hosts; do ssh $i apt-get install ntpd -y; done
for i in $hosts; do ssh $i chkconfig ntpd on; done
for i in $hosts; do scp /etc/ntpd.conf $i:/etc/ntdp.conf; done
for i in $hosts; do ssh $i service ntpd start; done

#zabbix
for i in $hosts; do ssh $i apt-get install zabbix-agent -y; done
for i in $hosts; do ssh $i chkconfig zabbix_agentd on; done
for i in $hosts; do ssh $i sed -i 's/^Server=127.0.0.1/Server=pts-test-zab1c/g' /etc/zabbix/zabbix_agentd.conf; done
for i in $hosts; do ssh $i sed -i 's/^ServerActive=127.0.0.1/ServerActive=pts-test-zab1c/g' /etc/zabbix/zabbix_agentd.conf; done
for i in $hosts; do ssh $i sed -i 's/.localdomain//g' /etc/zabbix/zabbix_agentd.conf; done
for i in $hosts; do ssh $i service zabbix_agentd start; done

#tablespaces
for i in $dbs; do ssh $i mkdir /var/lib/pgsql/9.6/pts/{fdc_pts_big_ind,fdc_pts_big_tab,fdc_pts_ind,fdc_pts_tab} -p; done
for i in $dbs; do ssh $i mkdir /var/lib/pgsql/9.6/pts/{fdc_trans_ind,fdc_trans_tab} -p; done
for i in $dbs; do ssh $i chown postgres.postgres /var/lib/pgsql/9.6/pts -R; done

#tomcat
for i in $apps; do ssh $i useradd tomcat; done
for i in $apps; do ssh $i mkdir /root/distr /u01; done
for i in $apps; do scp /root/distr/jdk-8u161-linux-x64.tar.gz  $i:/root/distr/jdk-8u161-linux-x64.tar.gz; done
for i in $apps; do scp /root/distr/apache-tomcat-8.5.29.tar.gz  $i:/root/distr/apache-tomcat-8.5.29.tar.gz; done
for i in $apps; do ssh $i tar -xf /root/distr/jdk-8u161-linux-x64.tar.gz -C /u01; done
for i in $apps; do ssh $i tar -xf /root/distr/apache-tomcat-8.5.29.tar.gz -C /u01; done
for i in $apps; do ssh $i chown tomcat.tomcat /u01/jdk1.8.0_161 -R; done
for i in $apps; do ssh $i chown tomcat.tomcat /u01/apache-tomcat-8.5.29 -R; done
for i in $apps; do ssh $i mkdir /u01/apache-tomcat-8.5.29/logs -p; done
for i in $apps; do scp /root/distr/tomcat_users  $i:/u01/apache-tomcat-8.5.29/conf/tomcat-users.xml; done
for i in $apps; do scp /root/distr/tomcat.service  $i:/etc/systemd/system/tomcat.service; done
for i in $apps; do scp /root/distr/manager_context  $i:/u01/apache-tomcat-8.5.29/webapps/manager/META-INF/context.xml; done
for i in $apps; do ssh $i chown tomcat.tomcat /u01/apache-tomcat-8.5.29/webapps/manager/META-INF/context.xml; done
#wars
for i in $portal; do scp distr/pts-portal-0.28.6.war $i:/opt/apache-tomcat-8.5.29/webapps/portal.war; done
for i in $portal; do scp distr/pts-public-0.28.6.war $i:/opt/apache-tomcat-8.5.29/webapps/mobile.war; done
for i in $integr; do scp distr/pts-integration-0.28.6.war $i:/opt/apache-tomcat-8.5.29/webapps/integration.war; done
for i in $joint; do scp distr/pts-jointstorage-0.28.6.war $i:/opt/apache-tomcat-8.5.29/webapps/jointstorage.war; done
for i in $arm; do scp distr/pts-restricted-0.28.6.war $i:/opt/apache-tomcat-8.5.29/webapps/pts.war; done
for i in $smev; do scp distr/Smev*.war $i:/opt/apache-tomcat-8.5.29/webapps/; done

#haproxy, keepalived
for i in $haproxy; do ssh $i apt-get install keepalived -y; done
for i in $haproxy; do ssh $i apt-get install haproxy -y; done

#Databases
#Non Certified distro
for i in $dbs; do scp /etc/apt/sources.list.d/pgpro.list $i:/etc/apt/sources.list.d/pgpro.list; done
for i in $dbs; do ssh $i apt-get update; done
for i in $dbs; do ssh $i apt-get update; done

#LVMs
for i in $dbs; do ssh $i pvcreate /dev/sdb1; done
for i in $dbs; do ssh $i vgcreate pgdata /dev/sdb1; done
for i in $dbs; do ssh $i lvcreate -n pgdata -L299G pgdata; done
for i in $dbs; do ssh $i mkfs.ext4 -L pgdata /dev/pgdata/pgdata; done
for i in $dbs; do ssh $i mkdir /u01/pgdata; done
for i in $dbs; do ssh $i 'echo "/dev/mapper/pgdata-pgdata /u01/pgdata ext4 defaults  1 2">>/etc/fstab'; done
for i in $dbs; do ssh $i mount -a; done

#Certified distro
for i in $dbs; do ssh $i mkdir /root/PostgresPro_Cert ; done
for i in $dbs; do scp /root/distr/PostgresProStdCert9.6.3.1.iso $i:/root/PostgresPro_Cert/PostgresProStdCert9.6.3.1.iso; done
for i in $dbs; do ssh $i mkdir /mnt/postgres; done
for i in $dbs; do ssh $i mount /root/PostgresPro_Cert/PostgresProStdCert9.6.3.1.iso /mnt/postgres; done
cat > /tmp/pgprocert.list <<EOF
rpm file:/mnt/postgres/altlinux-spt/7/ x86_64 pgpro
EOF
for i in $dbs; do ssh $i mkdir /tmp/src; done
for i in $dbs; do ssh $i mv /etc/apt/sources.list.d/* /tmp/src/; done
for i in $dbs; do scp /tmp/pgprocert.list $i:/etc/apt/sources.list.d/pgprocert.list; done
for i in $dbs; do ssh $i apt-get clean; done
for i in $dbs; do ssh $i apt-get update; done
for i in $dbs; do ssh $i apt-get install libpq5.8 libpq5.8-devel -y; done
for i in $dbs; do ssh $i cp /tmp/src/* /etc/apt/sources.list.d/; done
for i in $dbs; do ssh $i apt-get update; done
for i in $dbs; do ssh $i apt-get install postgrespro9.6-server -y; done
for i in $dbs; do ssh $i apt-get install postgrespro9.6-contrib -y; done

for i in $dbs; do ssh $i mv /var/lib/pgsql/9.6 /u01/pgdata/9.6; done
for i in $dbs; do ssh $i ln -s /u01/pgdata/9.6 /var/lib/pgsql/9.6; done

for i in $dbm; do scp /tmp/postgresql.conf $i:/u01/pgdata/9.6/data/postgresql.conf; done
for i in $dbm; do scp /tmp/pg_hba.conf $i:/u01/pgdata/9.6/data/pg_hba.conf; done

#mamonsu
for i in $dbs; do ssh $i apt-get install python-module-pip -y; done
for i in $dbs; do ssh $i pip install mamonsu; done
for i in $dbs; do ssh $i mkdir /etc/mamonsu; done
for i in $dbs; do ssh $i mkdir /var/log/mamonsu; done
for i in $dbs; do scp /tmp/mamonsu  $i:/etc/init.d/mamonsu; done
for i in $dbs; do ssh $i chmod 755 /etc/init.d/mamonsu; done
for i in $dbs; do scp /tmp/agent.conf $i:/etc/mamonsu/agent.conf; done
#correnct mamonsu client param
for i in $dbs; do ssh $i sed -i "s/pts-test-db1c/$i/g" /etc/mamonsu/agent.conf; done
for i in $dbs; do ssh $i useradd mamonsu; done
for i in $dbs; do ssh $i service mamonsu start; done
for i in $dbs; do ssh $i chkconfig mamonsu on; done

#pgbouncer
for i in $dbs; do ssh $i apt-get install pgbouncer; done
for i in $dbs; do scp ./tmp/pgbouncer.service $i:/etc/systemd/system/pgbouncer.service; done
for i in $dbs; do ssh $i mkdir /var/log/pgbouncer; done
for i in $dbs; do ssh $i chown pgbouncer.pgbouncer /var/log/pgbouncer; done
for i in $dbs; do ssh $i systemctl daemon-reload; done
for i in $dbs; do ssh $i systemctl start pgbouncer; done
for i in $dbs; do ssh $i systemctl enable pgbouncer; done

#crontab
for i in $hosts; do ssh $i systemctl start crond; done
for i in $hosts; do ssh $i systemctl enable crond; done
