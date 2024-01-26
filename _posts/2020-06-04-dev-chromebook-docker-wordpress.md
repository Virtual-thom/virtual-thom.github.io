---
layout: post
title: On dev un site wordpress sur chromebook (docker sur linux béta de chromebook)
date: 2020-06-04 09:00
author: Virtual Thom
comments: true
categories: [docker, docker-compose, chromebook, linux, wordpress]
---
## Activer linux béta sur ChromeOS
Dans ma version de ChromeOS, il faut aller dans Paramètres et activer "Linux Béta"
![dev_chromebook_docker_wordpress_activelinux.png](/wp-content/uploads/dev_chromebook_docker_wordpress_activelinux.png)
<!--more-->
## Installer Docker
Lancer le "Terminal" et suivre les instructions sur [le site officiel](https://docs.docker.com/engine/install/debian/).  
En quelques lignes sur ma version, ça s'apparente à une debian stretch (pour savoir quel type d'os `uname -a` et `lsb_release -cs` :  
```shell
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io   
```
## Installer docker-compose
[site officiel](https://docs.docker.com/compose/install/)
```shell
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
## un petit wordpress sur chromebook
[https://docs.docker.com/compose/wordpress/](https://docs.docker.com/compose/wordpress/)  
```shell
mkdir monsitewp
cd monsitewp
vi docker-compose.yml
```
```yml
version: '3.3'

services:
   db:
     image: mysql:5.7
     volumes:
       - db_data:/var/lib/mysql
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: somewordpress
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: wordpress

   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     ports:
       - "8000:80"
     restart: always
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: wordpress
       WORDPRESS_DB_PASSWORD: wordpress
       WORDPRESS_DB_NAME: wordpress
volumes:
    db_data: {}
```
```shell
docker-compose up -d
```
# comment accéder au wordpress du container docker depuis son chromebook
Le linux béta est probablement déjà lui-même un container ou une VM. Il a son propre nom. Chez moi : `penguin.termina.linux.test`  
Il ne reste plus qu'à se rendre sur la page d'init du wordpress : http://penguin.termina.linux.test:8000/wp-admin/  
![dev_chromebook_docker_wordpress_address.png](/wp-content/uploads/dev_chromebook_docker_wordpress_address.png)
