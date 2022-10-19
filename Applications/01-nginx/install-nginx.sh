#!/bin/bash
#Script ausführen mit:
#cd /tmp; rm install-nginx.sh &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/01-nginx/install-nginx.sh &> /dev/null; bash install-nginx.sh

CONTAINER_ID=01
CONTAINER_NAME=nginx

source /var/homeautomation/script/config/ip.conf

install (){
    
    # create Applikations folder
    mkdir -p /var/homeautomation/$CONTAINER_NAME
    
    # create nginx config File
    mkdir -p /var/homeautomation/$CONTAINER_NAME/volumes/nginx/conf.d
    
    # change to folder
    cd /var/homeautomation/$CONTAINER_NAME
    
    # downlod docker-compose.yml and run it
    rm docker-compose.yml &> /dev/null; wget https://raw.githubusercontent.com/b-tomasz/Simplify-Home-Automation/main/Applications/$CONTAINER_ID-$CONTAINER_NAME/docker-compose.yml &> /dev/null
    
    
    
    if [ $NO_EXTERNAL_DOMAIN = true ]; then
        
        # Continue without an external Domain
        # Create real Config
        echo "#Complete Nginx Docker reverse proxy config file
server {
  listen 80;
  listen [::]:80;
  server_name localhost nginx.home nginx.$EXTERNAL_DOMAIN;

  location / {
    root /usr/share/nginx/html;
    index index.html index.htm;
  }

  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }
}

###   Portainer    ###

server {
  listen 80;
  deny $FIXED_IP_GW;
  server_name portainer.home portainer.$EXTERNAL_DOMAIN;
  location / {
    proxy_pass http://10.10.20.1:9000;
  }
  #These header fields are required if your application is using Websockets
  proxy_set_header Upgrade $http_upgrade;

  #These header fields are required if your application is using Websockets    
  proxy_set_header Connection "upgrade";
}

###   Pihole    ###

server {
  listen 80;
  allow  192.168.0.0/16;
  allow  10.0.0.0/8;
  allow  172.16.0.0/12;
  deny   all;
  server_name pihole.home pihole.$EXTERNAL_DOMAIN;
  location / {
    proxy_pass http://10.10.30.1;
  }
  #These header fields are required if your application is using Websockets
  proxy_set_header Upgrade $http_upgrade;

  #These header fields are required if your application is using Websockets    
  proxy_set_header Connection "upgrade";
}

###   Nodered    ###

server {
  listen 80;
  allow  192.168.0.0/16;
  allow  10.0.0.0/8;
  allow  172.16.0.0/12;
  deny   all;
  server_name nodered.home nodered.$EXTERNAL_DOMAIN;
  location / {
    proxy_pass http://10.10.60.1:1880;
  }
  #These header fields are required if your application is using Websockets
  proxy_set_header Upgrade $http_upgrade;

  #These header fields are required if your application is using Websockets    
  proxy_set_header Connection "upgrade";
}

###   Database    ###

server {
  listen 80;
  allow  192.168.0.0/16;
  allow  10.0.0.0/8;
  allow  172.16.0.0/12;
  deny   all;
  server_name database.home database.$EXTERNAL_DOMAIN;
  location / {
    proxy_pass http://10.10.70.2:8080;
  }
  #These header fields are required if your application is using Websockets
  proxy_set_header Upgrade $http_upgrade;

  #These header fields are required if your application is using Websockets    
  proxy_set_header Connection "upgrade";
}

###   Grafana    ###

server {
  listen 80;
  allow  192.168.0.0/16;
  allow  10.0.0.0/8;
  allow  172.16.0.0/12;
  deny   all;
  server_name grafana.home grafana.$EXTERNAL_DOMAIN;
  location / {
    proxy_pass http://10.10.80.1:3000;
  }
  #These header fields are required if your application is using Websockets
  proxy_set_header Upgrade $http_upgrade;

  #These header fields are required if your application is using Websockets    
  proxy_set_header Connection "upgrade";
}

###   Unifi    ###

server {
  listen 80;
  allow  192.168.0.0/16;
  allow  10.0.0.0/8;
  allow  172.16.0.0/12;
  deny   all;
  server_name unifi.home unifi.$EXTERNAL_DOMAIN;
  return 301 https://unifi.home:8443$request_uri;
}

