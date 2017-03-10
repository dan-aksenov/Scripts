yum -y install https://www.snort.org/downloads/snort/daq-2.0.6-1.centos7.x86_64.rpm
                      
yum -y install https://www.snort.org/downloads/snort/snort-2.9.9.0-1.centos7.x86_64.rpm

# download rules. need to get correct link for snapshot-2990
cd ~/Downloads
# daq & snort 
wget https://www.snort.org/downloads/registered/snortrules-snapshot-2990.tar.gz
wget https://www.snort.org/downloads/community/community-rules.tar.gz
# base
wget http://sourceforge.net/projects/secureideas/files/BASE/base-1.4.5/base-1.4.5.tar.gz
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

cat > /lib/systemd/system/barnyard2.service << EOF
[Unit]
Description=Barnyard2 Daemon
After=syslog.target network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/barnyard2 -c /etc/barnyard2.conf -d /var/log/snort -f snort.u2 -w /var/log/snort/barnyard2.waldo -g snort -u snort

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl start snort
sudo systemctl enable snort

sudo firewall-cmd --permanent --zone=public --add-service http
sudo firewall-cmd --reload

# Installing base
yum install httpd yum-utils php-pear php-pgsql php-mbstring php php-adodb

sudo mkdir /var/www/base/
sudo mv base-1.4.5/* /var/www/base/
chown -R apache.apache /var/www/base

cat > /etc/httpd/conf.d/base.conf << EOF
Alias /base/ /var/www/base/
<Directory "/var/www/base/">
  AllowOverride All
</Directory>
EOF

# pulledpork(srnot rules updater) install 
# install required pearls
sudo yum install perl-libwww-perl perl-Crypt-SSLeay perl-Sys-Syslog perl-Archive-Tar perl-LWP-Protocol-https
git clone https://github.com/shirkdog/pulledpork
tar xzvf pulledpork-master.tar.gz
cd pulledpork
sudo cp pulledpork.pl /usr/local/bin
sudo chmod +x /usr/local/bin/pulledpork.pl
sudo cp etc/*.conf /etc/snort

user@snortserver:~$ /usr/local/bin/pulledpork.pl -V

sudo vim /etc/snort/pulledpork.conf

# edit:
#Line 19:  enter your oinkcode where appropriate (or comment out if no oinkcode)
#Line 29:  Un-comment for Emerging threats ruleset (not tested with this guide)
#Line 74:  change to: rule_path=/etc/snort/rules/snort.rules
#Line 89:  change to: local_rules=/etc/snort/rules/local.rules
#Line 92:  change to: sid_msg=/etc/snort/sid-msg.map
#Line 96:  change to: sid_msg_version=2
#Line 119:  change to: config_path=/etc/snort/snort.conf
#Line 133:  change to: distro=Ubuntu-12-04
#Line 141:  change to: black_list=/etc/snort/rules/iplists/black_list.rules
#Line 150:  change to: IPRVersion=/etc/snort/rules/iplists

sudo /usr/local/bin/pulledpork.pl -c /etc/snort/pulledpork.conf -l

crontab -e 
1 0 * * * /usr/local/bin/pulledpork.pl -c /etc/snort/pulledpork.conf -l