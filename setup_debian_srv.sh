#!/bin/bash

# Step 1: Installing Sudo
echo -e "\e[32m1 / Installing Sudo\e[0m"
su -
apt-get update -y
apt-get upgrade -y
apt install sudo
usermod -aG $USER
sudo visudo

# Step 2: Installing Vim
echo -e "\n\e[32m2 / Installing Vim\e[0m"
sudo apt install vim -y
sudo apt install make -y

# Step 3: Installing and Configuring SSH
echo -e "\n\e[32m3 / Installing and Configuring SSH (Secure Shell Host)\e[0m"
sudo apt install openssh-server
sudo systemctl status ssh
sudo vim /etc/ssh/sshd_config
sudo grep '#Port 22' /etc/ssh/sshd_config && sudo sed -i 's/#Port 22/Port 2233/' /etc/ssh/sshd_config
sudo grep Port /etc/ssh/sshd_config
sudo service ssh restart

# Step 4: Installing Docker and Docker Compose
echo -e "\n\e[32m6 / Installing Docker and Docker Compose\e[0m"
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo docker --version
sudo usermod -aG docker $USER
sudo apt install docker-compose

# Step 5 : Installing required packages
sudo apt update
sudo apt install jq
sudo apt update
sudo apt install python3
sudo apt update

# Instructions
echo -e "\n\e[36m--- Instructions ---\e[0m"
echo "1. Cliquez sur 'Avancé' et sélectionnez 'Transfert de ports'."
echo "2. Redémarrez le service SSH avec la commande 'sudo systemctl restart ssh'."
echo "3. Vérifiez l'état du service SSH avec 'sudo service ssh status'."
echo "4. Utilisez un terminal pour vous connecter via SSH avec 'ssh your_username@127.0.0.1 -p 2233'."