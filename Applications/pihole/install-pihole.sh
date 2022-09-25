#!/bin/bash
#Script ausführen mit:
#rm install-pihole.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/pihole/install-pihole.sh &> /dev/null; bash install-pihole.sh

# create Applikations folder
mkdir -p /var/homeautomation/pihole


# create bind9 config File 
mkdir -p /var/homeautomation/pihole/voulumes/bind9/etc-bind
cd /var/homeautomation/pihole/voulumes/bind9/etc-bind
echo "options {
	directory \"/var/cache/bind\";

	// If there is a firewall between you and nameservers you want
	// to talk to, you may need to fix the firewall to allow multiple
	// ports to talk.  See http://www.kb.cert.org/vuls/id/800113

	// If your ISP provided one or more IP addresses for stable 
	// nameservers, you probably want to use them as forwarders.  
	// Uncomment the following block, and insert the addresses replacing 
	// the all-0's placeholder.

	// Set the IP addresses of your ISP's DNS servers:
	// forwarders {
	//	1.2.3.4;
	//	5.6.7.8;
	// };

	//========================================================================
	// If BIND logs error messages about the root key being expired,
	// you will need to update your keys.  See https://www.isc.org/bind-keys
	//========================================================================
	dnssec-validation auto;

	listen-on-v6 { any; };
};" > named.conf


# change to folder
cd /var/homeautomation/pihole

# downlod docker-compose.yml and run it
rm docker-compose.yml &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/pihole/docker-compose.yml &> /dev/null

docker-compose up -d