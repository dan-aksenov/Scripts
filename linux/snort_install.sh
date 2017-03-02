yum -y install https://www.snort.org/downloads/snort/daq-2.0.6-1.centos7.x86_64.rpm
                      
yum -y install https://www.snort.org/downloads/snort/snort-2.9.9.0-1.centos7.x86_64.rpm

# download rules. need to get correct link for snapshot-2990
cd ~/Downloads
wget https://www.snort.org/downloads/registered/snortrules-snapshot-2990.tar.gz
wget https://www.snort.org/downloads/community/community-rules.tar.gz
cd

# setup snort.conf

# Create systemd file
cat > /lib/systemd/system/snort.service<< EOF
[Unit]
Description=Snort NIDS Daemon
After=syslog.target network.target

[Service]
Type=simple
ExecStart=/usr/sbin/snort -c /etc/snort/snort.conf -dev -u snort -g snort -D -l /var/log/snort -i eno16777984 -P 65535

[Install]
WantedBy=multi-user.target
EOF

sudo mkdir -p /usr/local/lib/snort_dynamicrules
sudo chown -R snort.snort /usr/local/lib/snort_dynamicrules
sudo chmod -R 700 /usr/local/lib/snort_dynamicrules

sudo touch /etc/snort/rules/white_list.rules
sudo touch /etc/snort/rules/black_list.rules

sudo systemctl start snort
sudo systemctl enable snort

# barnyard2 - compile from souce
# need to download and compile
# libdnet-1.11.tar.gz
# libpcap-1.8.1.tar.gz

# install needed stuff
sudo yum install gcc gcc-c++ flex bison libtool
#compile libdnet libpcap

sudo yum install libtool
# compile barnyard
./autogen
./configure --with-postgresql=/usr/pgsql-9.5
# must have postgresql devel package!
make && sudo make install

# check you database name host and user!
sudo -u postgres psql snort -f /tmp/create_postgresql

sudo mkir /var/log/barnyard2

yum install httpd yum-utils php-pear php-pgsql php-mbstring php php-adodb