#!/bin/sh

# Extract IP addresses from list
tail -n +2 list.xml | grep -v -f ignorehosts.txt | awk -F ';' '{print $1}' | sed 's/ | /\n/g' | cat - customips.txt | sort -u | grep -v -f ignoreips.txt > iplist.txt
echo -n "Unique IPs in list: "
cat iplist.txt | wc -l

