yum -y install https://www.snort.org/downloads/snort/daq-2.0.6-1.centos7.x86_64.rpm
                      
yum -y install https://www.snort.org/downloads/snort/snort-2.9.9.0-1.centos7.x86_64.rpm

# download rules
cd ~/Downloads
wget https://www.snort.org/downloads/registered/snortrules-snapshot-2990.tar.gz
wget https://www.snort.org/downloads/community/community-rules.tar.gz


# setup snort.conf

# barnyard2 - compile from souce
# need to download and compile
# libdnet-1.11.tar.gz
# libpcap-1.8.1.tar.gz