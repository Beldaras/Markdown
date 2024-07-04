#! /bin/bash

# UFW installation & configuration

sudo apt install ufw
sudo ufw allow OpenSSH from 192.168.1.0/24
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 3306
sudo ufw allow 4567
sudo ufw allow 4568
sudo ufw allow 4444

sudo ufw enable -y
sudo ufw status
