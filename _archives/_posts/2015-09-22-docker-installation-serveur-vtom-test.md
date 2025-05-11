---
layout: post
title: Docker première approche - déploiement serveur VTOM test
date: 2015-09-21 22:21
author: Virtual Thom
categories: [docker, unix, git, installation serveur VTOM, VTOM]
---
## But et explication Docker
Pour faire simple, Docker va me permettre de déployer un serveur VTOM de test pour mes scripts.

(en fait, j'utilisais docker sans le savoir quand je déployais mes applications via Openshift de RedHat)

Docker se base sur une image qui va être montée en r/o (dans mon cas une debian) grâce à la couche OS de la machine qui fait tourner Docker Engine.

Puis, lors qu'on RUN l'image, il monte une surcouche UnionFS en r/w.
Le tout, monté, s'appelle un conteneur.

En fait, la notion de conteneur semble exister depuis pas mal de temps. Mais Docker arrive à banaliser les opérations de création, déploiement, et de gestion. (pas beaucoup de lignes de commandes, très faciles à appréhender et utilisables par tous)

Le conteneur n'est autre qu'un genre d'OS avec l'application qu'on aura déployée dessus.

On est bien d'accord que ça n'est pas réellement un OS puisqu'il s'appuie sur l'OS du host et qu'il ne fait que charger les librairies/binaires et l'application qu'on aura éventuellement configurée ; tout ça grâce au Docker Engine.

[Illustration très claire de ce qu'est Docker](https://www.docker.com/whatisdocker)

Lorsqu'on quittera le conteneur, tout le travail effectué aura disparu. 

Plusieurs solutions si on veut garder les modifications :

* si c'est propre à l'OS ou de la configuration applicative, on va valider notre conteneur (commit) pour en faire une image
* si c'est plus pour sauvegarder et utiliser des fichiers, on va créer un dossier partagé entre le host et l'image. On peut aussi partager des volumes entre les conteneurs avec les [Data Volumes](https://docs.docker.com/userguide/dockervolumes)

Je fais ça pour éviter d'avoir à ré-installer à la main à chaque fois un environenement de test avec la licence qui expire au bout de 30 jours.
On pourra aussi scripter le déploiement d'une licence particulière ou d'une base VTOM (ou vtimport pourquoi pas).

Si vous voulez une intro en français de Docker, voici une vidéo qui dégrossit bien le concept :
[video Grafikart](http://www.grafikart.fr/tutoriels/docker/docker-intro-634)

Autre lien vers un post de mon ami Werner BEROUX qui bosse chez Google : [Kubernetes / Docker](http://beroux.com/english/articles/kubernetes/)

## Mode opératoire

### First things firt - Installation de Docker
[Installation Docker](https://docs.docker.com/installation)

En gros, soit on installe Docker engine sur un linux, soit on installe [Docker ToolBox](https://www.docker.com/toolbox) sur Windows. Cela dit, il ne fait qu'installer Virtualbox avec une mini VM Linux avec Docker installé dessus.

### Clone de mon repo Docker_VTOM dans votre répertoire 
`git clone https://github.com/virtual-thom/Docker_VTOM.git`

### Ajout de vos sources d'installation SERVEUR + CLIENT VTOM dans le répertoire SES

Copier simplement les sources VT-SES-&lt;votre OS, votre version&gt; et VT-CS-&lt;votre OS, votre version&gt; depuis votre CD-ROM VTOM vers le répertoire SES/ clôné.
Au besoin, modifier le script SES/dockerinit.ksh 

### Paramétrer le fichier Dockerfile ainsi que le install_vtom.ini comme on le souhaite

J'ai mis des options et des paths par défaut d'installation de VTOM. Il suffit d'ouvrir ces deux fichiers Dockerfile et install_vtom.ini pour comprendre.

Dockerfile

```
# On se base sur l'image de la dernière debian
FROM debian:latest 

MAINTAINER Virtual Thom <virtual-thom@protonmail.com>

# L'installation de VTOM nécessite ksh
RUN apt-get update
RUN apt-get install ksh

# On créé le répertoire d'installation de VTOM
RUN mkdir /opt/vtom 
# On créé le user d'administration vtom
RUN useradd -d /opt/vtom -s /usr/bin/ksh vtom
RUN chown vtom /opt/vtom

# On prépare les répertoires pour acceuilir les sources d'installation de VTOM
RUN mkdir /sources
RUN mkdir /sources/SES

# On copie les fichiers du repo dans SES/
COPY SES /sources/SES/

# on supprime les ^M si on utilise docker depuis windows
RUN sed -i 's/\r$//g' /sources/SES/install_vtom.ini
RUN sed -i 's/\r$//g' /sources/SES/dockerinit.ksh
RUN sed -i 's/\r$//g' /sources/SES/install_vtom

# A chaque lancement d'image, on commence le conteneur avec le script d'installation VTOM
ENTRYPOINT ["/bin/bash"]
CMD ["-c","/sources/SES/dockerinit.ksh ;/bin/bash"]

```

### Build de l'image

`docker build /path/du/gitclone`

### Run de l'image

* on récupère l'ID de l'image créée 

`docker images`

(si on veut conserver l'image, on fera un `docker tag IDimage <nouveau nom d'image>`)

* on lance l'image (en mode tty)

`docker run -it IDimage`



Si vous voulez plus d'informations sur le Dockerfile ou autre n'hésitez pas.
