---
layout: post
title: Docker introduction aux conteneurs 
date: 2020-12-05 09:03
author: Virtual Thom
categories: [docker, conteneurs]
---
Quatre ans après ce billet, quelques petites modifications étaient nécessaires à mon sens. Autant, certaines techno' tombent dans les oubliettes rapidement (4 ans c'est long en informatique) autant Docker n'a fait que prendre du poids.  
Personnellement, je n'utilise plus que ça pour maintenir et déployer mes applications. Et en plus, ça fonctionne très bien sur mon RPI4.
<!--more-->

# Comprendre et Exploiter Docker

La virtualisation des infrastructures est omniprésente. Les besoins et les méthodes de travail évoluant, les conteneurs ont pris de plus en plus d'importance.

Docker permet aux développeurs de ne plus se soucier de la partie système. Beaucoup plus simple d'utilisation (quelques commandes à connaître à peine) qu'un Ansible, Chef ou Puppet, les dev n'auront qu'à maintenir leurs infrastructures "as code" (IaC) et à déployer leur images : le Dockerfile pour la construction de l'image, le docker-compose.yml pour le déploiement de l'application en conteneurs.

Par exemple, Google exécute environ 3300 conteneurs à la seconde ! (vrai en 2016) 

> Everything at Google, from Search to Gmail, is packaged and run in a Linux container. Each week we launch more than 2 billion container instances 

## Introduction à Docker

Notez que la notion de conteneur n'est pas toute jeune (voir les zones Solaris par exemple, ou namespace + cgroups linux pour isoler) mais, pour moi, la grande force de Docker est sa facilité d'utilisation et une documentation en ligne vraiment riche en exemples et explications.

J'aime bien cette conversation qui illustre bien le changement des relations entre Dev (Build) et Ops (Run) :

Avant : 

 * Dev : Hey, tiens, voilà mon application (mon script, mon service ou autre).
 * Ops : Rolala, il faut que je provisionne une VM, que j'installe toutes les dépendances, que je maintienne encore un nouveau host, que les DBA doivent encore monter une instance, etc. 
 * Ops 3 jours plus tard : Ca ne fonctionne pas ton application
 * Dev : Hey, ça n'est pas mon problème, ça fonctionne chez moi. Ca doit être ton environnement qui est en cause
 * Ops : Allez que je cherche pendant 3 jours et que la version de telle ou telle librairie n'était pas la bonne. PepeHands

Avec une infrastructure as code :

 * Dev : Hey, tiens, voilà mon code qui permet de déployer l'infrastructure et mon application.
 * Ops : Ok, super, je n'ai qu'à appuyer sur un bouton. Oh ça fonctionne !

L'Ops n'aura plus qu'à gérer la partie "réseau", routage, et autres TLS avec le reverse proxy [Traefik](https://doc.traefik.io/traefik/), la partie sauvegarde et réplication et basta. (partie qu'il aurait, de toutes manières, eu à gérer par ailleurs)

Le plus facile pour appréhender Docker est de comprendre la différence entre une machine virtuelle et un conteneur.

### [Différences entre les VM's et les Conteneurs](https://blog.netapp.com/blogs/containers-vs-vms/)

VMs

