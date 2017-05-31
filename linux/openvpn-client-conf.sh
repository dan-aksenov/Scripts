#!/bin/bash
# 1 - username, 2 - mailto
username=$1
mailto=$2
easyrsa_location=/opt/easy-rsa-master/easyrsa3
cd $easyrsa_location
$easyrsa_location/easyrsa build-client-full $username nopass
cat >$username.ovpn <<EOF
dev tun
proto tcp
remote 80.79.70.34 1194
client
resolv-retry infinite
<ca>
EOF
cat /etc/openvpn/ca.crt >> $username.ovpn
cat >>$username.ovpn <<EOF
</ca>
<cert>
EOF
cat $easyrsa_location/pki/issued/$username.crt >> $username.ovpn
cat >>$username.ovpn <<EOF
</cert>
<key>
EOF
cat $easyrsa_location/pki/private/$username.key >> $username.ovpn
cat >>$username.ovpn <<EOF
</key>
key-direction 1
<tls-auth>
EOF
cat /etc/openvpn/ta.key >> $username.ovpn
cat >>$username.ovpn <<EOF
</tls-auth>
remote-cert-tls server
persist-key
persist-tun
comp-lzo
verb 3
EOF

echo "$username 's openvpn config" | mail -s "Subject Here" -a $username.ovpn $mailto
