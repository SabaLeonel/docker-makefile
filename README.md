# 💭 DEBIAN INSTALL SERVER  💭
---
## Part 1 | Configuration de l'environnement de développement

Pour configurer un environnement de travail avec SSH (afin d'éviter le décalage de la machine virtuelle), vous pouvez exécuter directement le script → [install_vm.sh](./install_vm.sh). Voici une explication de ses fonctionnalités.

### Étape 1 : Installation de Sudo

```bash
su -
apt-get update -y
apt-get upgrade -y
apt install sudo
usermod -aG $USER
sudo visudo
```

### Étape 2 : Installation de Vim et Make

```bash
sudo apt install vim -y
sudo apt install make -y
```

### Étape 3 : Installation et configuration de SSH

```bash
sudo apt install openssh-server
sudo systemctl status ssh
sudo vim /etc/ssh/sshd_config
sudo grep '#Port 22' /etc/ssh/sshd_config && sudo sed -i 's/#Port 22/Port 2233/' /etc/ssh/sshd_config
sudo grep Port /etc/ssh/sshd_config
sudo service ssh restart
```

### Étape 4 : Installation de Docker et Docker Compose

```bash
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo docker --version
sudo usermod -aG docker $USER
sudo apt install docker-compose
```

### Étape 5 : Installation des paquets requis

```bash
sudo apt update
sudo apt install jq
sudo apt update
sudo apt install python3
sudo apt update
sudo touch .env
```


### Instructions pour VirtualBox

1. Cliquez sur 'Avancé' et sélectionnez 'Transfert de ports'."
2. Redémarrez le service SSH avec la commande 'sudo systemctl restart ssh'."
3. Vérifiez l'état du service SSH avec 'sudo service ssh status'."
4. Utilisez un terminal pour vous connecter via SSH avec 'ssh your_username@127.0.0.1 -p 2233'."
