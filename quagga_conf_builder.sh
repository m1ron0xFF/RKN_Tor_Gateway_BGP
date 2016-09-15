#!/usr/bin/perl

my $host="bgpd";         #quagga router name
my $logpass="zebra";            #login password
my $enable="zebra";             #enable password
my $myasn="65530";              #local AS number
my $router_id="192.168.1.252";     #bgp router-id
my $remote_as="65530";          #remote-as number
my $remote_ip="192.168.1.254";     #BGP neighbor ip address


open (BGPCONF,'>bgpd.conf')|| die "Can not open bgpd.conf for writing";
print BGPCONF "hostname $host\npassword $logpass\nenable password $enable\nline vty \n";
print BGPCONF "router bgp $myasn\n  bgp router-id $router_id\n  neighbor $remote_ip remote-as $remote_as\n";

close BGPCONF;