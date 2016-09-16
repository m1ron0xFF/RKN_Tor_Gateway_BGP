#!/bin/sh

# Download list
curl -o list.xml https://api.antizapret.info/group.php

tr ',' '\n' < list.xml > iplist.txt


# # Collapse IP Addresses
# ./collapse.py

sed 's/$/\/32/g' iplist.txt > new-ips.txt

sed 's/^/  network /' new-ips.txt > final-ips.txt

perl quagga_conf_builder.sh

cat final-ips.txt >> bgpd.conf

cp bgpd.conf /etc/quagga/bgpd.conf

service quagga restart bgpd