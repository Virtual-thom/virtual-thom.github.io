---
layout: post
title: Balance ton Paille !
date: 2019-11-01 17:34
author: Virtual Thom
comments: true
categories: [rpi, raspberry pi, rpi 4, docker, devOps, nodejs, parcel]
---
# Edit 2021
Je laisse l'article mais pas mal de trucs sont outdated.  
J'ai vraiment l'impression que beaucoup de logiciels sont portés sur l'architecture arm depuis que NVIDIA et Apple en ont parlé.  
Du coup, c'est maintenant ultra simple d'installer Visual Studio Code et Docker sur son RPI4 avec l'OS de base fourni par [Raspberrypi.org](https://www.raspberrypi.org/software/operating-systems/).    

# RPI4 is Here !
Petit retour d'expérience sur mon nouveau pc, le raspberry pi 4. 
## Pourquoi une framboise à la maison ?!
* un cloud personnel, aussi bien compute que file, et même, pourquoi pas, un serveur web perso en activant le domaine gratuit free (soit par la box "Nom de domaine", soit par le compte free)
* consommation ridicule (bien pour la planète et mon portefeuille ~ 5&euro; par an)
* une interface avec le monde (GPIO, ces petites broches d'entrée/sortie qui nous permettent de faire de la domotique, des stations météos, etc.)
* je joue de moins en moins sur ma grosse machine, il n'est pas impossible qu'il devienne mon pc principal avec une GUI

## Les galères du début
Tout dépend de votre utilisation, mais pour ma part, "ma vie a changé" depuis que je suis passé de la distribution [Raspbian](https://www.raspberrypi.org/downloads/raspbian/) à l'[Ubuntu](https://ubuntu.com/download/iot/raspberry-pi).
Entendez-moi bien, la Raspbian est super stable, elle fait le taff à merveille pour un pc standard et du dev standard 99% du temps. Mais alors quand il s'agit de monter un docker, la moitié des images du Hub ne fonctionnent pas, certains paquets apt non plus (style mongodb)

Bref, tout ça pour dire, vive Ubuntu Server !

<!--more-->

Pour passer en arm64, `rpi-update` et rajouter `arm_64bit=1` dans /boot/config.txt :

```
sudo rpi-update
sudo vi /boot/config.txt
...
[all]
arm_64bit=1
...
```
 
Install vscode
[https://github.com/futurejones/code-oss-aarch64/blob/master/raspbian-buster-pi4/README.md](https://github.com/futurejones/code-oss-aarch64/blob/master/raspbian-buster-pi4/README.md)
```
# https://packagecloud.io/swift-arm/vscode, c'est dispo' pour buster maintenant
curl -s https://packagecloud.io/install/repositories/swift-arm/vscode/script.deb.sh | sudo bash
sudo apt-get install code-oss
```

Install Docker-ce
https://docs.docker.com/install/linux/docker-ce/debian/
https://download.docker.com/linux/debian/dists/buster/stable/
```
sudo apt update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
curl -fsSL https://download.docker.com/linux/raspbian/gpg | sudo apt-key add -
echo "deb https://download.docker.com/linux/raspbian/ buster stable" > /etc/apt/sources.list.d/docker.list
# ou dans /etc/apt/sources.list, rajouter la ligne deb [arch=arm64] https://download.docker.com/linux/raspbian/ buster stable
sudo apt update
sudo apt install docker-ce docker-compose docker-ce-cli containerd.io
```
le seul truc c'est que le package aufs-dkms essaie de s'installer en recommandé et plante sur le RPI. Mais ça n'affecte pas l'installation de Docker-CE. (à voir pour `sudo apt install --no-install-recommends docker-ce`, pas testé)

Je ferme la parenthèse pour Raspbian :)

&gt;

# Premiers pas
Pour info', j'ai la version 4Go RAM du rpi4, avec un boitier ventilé (tout petit ventilo suffit, je tourne à 52°C en charge ~)
## Install Ubuntu Server
Toutes les instructions sont là en fait : [Ubuntu](https://ubuntu.com/download/iot/raspberry-pi).
### Petit bug
[bug (reconnu, officiel pour les 4Go RAM)](https://bugs.launchpad.net/ubuntu/+source/linux-raspi2/+bug/1848703) que j'ai rencontré : le clavier ne fonctionne pas (tout l'usb en fait)

Un peu embêtant sur une fresh install, j'en conviens. Premier truc à faire pour pallier (en attendant le patch sur l'image 19.10) :
* soit, temporairement, rajouter une limite à la RAM (fonctionne j'ai testé). Il suffit de monter sa carte SD sur un autre pc, et de modifier un des fichiers config ex. `/boot/usercfg.txt`
```
total_mem=3072
```
* soit, se passer dans un premier temps, des sorties usb. Il faut dans ce cas, connecter le rpi en ethernet sur sa box. Le DHCP fonctionne (pour moi en tous cas, il a eu une IP en auto'. Il suffit de se rendre sur l'admin de sa box et de regarder l'IP attribuée [http://mafreebox.freebox.fr/#Fbx.os.app.settings.Dhcp](http://mafreebox.freebox.fr/#Fbx.os.app.settings.Dhcp)). Et se connecter en ssh (via Putty par ex. sur windows ou depuis un pc en linux)
```
ssh ubuntu@192.168.1.17 # ou l'ip attribuée par le DHCP de la box # password: ubuntu
```
* puis passer le patch (ne faites cette opération que si l'image n'a pas encore été patch ! pour info, ce billet date du 01.11.18)
```sh
# il se peut que le paquet ait évolué, se rendre sur  https://people.canonical.com/~hwang4/rpiv2 pour lister les .deb
wget https://people.canonical.com/~hwang4/rpiv2/arm64/linux-image-5.3.0-1008-raspi2_5.3.0-1008.9+newupdate_arm64.deb
wget https://people.canonical.com/~hwang4/rpiv2/arm64/linux-modules-5.3.0-1008-raspi2_5.3.0-1008.9+newupdate_arm64.deb
sudo dpkg -i linux-modules-5.3.0-1008-raspi2_5.3.0-1008.9+newupdate_arm64.deb
sudo dpkg -i linux-image-5.3.0-1008-raspi2_5.3.0-1008.9+newupdate_arm64.deb
sudo reboot
```
ne pas oublier de supprimer la ligne `total_mem=3072` une fois patché.
### First Thing First
* modifier le clavier en français (utile quand on se connecte en direct clavier/hdmi) : 
```sh
sudo dpkg-reconfigure keyboard-configuration
sudo loadkeys fr
```
* wifi : [https://www.linuxbabe.com/ubuntu/connect-to-wi-fi-from-terminal-on-ubuntu-18-04-19-04-with-wpa-supplicant](https://www.linuxbabe.com/ubuntu/connect-to-wi-fi-from-terminal-on-ubuntu-18-04-19-04-with-wpa-supplicant)

Je mets les grandes lignes mais le mieux reste de suivre les instructions du lien ci-dessus
```
sudo apt install wireless-tools
rfkill list # pour débloquer éventuellement le wifi du rpi
iwconfig # gives me
wlan0     IEEE 802.11  ESSID:off/any
          Mode:Managed  Access Point: Not-Associated
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Power Management:on
sudo ip link set wlan0 up
sudo iwlist wlan0 scan | grep ESSID
  ESSID:"Freebox-XXXXXX"
sudo apt install wpasupplicant
wpa_passphrase "Freebox-XXXXXX" "clewifiwpa" | sudo tee /etc/wpa_supplicant.conf
sudo wpa_supplicant -B -c /etc/wpa_supplicant.conf -i wlan0
sudo dhclient wlan0
ip addr show
# wifi au boot
sudo cp /lib/systemd/system/wpa_supplicant.service /etc/systemd/system/wpa_supplicant.service
sudo vi /etc/systemd/system/wpa_supplicant.service
ExecStart=/sbin/wpa_supplicant -u -s -c /etc/wpa_supplicant.conf -i wlan0
#Alias=dbus-fi.w1.wpa_supplicant1.service
sudo systemctl enable wpa_supplicant.service
# dhcp client au boot pour l'interface wifi
sudo vi /etc/systemd/system/dhclient.service
[Unit]
Description= DHCP Client
Before=network.target
After=wpa_supplicant.service

[Service]
Type=simple
ExecStart=/sbin/dhclient wlan0

[Install]
WantedBy=multi-user.target
sudo systemctl enable dhclient.service

# rajout d'un serveur dns 
vi /etc/netplan/01-wifi.yaml
network:
    ethernets:
        wlan0:
            gateway4: 192.168.1.254
            nameservers:
                addresses: [192.168.1.254,8.8.8.8, 8.8.4.4]
            dhcp4: true
            dhcp6: true
    version: 2
sudo netplan apply
```

* mise à jour : il est possible que ça soit fait en auto par la crontab (ça a été mon cas dès que j'ai branché le net). Sinon `sudo apt update && sudo apt upgrade`
* sécurité :
  * changer son password ubuntu (mais normalement c'est demandé lors de la première connexion)
  * accès ssh avec clé uniquement (à noter que ça ne change rien à la connexion en direct sur le rpi) :
    * Créer un couple clé privé/publique avec PuttyGen (avec une passphrase, c'est mieux) ![puttygen](/wp-content/uploads/puttygen.png)
    * copier/coller la clé publique (ssh-rsa xxxxxx) dans `~/.ssh/authorized_keys` (attention ce fichier ne doit pas avoir de droits trop permissif, 600 c'est une valeur sûre)
    * configurer `sudo vi /etc/ssh/sshd_config`
    ```
    #PubkeyAuthentication yes
    PubkeyAuthentication yes
    #PasswordAuthentication yes
    PasswordAuthentication no
    ```
    `sudo /etc/init.d/ssh restart`
    * utiliser la clé privé lors de la connexion ssh `ssh -i chemin/cleprive.ppk ubunbut@192.168.1.17` ou dans les settings de Putty (Connection > SSH > Auth > Browse Private key)
  * installer fail2ban `sudo apt install fail2ban`
* (optionnel) monter le nas freebox. Ca peut être très intéressant pour configurer un repository git perso, stocker des données, etc. :
  * activer le samba ([fusionné](https://www.youtube.com/watch?v=HAiHEQblKeQ)) : [http://mafreebox.freebox.fr/#Fbx.os.app.settings.ShareSamba](http://mafreebox.freebox.fr/#Fbx.os.app.settings.ShareSamba)
 ![freebox_samba.png](/wp-content/uploads/freebox_samba.png)
  * config fstab
  ```sh
  sudo apt install cifs-utils
  sudo mkdir /free
  sudo vi /root/.smbcredentials
  username=celuiquevousavezmisdanslapremiereetape
  password=celuiquevousavezmisdanslapremiereetape
  sudo vi /etc/fstab
  //192.168.1.254/Disque\040dur /free cifs credentials=/root/.smbcredentials,uid=0,gid=0,vers=1.0 0 0
  ```
  * tester avant de reboot 
  ```sh
  sudo mount -a
  ```
  
  c'est vraiment important car une erreur de syntaxe peut bloquer votre boot. Au cas où si ça vous arrive :
  
  ```
  You can repair most such problems on the Pi by rebooting to a root shell.

  Append init=/bin/sh at the end of cmdline.txt and reboot.
  After booting you will be at the prompt in a root shell.
  Your root file system is mounted as readonly now, so remount it as read/write
  mount -n -o remount,rw /
  ```
  
## Installation environnement de Dev
### Quelques paquets prérequis
```sh
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
```
### Nodejs
```sh
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
sudo apt-get install -y nodejs
```
### Docker
```sh
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add 
# la version Ubutun 19.10 Eoan n'existe pas à l'heure où j'écris mais la 19.04 Disco fonctionne chez moi
sudo add-apt-repository \
   "deb https://download.docker.com/linux/ubuntu \
   disco \
   stable"
# vérifier dans /etc/apt/sources.list que la ligne a été ajoutée
sudo apt udpate 
sudo apt install docker-ce
sudo apt install docker-compose
```
### Visual Studio Code Insiders
S'il y a bien un truc qui rox, c'est ça. Et ça ne voulait pas fonctionner avec la Raspbian pour une raison qui m'échappe.

Là, tout fonctionne (répertoire à distance, gestion du git, docker etc) ! On dev à distance sur le rpi depuis un autre poste avec [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/)

config .ssh/config sur votre poste :
```
Host rpi
    User ubuntu
    HostName 192.168.1.17
    IdentityFile d:/cle/rpi_priv
```

Attention, il faut deux choses importantes :
 * le fichier en format PuttyGen .ppk ne fonctionne pas, il faut l'exporter (vraiment mettez une passephrase sur votre clé). Depuis PuttyGen > menu Conversions > Exporter Open SSH key d:/cle/rpi_priv
 * ce fichier (cle_priv) doit être sécurisé et accessbile uniquement à vous (600 en windows c'est : Clique droit > Propriétés > Sécurité > Avancé > Désactiver l'héritage > supprimer tout > ne rajouter que votre utilisateur en control total)
 
# Mon premier projet avec Docker
## Dépôt de partage git sur le NAS de la Freebox

Juste parce que ça peut être sympa d'avoir plusieurs remote (un sur github et un sur le NAS par exemple). Ou si on ne veut pas partager son code en phase de Dev, on le garde en local + NAS de la Box (sans faire de pub, la freebox est vraiment pas mal pour ça, assez rapide et capacité correcte).
```sh
cd /free
sudo mkdir git
cd git
sudo git init --shared --bare monpremierprojet.git
Initialized empty shared Git repository in /free/git/monpremierprojet.git/
```
## init projet (docker pour un paysage varié bdd, front, api, traefik pour le reverse proxy et let's encrypt https)

```sh
cd ~
git clone /free/git/monpremierprojet.git
cd monpremierprojet
# ou sur un projet déjà existant
cd ~/monprojetexistant
git init
git remote add origin /free/git/monpremierprojet.git
```

`vi Dockerfile-alpine-nodejs`
```Dockerfile
FROM alpine:latest
RUN apk add --no-cache npm
```

Le traefik a un point d'entrée (:80). Ma box redirige évidemment le port 80 vers le port 80 de mon rpi.

Le traefik se charge ensuite de rediriger en interne les flux et agit comme un reverse proxy.

`vi docker-compose.yml`
```yml
version: '3'

networks:
  default:
  traefik_proxy:
    external:
      name: traefik_proxy

services:
  traefik:
    image: traefik:v2.0
    command:
      - --providers.docker=true
      - --providers.docker.exposedByDefault=false
      - --entrypoints.web.address=:80
    ports:
      - "8383:80"
    volumes:
      - ./acme.json:/acme.json
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - default
      - traefik_proxy

  front:
    image: node
    volumes:
      - ./front:/app/front
    working_dir: /app/front
    command: npm run dev 
    networks:
      - traefik_proxy
    labels:
      - traefik.docker.network=traefik_proxy
      - traefik.http.services.front.loadbalancer.server.port=1234
      - traefik.enable=true
      - traefik.http.routers.front.rule=Host(`monsiteperso.hd.free.fr`)
    depends_on:
      - api 

  nodebb:
    image: nodebb:thomas
    volumes:
      - ./nodebb:/app/nodebb
    working_dir: /app/nodebb
    command: ./nodebb dev
    networks:
      - traefik_proxy
    labels:
      - traefik.docker.network=traefik_proxy
      - traefik.http.services.nodebb.loadbalancer.server.port=4567
      - traefik.enable=true
      - traefik.http.routers.nodebb.rule=Host(`monsiteperso.hd.free.fr`) && PathPrefix(`/forum`)
    depends_on:
      - mongo 

  api:
    build:
      context: .
      dockerfile: Dockerfile-alpine-nodejs
    image: alpine:nodejs
    volumes:
      - ./api:/app/api
    working_dir: /app/api
    command: npm run start
    networks:
      - traefik_proxy
    labels:
      - traefik.docker.network=traefik_proxy
      - traefik.http.services.api.loadbalancer.server.port=2345
      - traefik.enable=true
      - traefik.http.routers.api.rule=Host(`monsiteperso.hd.free.fr`) && PathPrefix(`/api`)
    depends_on:
      - mongo
  
  apiv2:
    build:
      context: .
      dockerfile: Dockerfile-alpine-nodejs
    image: alpine:nodejs
    volumes:
      - ./apiv2:/app/api
    working_dir: /app/api
    command: npm run start
    networks:
      - traefik_proxy
    labels:
      - traefik.docker.network=traefik_proxy
      - traefik.http.services.apiv2.loadbalancer.server.port=3456
      - traefik.enable=true
      - traefik.http.routers.apiv2.rule=Host(`monsiteperso.hd.free.fr`) && PathPrefix(`/apiv2`)
    depends_on:
      - mongo

  mongo:
    image: mongo 
    networks:
      - traefik_proxy
    labels:
      - traefik.docker.network=traefik_proxy
      - traefik.http.services.mongo.loadbalancer.server.port=27017
    volumes:
      - ./mongod.conf:/etc/mongod.conf
      - ./data/db:/data/db
      - ./data/configdb:/data/configdb

volumes:
  mongo:
    driver: local
  api:
    driver: local
  front:
    driver: local
  nodebb:
    driver: local
```

```
sudo docker-compose up
```

# Pour en faire un pc de bureau
Attention 3,5 Go en plus
`sudo apt-get install lubuntu-desktop`
