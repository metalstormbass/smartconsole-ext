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

# Gather IP address

ip_address=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Modify Nginx Config to allow access to Juice Store
rm /etc/nginx/sites-enabled/default/index.html
cp /smart-console-extensions/examples/helloworld/css /etc/nginx/sites-enabled/default/
cp /smart-console-extensions/examples/helloworld/js /etc/nginx/sites-enabled/default/
cp /smart-console-extensions/examples/helloworld/extension.json /etc/nginx/sites-enabled/default/extension.json
cp /smart-console-extensions/examples/helloworld/index.html /etc/nginx/sites-enabled/default/index.html

sudo service nginx restart
sleep 2
sudo nginx -s reload

