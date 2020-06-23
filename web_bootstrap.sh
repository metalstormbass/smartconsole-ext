#!/bin/bash

# Update and download Nginx
until sudo apt-get update && sudo apt-get -y install nginx;do
    sleep 1
done

#Install Git
until sudo apt-get update && sudo apt-get -y install git;do
    sleep 1
done

#Install Git
until sudo git clone $git_addr /home/$name/smart-console-extensions;do
    sleep 1
done

# Gather IP address

ip_address=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Modify Nginx
sudo rm  /etc/nginx/sites-enabled/default
sudo rm /var/www/html/index.html
sudo cp -r /home/$name/smart-console-extensions/examples/ /var/www/html/


#Generate Cert
sudo mkdir /etc/nginx/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=CA/ST=AB/L=Calgary/O=Dis/CN=www.example.com"

#Build Config File
sudo touch /etc/nginx/sites-enabled/smartconsoleEXT
sudo cat <<EOT >> /etc/nginx/sites-enabled/smartconsoleEXT
server {
    server_name _;
    listen       80  default_server;
    return       404;
}


server {
    listen 443 ssl;
    server_name _;
    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;
    root /var/www/html;
}



EOT

sudo nginx -s reload
sudo service nginx restart
sleep 2
