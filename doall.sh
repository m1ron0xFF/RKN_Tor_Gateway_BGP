#!/bin/sh

# Download list
curl -o list_cp1251.xml https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv
iconv -f cp1251 -t utf8 list_cp1251.xml > list.xml

# Get IP addresses from list
./getips.sh

# Get hostnames from list
# ./gethosts.sh

# Resolve A record from hostnames
# ./resolvehosts.sh

# # Collapse IP Addresses
# ./collapse.py

sed 's/$/\/32/g' iplist.txt > new-ips.txt

sed 's/^/ network /' new-ips.txt > final-ips.txt

perl quagga_conf_builder.sh

cat final-ips.txt >> bgpd.conf

cp bgpd.conf /etc/quagga/bgpd.conf

service quagga restart bgpd