![what-is-docker-diagram](https://www.docker.com/sites/default/files/what-is-docker-diagram.png "what-is-docker-diagram")

Conteneurs

![what-is-vm-diagram](https://www.docker.com/sites/default/files/what-is-vm-diagram.png "what-is-vm-diagram")

Les machines virtuelles ont leur propre système d'exploitation et ressources allouées (CPU, mémoire, stockage, etc.) C'est un avantage car on a ce que l'on paye (ressources réservées). Mais c'est aussi un inconvéniant : d'une part, la limite de ressources à allouer est vite atteinte, et, d'autre part, les VM's en exécution sont bien souvent sous-exploitées (gaspillage). 

Les conteneurs Docker, eux, se basent sur le système d'exploitation du host (noyau linux > à 3.10). Avec Docker, on peut lancer des milliers d'applications hétérogènes (serveur web, serveur d'application, big data, etc.) sur la même machine ; et cela, sans la complexité ni la lourde charge d'un hyperviseur (comme par exemple un gros vCenter pour VMWare).

Un autre avantage des conteneurs : ils garantissent que le code qui a été écrit et testé directement chez les Dev' sera exécuté de la même manière une fois déployé ailleurs. Que ça soit sur le cloud, sur des VM's ou sur une infrastructure complètement différente, l'application dispose déjà dans son conteneur des librairies dont elle a besoin.

Une autre différence de taille (si je puis dire) : le poids des images. Contrairement aux VMs qui embarquent le SE et qui pèsent plusieurs dizaines de Giga Octets, les images sont très légères et leur poids dépend des librairies qui font tourner l'application (en général quelques centaines de Méga Octets)

Les PCA et PRA (Plan de Continuité d'Activité ou Plan de Reprise d'Activité) deviendraient presque un jeu d'enfant (réplication et déploiement facilités)

**Exemple pour récupérer une image de serveur web nginx** : je vous laisse juger de la simplicité des commandes

```
# pull de l'image depuis Docker Hub
$ docker pull nginx
Using default tag: latest
latest: Pulling from library/nginx
...
Digest: sha256:46a1b05e9ded54272e11b06e13727371a65e2ef8a87f9fb447c64e0607b90340
Status: Downloaded newer image for nginx:latest

# liste des images locales
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nginx               latest              3edcc5de5a79        3 days ago          182.8 MB
```

### Produits Docker

[Docker Engine](https://www.docker.com/products/docker-engine) est le moteur qui tourne sous Linux et permet la gestion/exécution des conteneurs.

[Docker Machine](https://www.docker.com/products/docker-machine) permet de configurer et d'exécuter Docker Engine sur une machine virtuelle linux très légère. Indispensable sous Windows.

[Docker Compose](https://www.docker.com/products/docker-compose) permet de définir la configuration d'un ou plusieurs conteneurs en un seul fichier puis, de les exécuter en une seule commande. On pourrait même dire, que c'est la configuration de l'application complète qui définit les liens entre les conteneurs, les ports à utiliser, les volumes, etc.

[Docker Hub](https://www.docker.com/products/docker-hub) permet de publier sur le cloud (privé ou public) vos conteneurs versionnés. 

D'autres produits existent mais font l'objet d'une utilisation plus poussée (voir [Pour aller plus loin](#pour-aller-plus-loin))

### [Principe de fonctionnement](https://docs.docker.com/engine/understanding-docker/)

#### Les images

Elles sont construites comme une succession de couches avec pour base un système d'exploitation, une distribution type debian, ubuntu, ou alpine par exemple.

Toutes les couches (exécution, dépendances librairies, ajout de fichier, variables d'environnement) peuvent être décrites comme des instructions dans un fichier `Dockerfile` qu'on peut utiliser comme template pour construire notre image.

Autre possibilité pour construire votre image : exécutez une image de distribution de base (un conteneur donc), installez vos librairies et votre application puis perpétrez votre conteneur en image [commit](https://docs.docker.com/engine/reference/commandline/commit/)

Avantages de cette construction en couches : si vous avez deux images basées sur deux ubuntu par exemple, la couche "ubuntu" ne prendra qu'une fois la place sur disque.

#### Le conteneur

C'est l'image exécutée avec `docker run`. Pour que le conteneur puisse "vivre" et l'image étant en lecture seule, des couches systèmes supplémentaires sont allouées comme UnionFS en écriture pour le filesystem ou une interface réseau par exemple.

A noter : le conteneur se basant sur l'image, toutes les modifications qu'on effectuera dans le conteneur seront "perdues" à la prochaine exécution (à moins de [commit](https://docs.docker.com/engine/reference/commandline/commit/) le conteneur en image)

D'où la nécessité d'utiliser les volumes.

#### Les volumes

Indispensable pour la persistance des données, on peut monter des volumes accessibles dans les conteneurs. Faciles à sauvegarder et à restaurer.

[Plus de détails sur la data](https://docs.docker.com/engine/userguide/containers/dockervolumes/)

## Exemple d'utilisation avec Docker Compose

[Getting started](https://docs.docker.com/compose/gettingstarted/)

Et si on exécutait un wordpress ? Rien de plus simple :

Créons un fichier wordpress-compose.yml 

```
wordpress:
  image: wordpress
  links:
    - db:mysql
  ports:
    - 8080:80

db:
  image: mariadb
  environment:
    MYSQL_ROOT_PASSWORD: example
```

Lançons maintenant ces deux conteneurs. Vous allez voir, c'est très très dur ! ou pas, en fait, docker-compose s'occupe de tout. 

Soit les images définies existent en local, soit il va les chercher sur Docker Hub. On peut aussi définir une commande build avec son propre Dockerfile pour construire l'image si elle n'existe pas. Par exemple, l'image `wordpress` ci-dessus est issue du [Dockerfile suivant](https://github.com/docker-library/wordpress/blob/618490d4bdff6c5774b84b717979bfe3d6ba8ad1/apache/Dockerfile#L5-L9)

Il créé les dépendances, les ouvertures de ports, les variables d'environnement, etc. 

Petit bonus, lorsque Docker Compose redémarre les services, s'il trouve des conteneurs déjà existants, et s'il n'y a pas d'update à faire, il reprend les anciens. Pour voir tous les conteneurs même ceux arrêtés : `docker ps -a`

```
$ docker-compose -f wordpress-compose.yml up
Pulling db (mariadb:latest)...
latest: Pulling from library/mariadb
Digest: sha256:648500ff8eb35b9967a5e77735d0f66fefb8a48377a65312a375a944cdcfda0a
Status: Downloaded newer image for mariadb:latest
Creating compose_db_1
Pulling wordpress (wordpress:latest)...
latest: Pulling from library/wordpress
Digest: sha256:282b474f38ef7c79b50ac45d7430a7c1851db54ccdd134472ad200fab405587e
Status: Downloaded newer image for wordpress:latest
Creating compose_wordpress_1
Attaching to compose_db_1, compose_wordpress_1
db_1        | Initializing database
...

```

![wordpress accueil](https://virtual-thom.github.io/assets/img/wordpress_intro.jpg "wordpress accueil")

### En aparté : IaC, Sauvegarde, déploiement
Les deux fichiers principaux à maintenir (versionner, gardienner avec git par ex.) sont le [Dockerfile le builder infrastructure](https://docs.docker.com/engine/reference/builder/) et le [docker-compose.yml pour la partie déploiement de l'application](https://docs.docker.com/compose/compose-file/).  
Le déploiement se résumera à exécuter `docker-compose up`.

Sinon, on peut aussi sauvegarder les images :

```
$ docker save -o monImageNginx.tar nginx
$ ls -lh
-rw-r--r-- 1 thoma 197609 182M mai    7 22:12 monImageNginx.tar

# la compression fonctionne très bien sur les conteneurs
$ zip monImageNginx.tar.zip monImageNginx.tar
  adding: monImageNginx.tar (172 bytes security) (deflated 63%)
$ ls -lh
-rw-r--r-- 1 thoma 197609  69M mai    7 22:14 monImageNginx.tar.zip

``` 

Il n'y a plus qu'à transférer la sauvegarde et à la recharger sur n'importe quelle plateforme :

```
$ docker load -i monImageNginx.tar
```

On peut aussi [pousser](https://docs.docker.com/engine/reference/commandline/push/) son image sur le cloud (Docker Hub) en s'authentifiant sur son [Docker registry](https://docs.docker.com/engine/reference/commandline/login/)

Vous voulez le meilleur ? toutes les modifications apportées à l'image de base constituent des couches (layers). Par conséquent, les transferts de vos applications conteneurs ne prennent en charge que les deltas des couches manquantes ou modifiées !!

## Pour aller plus loin

[Documentation Docker](https://docs.docker.com/) : comment installer, utiliser les commandes en détails etc.

[Doker Swarm](https://www.docker.com/products/docker-swarm) : Docker en mode cluster

[Kubernetes](http://kubernetes.io/) : Automatisation des opérations d'exploitation de conteneurs à travers le cloud et clusters de machines

et d'autres Docker Cloud, Datacenter, Kinematic etc. voir [tous les produits](https://www.docker.com/products/overview)

[Openshift](https://www.openshift.com/) de RedHat. Plateforme d'hébergement basée sur Docker et Kubernetes qui propsent différents plans (dont un gratuit) pour développer et exécuter vos applications sur le cloud

J'adore les tutoriels Grafikart et c'est en français :

 * [Présentation de Docker](https://www.grafikart.fr/tutoriels/docker/docker-intro-634)
 * [Environnement de développement basé sur Docker](https://www.grafikart.fr/tutoriels/docker/docker-stack-web-635)

[Superbe vidéo pour bien comprendre les conteneurs. Microsoft fait de gros efforts en ce moment ! Hyper-v et Docker](https://msdn.microsoft.com/fr-fr/virtualization/windowscontainers/about/about_overview#vidéo-de-présentation)
