#!/bin/bash
#Script ausführen mit:
#cd /tmp; rm install-pihole.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/03-pihole/install-pihole.sh &> /dev/null; bash install-pihole.sh

CONTAINER_ID=03
CONTAINER_NAME=pihole
PASSWORD=$1

source /var/homeautomation/script/config/ip.conf

install (){
    
    # create Applikations folder
    mkdir -p /var/homeautomation/$CONTAINER_NAME
    
    # create bind9 config File
    mkdir -p /var/homeautomation/$CONTAINER_NAME/volumes/bind9/etc-bind
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

    };

    include \"/etc/bind/named.conf.local\";" > /var/homeautomation/$CONTAINER_NAME/volumes/bind9/etc-bind/named.conf
    
    
    
    echo "
    //
    // Do any local configuration here
    //

    // Consider adding the 1918 zones here, if they are not used in your
    // organization
    //include \"/etc/bind/zones.rfc1918\";


    zone \"home\" {

        type master;

        file \"/var/lib/bind/master/home\";

    };
        zone \"unifi\" {

        type master;

        file \"/var/lib/bind/master/unifi\";

    };
    zone \"$EXTERNAL_DOMAIN\" {

        type master;

        file \"/var/lib/bind/master/$EXTERNAL_DOMAIN\";

    };
    zone \"10.10.in-addr.arpa\" {

        type master;

        file \"/var/lib/bind/master/reverse\";

    };
    " > /var/homeautomation/$CONTAINER_NAME/volumes/bind9/etc-bind/named.conf.local
    
    # Insert Zone File. Attention: Make sure that there are no spaces in Font of each line
    mkdir -p /var/homeautomation/$CONTAINER_NAME/volumes/bind9/var-lib-bind/master
    echo "\$TTL    3600
\$ORIGIN home.
@    IN    SOA    ns1.home. home. (
     2022101101        ; Versionsnummer, für die Slaves
           3600        ; Refresh
            600        ; Retry
         604800        ; Expire
           1800 )      ; Negative Cache TTL

@                  IN NS ns1   ;primärer Nameserver, das ist derselbige, den wir gerade konfigurieren
@                  IN A $FIXED_IP
*                  IN A $FIXED_IP

ns1                IN A 10.10.30.2  ;
    " > /var/homeautomation/$CONTAINER_NAME/volumes/bind9/var-lib-bind/master/home
    
    echo "\$TTL    3600
\$ORIGIN unifi.
@    IN    SOA    ns1.unifi. unifi. (
     2022101101        ; Versionsnummer, für die Slaves
           3600        ; Refresh
            600        ; Retry
         604800        ; Expire
           1800 )      ; Negative Cache TTL

@                  IN NS ns1   ;primärer Nameserver, das ist derselbige, den wir gerade konfigurieren
@                  IN A $FIXED_IP

ns1                IN A 10.10.30.2  ;
    " > /var/homeautomation/$CONTAINER_NAME/volumes/bind9/var-lib-bind/master/unifi
    
    echo "\$TTL    3600
\$ORIGIN $EXTERNAL_DOMAIN.
@    IN    SOA    ns1.$EXTERNAL_DOMAIN. $EXTERNAL_DOMAIN. (
     2022101101        ; Versionsnummer, für die Slaves
           3600        ; Refresh
            600        ; Retry
         604800        ; Expire
           1800 )      ; Negative Cache TTL

@                  IN NS ns1   ;primärer Nameserver, das ist derselbige, den wir gerade konfigurieren
@                  IN A $FIXED_IP
*                  IN A $FIXED_IP

ns1                IN A 10.10.30.2  ;
    " > /var/homeautomation/$CONTAINER_NAME/volumes/bind9/var-lib-bind/master/$EXTERNAL_DOMAIN

    echo "\$TTL    3600
\$ORIGIN 10.10.in-addr.arpa.
@    IN    SOA    10.10.in-addr.arpa. $EXTERNAL_DOMAIN. (
     2022101101        ; Versionsnummer, für die Slaves
           3600        ; Refresh
            600        ; Retry
         604800        ; Expire
           1800 )      ; Negative Cache TTL

@                  IN NS ns1   ;primärer Nameserver, das ist derselbige, den wir gerade konfigurieren
1.00               IN PTR   docker-gw.$EXTERNAL_DOMAIN.
1.10               IN PTR   nginx.$EXTERNAL_DOMAIN.
2.10               IN PTR   certbot.$EXTERNAL_DOMAIN.
1.20               IN PTR   portainer.$EXTERNAL_DOMAIN.
1.30               IN PTR   pihole.$EXTERNAL_DOMAIN.
2.30               IN PTR   bind9.$EXTERNAL_DOMAIN.
                   IN PTR   ns1.$EXTERNAL_DOMAIN.
1.40               IN PTR   wireguard.$EXTERNAL_DOMAIN.
1.41               IN PTR   vpn-user.$EXTERNAL_DOMAIN.
1.50               IN PTR   bitwarden.$EXTERNAL_DOMAIN.
1.60               IN PTR   nodered.$EXTERNAL_DOMAIN.
1.70               IN PTR   database.$EXTERNAL_DOMAIN.
2.70               IN PTR   adminer.$EXTERNAL_DOMAIN.
1.80               IN PTR   grafana.$EXTERNAL_DOMAIN.
1.90               IN PTR   unifi.$EXTERNAL_DOMAIN.

ns1                IN A 10.10.30.2  ;
    " > /var/homeautomation/$CONTAINER_NAME/volumes/bind9/var-lib-bind/master/reverse
    
    
    # change to folder
    cd /var/homeautomation/$CONTAINER_NAME
      
    # downlod docker-compose.yml and run it
    rm docker-compose.yml &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/$CONTAINER_ID-$CONTAINER_NAME/docker-compose.yml &> /dev/null
    
    
    # Start Container
    EXTERNAL_DOMAIN=$EXTERNAL_DOMAIN WEBPASSWORD=$PASSWORD docker-compose up -d
    
}

# Upgrade Tools
upgrade (){
    
    docker-compose up -d
}

uninstall (){
    # Stop container
    cd /var/homeautomation/$CONTAINER_NAME
    docker-compose down
}

remove_data (){
    # Remove Application Folder
    rm -rv /var/homeautomation/$CONTAINER_NAME
}

# Get the options
while getopts "urg" option; do
    case $option in
        u) # uninstall
        UNINSTALL=true;;
        r) # remove Data
        REMOVE_DATA=true;;
        g) # upgrade
        UPGRADE=true;;
        \?) # Invalid option
            echo "Error: Invalid option"
        exit;;
    esac
done


if [ $UNINSTALL ] ;then
    # Uninstall Tools
    uninstall
    elif [ $UPGRADE ] ;then
    # Upgrade Tools
    upgrade
else
    if [ $REMOVE_DATA ] ;then
        # Invalid Option
        echo "Error: Invalid option"
        exit 1
    else
        # Install Tools
        install
    fi
fi

if [ $REMOVE_DATA ] ;then
    # Uninstall Tools and remove data
    remove_data
fi