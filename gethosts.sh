#!/bin/sh

# Extract hosts from list
tail -n +2 list.xml | grep -v -f ignoreips.txt | awk -F ';' '{print $2}' | cat - customhosts.txt | sort -u | grep -v -f ignorehosts.txt > hostlist.txt
echo -n "Unique hosts in list: "
cat hostlist.txt | wc -l
