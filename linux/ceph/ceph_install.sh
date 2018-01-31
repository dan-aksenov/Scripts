# delete ceph conf.
sudo -i -u ceph-deploy
cd cluster-conf
ceph-deploy purge ceph01 ceph02 ceph03
ceph-deploy purgedata ceph01 ceph02 ceph03
ceph-deploy forgetkeys
rm ceph.*

# create new

ceph-deploy new ceph02
#edit ceph.conf
#add public network
#add cluster network


#ceph-deploy install ceph01 ceph02 ceph03
# or manually

ceph-deploy mon create-initial
ceph-deploy admin ceph01 ceph02 ceph03

ceph-deploy mgr create ceph01

ceph-deploy osd create ceph01:sdb1 ceph02:sdb1 ceph03:sdb1
ceph-deploy osd create ceph01:sdc1 ceph02:sdc1 ceph03:sdc1
ceph-deploy osd create ceph01:sdd1 ceph02:sdd1 ceph03:sdd1
ceph-deploy osd create ceph01:sde1 ceph02:sde1 ceph03:sde1

# Zabbix monitoring
sudo yum install zabbix-sender
sudo ceph mgr module enable zabbix
sudo ceph config-key set mgr/zabbix/zabbix_host oemcc.fors.ru
sudo ceph config-key set mgr/zabbix/identifier ceph02.fors.ru