" > /var/homeautomation/$CONTAINER_NAME/volumes/nginx/conf.d/homeautomation.conf
        

      # Start Container
        docker-compose up -d
        sleep 5

    else
        # Continue with an external Domain
        
        # Create dummy Config
        echo "#Complete Nginx Docker reverse proxy config file
server {
  listen 80;
  listen [::]:80;
  server_name localhost nginx.home nginx.$EXTERNAL_DOMAIN;

  location / {
    root /usr/share/nginx/html;
    index index.html index.htm;
  }

  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }
}
server {
  listen 80;
  server_name *.$EXTERNAL_DOMAIN $EXTERNAL_DOMAIN;
  location /.well-known/acme-challenge/ {
    proxy_pass http://10.10.10.2/.well-known/acme-challenge/;
  }
}
        " > /var/homeautomation/$CONTAINER_NAME/volumes/nginx/conf.d/homeautomation.conf
        
        # Start Container
        docker-compose up -d
        sleep 5
        
        # Create Cert
        docker run -it --rm --name certbot --net homeautomation --ip 10.10.10.2 \
        -v "/var/homeautomation/nginx/volumes/certbot/www:/var/www/certbot" \
        -v "/var/homeautomation/nginx/volumes/certbot/conf:/etc/letsencrypt" \
        certbot/certbot:arm64v8-latest certonly -n --standalone \
        -d $EXTERNAL_DOMAIN \
        -d portainer.$EXTERNAL_DOMAIN \
        -d pihole.$EXTERNAL_DOMAIN \
        -d vpn.$EXTERNAL_DOMAIN \
        -d bitwarden.$EXTERNAL_DOMAIN \
        -d nodered.$EXTERNAL_DOMAIN \
        -d grafana.$EXTERNAL_DOMAIN \
        -d unifi.$EXTERNAL_DOMAIN \
        -d database.$EXTERNAL_DOMAIN \
        -m $EMAIL --agree-tos
        
        
        # renew Cert
        echo "#!/bin/bash

docker run -it --rm --name certbot --net homeautomation --ip 10.10.10.2 \
-v \"/var/homeautomation/nginx/volumes/certbot/www:/var/www/certbot\" \
-v \"/var/homeautomation/nginx/volumes/certbot/conf:/etc/letsencrypt\" \
        certbot/certbot:arm64v8-latest renew" > /var/homeautomation/$CONTAINER_NAME/renew_cert.sh
        
        chmod +x /var/homeautomation/$CONTAINER_NAME/renew_cert.sh
        
        
        # Add Script renewal to Chronjob
        # https://stackoverflow.com/questions/878600/how-to-create-a-cron-job-using-bash-automatically-without-the-interactive-editor
        # https://crontab.guru
        croncmd="/var/homeautomation/$CONTAINER_NAME/renew_cert.sh"
        cronjob="0 */1 * * * $croncmd"
        
        ( crontab -l | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
        
        # Create real Config
        echo "#Complete Nginx Docker reverse proxy config file
server {
  listen 80;
  listen [::]:80;
  server_name localhost;

  location / {
    root /usr/share/nginx/html;
    index index.html index.htm;
  }

  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }
}

###   Certbot    ###

server {
  listen 80;
  server_name *.$EXTERNAL_DOMAIN $EXTERNAL_DOMAIN;
  location /.well-known/acme-challenge/ {
    proxy_pass http://10.10.10.2/.well-known/acme-challenge/;
  }
}

###   SSL redirection    ###

server {
  listen 80;
  server_name ~^(?<name>.+)\.home$;
  return 301 https://\$name.$EXTERNAL_DOMAIN$request_uri;
}

###   Portainer    ###

server {
  listen 443 ssl;
  deny $FIXED_IP_GW;
  server_name portainer.$EXTERNAL_DOMAIN;
  location / {
    proxy_pass http://10.10.20.1:9000;
  }
  #These header fields are required if your application is using Websockets
  proxy_set_header Upgrade $http_upgrade;

  #These header fields are required if your application is using Websockets    
  proxy_set_header Connection "upgrade";
  ssl_certificate /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/cert.pem;
  ssl_certificate_key /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/privkey.pem;
}

###   Pihole    ###

