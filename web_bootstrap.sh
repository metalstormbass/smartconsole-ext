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
until sudo git clone https://github.com/CheckPointSW/smart-console-extensions.git;do
    sleep 1
done

# Start Docker
sudo service nginx stop
sudo docker run --rm -d -p 3000:3000 bkimminich/juice-shop

# Gather IP address

ip_address=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Modify Nginx Config to allow access to Juice Store
sudo touch /etc/nginx/conf.d/juice.conf

sudo chmod a+w /etc/nginx/conf.d/juice.conf

sudo cat <<EOT >> /etc/nginx/conf.d/juice.conf
server {
  listen 80;
  listen [::]:80;

  server_name $ip_address;

  location / {
      proxy_pass http://localhost:3000/;
  }
}
EOT

sudo service nginx restart
sleep 2
sudo nginx -s reload

