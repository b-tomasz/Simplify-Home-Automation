#!/bin/bash
#Script ausführen mit:
#cd /tmp; rm install-pihole.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/03-pihole/install-pihole.sh &> /dev/null; bash install-pihole.sh

CONTAINER_ID=03
CONTAINER_NAME=pihole

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

    };" > /var/homeautomation/$CONTAINER_NAME/volumes/bind9/etc-bind/named.conf
    
    echo "
    //
    // Do any local configuration here
    //

    // Consider adding the 1918 zones here, if they are not used in your
    // organization
    //include "/etc/bind/zones.rfc1918";
    
    
    zone "home" {

        type master;

        file "/var/lib/bind/master/home";

    };

    };" > /var/homeautomation/$CONTAINER_NAME/volumes/bind9/etc-bind/named.conf.local
    
    mkdir -p /var/homeautomation/$CONTAINER_NAME/volumes/bind9/var-lib-bind/master
    echo "

    \$TTL    60
    \$ORIGIN home.
    @    IN    SOA    ns1.home. home (
         2022101102        ; Versionsnummer, für die Slaves
                 60        ; Refresh
                 60        ; Retry
                600        ; Expire
                 60 )      ; Negative Cache TTL

    @                  IN NS ns1   ;primärer Nameserver, das ist derselbige, den wir gerade konfigurieren
    @                  IN A 192.168.1.51
    *                  IN A 192.168.1.51


    ns1                IN A 10.0.30.2  ;
    " > /var/homeautomation/$CONTAINER_NAME/volumes/bind9/var-lib-bind/master/home
    
    
    # change to folder
    cd /var/homeautomation/$CONTAINER_NAME
    
    # ask User for Pihole Password
    while true
    do
        PASSWORD=$(whiptail --title "Pihole Password" --nocancel --passwordbox "Please Enter a password for your Pihole:" 8 78  3>&1 1>&2 2>&3)
        if [ $(whiptail --title "Piihole Password" --nocancel --passwordbox "Please Confirm your Password:" 8 78  3>&1 1>&2 2>&3) = $PASSWORD ];then
            break
        else
            whiptail --title "Pihole Password" --msgbox "The Passwords you entred do not match.\nPlease Try it again." 8 78
        fi
    done
    
    # downlod docker-compose.yml and run it
    rm docker-compose.yml &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/$CONTAINER_ID-$CONTAINER_NAME/docker-compose.yml &> /dev/null
    
    
    # Start Container
    WEBPASSWORD=$PASSWORD docker-compose up -d
    
}

# Upgrade Tools
upgrade (){
    
    #### ToDo
    echo upgrade
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