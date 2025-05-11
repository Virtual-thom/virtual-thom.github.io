---
layout: post
title: Platform.sh premières impressions
date: 2016-05-21 12:53
author: Virtual Thom
categories: [platform.sh, Orange Cloud, developpement, web, PaaS]
---

Avec [platform.sh](https://platform.sh), Orange Cloud for Business nous promet pour nos applications Web :

 * un PaaS performant et sécurisé (datacenters situés en France)
 * jusqu'a 25% d'économies sur les couts de développements et sur le DevOps
 * de permettre aux developpeurs de se concentrer sur le code et non sur la gestion du systeme 
 * de simplifier au maximum les workflow jusqu'à la livraison du projet

A premiere vue, c'est tres orienté Web et comme il y a un free trial de 30 jours, je vais tester ça !

## Comment ça fonctionne ?

Quelques liens vers les [white papers et case studies](https://platform.sh/product/enterprise/docs/) : 

 * [Introduction](https://platform.sh/files/fr/Platform.sh%20-%20Introduction_FR.pdf)
 * [Data Sheet](https://platform.sh/files/en/Platform.sh%20-%20Data%20Sheet.pdf)

Ce qu'on pourrait retenir : 

 * utilise principalement le mécanisme de Git : 
   * permet le versioning
   * permet la livraison entre les différents environnements avec le merging
   * permet aux équipes une meilleure communication et moins de documentation a produire (il suffit de voir les différences entre les différentes versions dans l'outil directement)
 * fonctionne avec des micro-services comme conteneurs linux LXC (un peu comme Docker)
   * il suffit de référencer les services dans des fichiers de configuration (comme mysql, postgres, etc)
 * basiquement, on n'a besoin que de trois fichiers pour initier notre environnement : .platform-app-yaml.html + .platform/services.yaml + .platform/routes.yaml
 * l'ensemble .platform-app-yaml.html + .platform/services.yaml ressemble fortement a ce qu'on pourrait faire avec docker-compose 

Rentrons dans le vif du sujet, et voyons si ça vaut le coup de s'intéresser a platform.sh.

## Exemple : application simple - bonjour

### L'administration des projets sur platform.sh

Je dois avouer que tout est pensé pour simplifier au maximum les actions et les configurations.

Je trouve l'interface plutôt sympathique et tres fonctionnelle.

En 4 clics, j'ai créé mon free trial account, créé mon projet "Demo Dev" avec sa branche "master" et sa branche "n-1" (pour la version n-1 par exemple). Je peux presque commencer a écrire ou déployer mon code.

### Installer platform CLI pour une meilleure gestion des projets et environnements

Mais d'abord, j'installe mon environnement de dev. Je run mon image [Docker Dev](https://github.com/virtual-thom/docker_debian_dev_tools/blob/master/Dockerfile) mais n'importe quel OS avec Git, php et vos outils de dev devrait suffire.

J'installe `platform CLI`

```
# install
curl -sS https://platform.sh/cli/installer | php

# configuration
# et je rentre mes informations de compte pour m'authentifier
platform
...

# Je configure mes clés ssh pour Git et acces ssh
platform ssh-keys
Your SSH keys are:
+-------+----------------------------+----------------------------------+
| ID    | Title                      | Fingerprint                      |
+-------+----------------------------+----------------------------------+
| 15718 | ssh-rsa AAAAB3NzaC1yc2EAAA | xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx |
| 15721 | 26d53a922bbd               | xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx |
+-------+----------------------------+----------------------------------+

Add a new SSH key with: platform ssh-key:add
Delete an SSH key with: platform ssh-key:delete [id]

platform ssh-key:add
...
```


```
# Je clone mon projet sur la branch n-1
git clone git clone --branch n-1 nkoaolx5osnio@git.eu.platform.sh:nkoaolx5osnio.git demo-dev
...
```

```
# je regarde la configuration 
cd demo-dev
platform 
Welcome to Platform.sh!

Project title: Demo Dev
Project ID: nkoaolx5osnio
Project dashboard: https://eu.platform.sh/#/projects/nkoaolx5osnio

Your environments are:
+--------+--------+--------+
| ID     | Name   | Status |
+--------+--------+--------+
| master | Master | Active |
| n-1*   | n-1    | Active |
+--------+--------+--------+
* - Indicates the current environment

Check out a different environment by running platform checkout [id]
Branch a new environment by running platform environment:branch [new-name]
Make a snapshot of the current environment by running platform snapshot:create
Merge the current environment by running platform environment:merge
Sync the current environment by running platform environment:synchronize

You can list other projects by running platform projects

Manage your SSH keys by running platform ssh-keys

Type platform list to see all available commands.
```

### Configuration de l'application : .platform-app-yaml.html + .platform/services.yaml + .platform/routes.yaml

 * [routes.yaml](https://docs.platform.sh/user_guide/reference/routes-yaml.html)
 * [services.yaml](https://docs.platform.sh/user_guide/reference/services-yaml.html)
 * [platform app](https://docs.platform.sh/user_guide/reference/platform-app-yaml.html)

Pour mon application "bonjour" :

```
|-- .git
|-- .platform
|   |-- local
|   |   |-- README.txt
|   |   `-- project.yaml
|   |-- routes.yaml
|   `-- services.yaml
|-- .platform.app.yaml
|-- index.php

index.php
<?php echo "bonjour" ; ?>

.platform.app.yaml
name: bonjour
type: php
disk: 128
web:
    document_root: "/"
    passthru: "/index.php"

.platform/routes.yaml
"http://{default}/":
    type: upstream
    upstream: "bonjour:php"

"http://www.{default}/":
    type: redirect
    to: "http://{default}/"

.platform/services.yaml
vide (pas de dépendance a d'autres services)
par défaut,  : 
mysql:
    type: mysql:5.5
    disk: 2048

redis:
    type: redis:2.8

solr:
    type: solr:3.6
    disk: 1024
```

### mise a jour de l'environnement n-1

Il n'y a plus qu'a push ce qu'on a construit localement.

```
git add --all ; git commit -m "first app bonjour" ; git push
...
# on voit qu'il va plus loin qu'un simple push, il construit l'environnement et le lance comme conteneur (avec les instructions que j'ai défini dans les fichiers de configuration) 
```

### Je teste et je merge sur la branch principale

platform.sh s'occupe de tout. Il créé meme une url par environnement et par projet. 

Je vérifie que j'ai bien mon rendu d'appli "bonjour" sur version-projet.eu.platform.sh ==> OK !

Je merge l'environnement n-1 vers la branche master.

![platform.sh.merge-n-1.jpg]({{ site.baseurl | prepend: site.url }}/assets/img/platform.sh.merge-n-1.jpg)

Et voila !

## Autres applications

Il semblerait que les deux projets fournis de base soient Symfony ou Drupal pour le moment. J'ai testé deux minutes et ça semble fonctionner sans qu'on ne touche a rien.

Il n'y a plus  qu'a intégrer ses Bundles et a coder.

Pour le reste, il me semble que les services proposés sont suffisants et demandent peu de configuration : 

 * PHP
 * Python
 * Ruby
 * NodeJS
 * Java (with integrated Maven and Ant support)
 * Postgres, MySQL, Redis etc. 

## Conclusion

platform.sh est vraiment intéressant pour les équipes de développements d'applications web de moyenne a grande envergure.

Tous les concepts sont connus (Git, CaaS (container as service), répartition de charge du trafic automatique, automatisation des tâches avec Grunt ou maintien des dépendances de librairies avec Composer, etc).

Ca n'est donc pas une révolution. Cependant, la promesse de simplifier les actions d'administration semble tenue.

Une fois qu'on a bien compris le fonctionnement des trois fichiers de configuration - .platform-app-yaml.html + .platform/services.yaml + .platform/routes.yaml - on peut, effectivement, se concentrer sur le code et la gestion des workflows.