server {
  listen 443 ssl;
  allow  192.168.0.0/16;
  allow  10.0.0.0/8;
  allow  172.16.0.0/12;
  deny   all;
  server_name pihole.$EXTERNAL_DOMAIN;
  location / {
    proxy_pass http://10.10.30.1;
  }
  #These header fields are required if your application is using Websockets
  proxy_set_header Upgrade $http_upgrade;

  #These header fields are required if your application is using Websockets    
  proxy_set_header Connection "upgrade";
  ssl_certificate /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/cert.pem;
  ssl_certificate_key /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/privkey.pem;
}

###   VPN GUI    ###

server {
  listen 443 ssl;
  allow  192.168.0.0/16;
  allow  10.0.0.0/8;
  allow  172.16.0.0/12;
  deny   all;
  server_name vpn.$EXTERNAL_DOMAIN;
  location / {
    proxy_pass http://10.10.40.1:51821;
  }
  #These header fields are required if your application is using Websockets
  proxy_set_header Upgrade $http_upgrade;

  #These header fields are required if your application is using Websockets    
  proxy_set_header Connection "upgrade";
  ssl_certificate /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/cert.pem;
  ssl_certificate_key /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/privkey.pem;
}

###   Bitwarden    ###

server {
  listen 443 ssl;
  server_name bitwarden.$EXTERNAL_DOMAIN;
  location / {
    proxy_pass http://10.10.50.1;
  }
  #These header fields are required if your application is using Websockets
  proxy_set_header Upgrade $http_upgrade;

  #These header fields are required if your application is using Websockets    
  proxy_set_header Connection "upgrade";
  ssl_certificate /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/cert.pem;
  ssl_certificate_key /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/privkey.pem;
}

###   Nodered    ###

server {
  listen 443 ssl;
  allow  192.168.0.0/16;
  allow  10.0.0.0/8;
  allow  172.16.0.0/12;
  deny   all;
  server_name nodered.$EXTERNAL_DOMAIN;
  location / {
    proxy_pass http://10.10.60.1:1880;
  }
  #These header fields are required if your application is using Websockets
  proxy_set_header Upgrade $http_upgrade;

  #These header fields are required if your application is using Websockets    
  proxy_set_header Connection "upgrade";
  ssl_certificate /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/cert.pem;
  ssl_certificate_key /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/privkey.pem;
}

###   Database    ###

server {
  listen 443 ssl;
  allow  192.168.0.0/16;
  allow  10.0.0.0/8;
  allow  172.16.0.0/12;
  deny   all;
  server_name database.$EXTERNAL_DOMAIN;
  location / {
    proxy_pass http://10.10.70.2:8080;
  }
  #These header fields are required if your application is using Websockets
  proxy_set_header Upgrade $http_upgrade;

  #These header fields are required if your application is using Websockets    
  proxy_set_header Connection "upgrade";
  ssl_certificate /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/cert.pem;
  ssl_certificate_key /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/privkey.pem;
}

###   Grafana    ###

server {
  listen 443 ssl;
  allow  192.168.0.0/16;
  allow  10.0.0.0/8;
  allow  172.16.0.0/12;
  deny   all;
  server_name grafana.$EXTERNAL_DOMAIN;
  location / {
    proxy_pass http://10.10.80.1:3000;
  }
  #These header fields are required if your application is using Websockets
  proxy_set_header Upgrade $http_upgrade;

  #These header fields are required if your application is using Websockets    
  proxy_set_header Connection "upgrade";
  ssl_certificate /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/cert.pem;
  ssl_certificate_key /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/privkey.pem;
}

###   Unifi    ###

server {
  listen 443 ssl;
  allow  192.168.0.0/16;
  allow  10.0.0.0/8;
  allow  172.16.0.0/12;
  deny   all;
  server_name unifi.$EXTERNAL_DOMAIN;
  location / {
    proxy_pass https://10.10.90.1:8443;
  }
  #These header fields are required if your application is using Websockets
  proxy_set_header Upgrade $http_upgrade;

  #These header fields are required if your application is using Websockets    
  proxy_set_header Connection "upgrade";
  ssl_certificate /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/cert.pem;
  ssl_certificate_key /etc/nginx/ssl/live/$EXTERNAL_DOMAIN/privkey.pem;
}

        " > /var/homeautomation/$CONTAINER_NAME/volumes/nginx/conf.d/homeautomation.conf
        
        # Restart nginx
        docker restart $CONTAINER_NAME
        
    fi
    
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