#!/usr/bin/env python3
import ipaddress
addrlist = open('iplist.txt', 'r').read()
nlist = [ipaddress.IPv4Address(addr) for addr in addrlist.split()]
print('IP Addresses before collapsing:', len(nlist))
collapsed_file_prefix = open('iplist_collapsed_prefix.txt', 'w')
collapsed_file_mask = open('iplist_collapsed_mask.txt', 'w')
collapsed = ipaddress.collapse_addresses(nlist)
cnt = 0
for addr in collapsed:
    print(addr, file=collapsed_file_prefix)
    print(addr.with_netmask.replace('/', ' '), file=collapsed_file_mask)
    cnt+=1
print('IP Addresses after collapsing:', cnt)
