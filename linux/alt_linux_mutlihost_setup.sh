for i in $hosts; do ssh-copy-id $i; done
for i in $hosts; do scp /etc/hosts $i:/etc/hosts; done

for i in $hosts; do scp /etc/apt/sources.list.d/sources.list $i:/etc/apt/sources.list.d/sources.list; done
for i in $hosts; do scp /etc/apt/sources.list.d/alt.list $i:/etc/apt/sources.list.d/alt.list; done
for i in $hosts; do ssh $i apt-get update; done

for i in $hosts; do ssh $i apt-get dist-upgrade -y; done
for i in $hosts; do ssh $i update-kernel -y; done
for i in $hosts; do ssh $i init 6; done

for i in $hosts; do ssh $i uname -r; done

for i in $hosts; do ssh $i apt-get install ntpd -y; done
for i in $hosts; do ssh $i chkconfig ntpd on; done
for i in $hosts; do scp /etc/ntpd.conf $i:/etc/ntdp.conf; done
for i in $hosts; do ssh $i service ntpd start; done

for i in $hosts; do ssh $i apt-get install zabbix-agent -y; done
for i in $hosts; do ssh $i chkconfig zabbix_agentd on; done
for i in $hosts; do ssh $i sed -i 's/^Server=127.0.0.1/Server=pts-test-zab1c/g' /etc/zabbix/zabbix_agentd.conf; done
for i in $hosts; do ssh $i sed -i 's/^ServerActive=127.0.0.1/ServerActive=pts-test-zab1c/g' /etc/zabbix/zabbix_agentd.conf; done
for i in $hosts; do ssh $i sed -i 's/.localdomain//g' /etc/zabbix/zabbix_agentd.conf; done