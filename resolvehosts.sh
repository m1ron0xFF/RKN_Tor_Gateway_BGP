#!/bin/bash
source ./config.sh

# Resolve A records from hostnames and build IP-Hostname file (hosts)
parallel -j 8 -n 128 --progress -a hostlist.txt "dig a +noadditional +noauthority +nocmd +nocomments +time=2 +tries=1 {} @${DNS1} | awk '/^$/ {next} /^;/ {next} \$5 ~ /\.$/ {next}  {print \$5,\$1}'" > resolved-hostnames-ipdomain.txt
sort -u < resolved-hostnames-ipdomain.txt > resolved-hostnames-ipdomain_.txt
rm resolved-hostnames-ipdomain.txt
mv resolved-hostnames-ipdomain_.txt resolved-hostnames-ipdomain.txt

# Build IP only file from resolved previously hostnames
awk '{print $1}' resolved-hostnames-ipdomain.txt > resolved-hostnames-t.txt

# Resolve IP addresses only from another DNS server
if [ "$DNS2" ];
then
parallel -j 8 -n 128 --progress -a hostlist.txt "dig a +short +time=2 +tries=1 {} @${DNS2}" >> resolved-hostnames-t.txt
fi;

# Deal with ignored hosts
echo -n > ./ignorehosts-resolved.txt
parallel -j 1 -a ignorehosts.txt 'echo Resolving {}; dig a +short {} | egrep "^([0-9]{1,3}\.){3}[0-9]" >> ./ignorehosts-resolved.txt'

# Build final IP list
cat resolved-hostnames-t.txt iplist.txt > resolved-hostnames-f.txt
cat resolved-hostnames-f.txt | egrep '^([0-9]{1,3}\.){3}([0-9]){1,3}$' | sort -u | grep -v -f ignoreips.txt | grep -v -f ignorehosts-resolved.txt > iplist.txt
echo -n "Total IPs after resolving: "
cat iplist.txt | wc -l
