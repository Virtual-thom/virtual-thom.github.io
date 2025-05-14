---
layout: post
slug: vtom bac a sable avec docker compose
title: VTOM Bac à sable - docker compose
---
First things first, [installation Docker](https://docs.docker.com/desktop/). Moi, perso, ça sera sous Windows en WSL.  

## Télécharger docker.visual-tom-core
Demander à Absyss un token de download des sources et télécharger : docker.visual-tom-core-7.2.1e.zip

## Importer l'image dans docker
Déziper le fichier d'Absyss. Il y a l'image à l'intérieur core.tar.gz

```sh
docker load -i .\docker.visual-tom-core-7.2.1e\visual-tom-core-7.2.1e.tar.gz
  Loaded image: absyss/visual-tom-core:7.2.1e

docker tag 3e2d5a26df07 absyss/visual-tom-core:latest

docker images | findstr absyss
absyss/visual-tom-core          latest    3e2d5a26df07   2 months ago   2.31GB
absyss/visual-tom-core          7.2.1b    10709941e0a7   7 months ago   2.24GB
absyss/visual-tom-core          7.2.1e    3e2d5a26df07   2 months ago   2.31GB
```

## entrypoint et architecture du persistent volume
Le `docker-entrypoint.sh` (l'entrypoint de l'image docker) va créer des dossiers persistents (si non existants) dans `/var/lib/absyss/visual-tom` et faire des liens symboliques vers les "vrais" paths $TOM_HOME, ou copier parfois des fichiers etc. ci-après le détails  

tips : pour le docker desktop windows, en wsl, le répertoire du volume est accessible (le chemin peut être différent selon les noms, mais ça donne une idée) : `\\wsl.localhost\docker-desktop\mnt\docker-desktop-disk\data\docker\volumes\visual-tom_customer-data\_data`  

`/var/lib/absyss/visual-tom`  
```
    ../scripts  : pour les scripts

    ../backup   : pour les vtbackup, ln -s "$TOM_CUSTOMER_DATA/backup" "$TOM_HOME/backup"
    ../export   : pour les vtexport, ln -s "$TOM_CUSTOMER_DATA/export" "$TOM_HOME/export"

    ../keys     : clé priv, pub, ln -s "$TOM_CUSTOMER_DATA/keys" "$TOM_HOME/keys"

    ../data     : répertoire $TOM_BASES car ln -s "$TOM_CUSTOMER_DATA/data" "$TOM_HOME/bases"

    ../abm      : copie config et queues client vtom (agent) vers abm/config

    ../conf     : selon présence, docker-entrypoint.sh va soit copier les fichiers de conf par défaut ici, soit des fois utiliser les fichiers présents dans conf/, ou lien symbolique

       conf/.vtom.ini            :
  si absent, cp "$TOM_HOME/admin/.vtom.ini" "$TOM_CUSTOMER_DATA/conf/.vtom.ini"
  export TOM_INI_PATH=$TOM_CUSTOMER_DATA/conf
  à rajouter, le vtserver a besoin du vtapiserver notamment pour résoudre les fonctions, comme dans docker-compose le server et apiserver sont séparés, il faut le préciser (pas localhost) :
  [vtapiserver]  
  hostname=apiserver  
  port=30002  

        conf/VtomApiServer.ini    : si présent, ln -s "$TOM_CUSTOMER_DATA/conf/VtomApiServer.ini" "$TOM_HOME/vtom/bin/VtomApiServer.ini"

        conf/VtomApiServer.jks    : si présent, ln -s "$TOM_CUSTOMER_DATA/conf/VtomApiServer.jks" "$TOM_HOME/vtom/bin/VtomApiServer.jks"

        conf/server.crt           : si présent, copié dans $TOM_HOME, sinon créé à chaque fois

                tips : si jamais vous le faites vous avec votre serveur pki, il faut concat le crt et le key
                       attention, il faut le même sur tous les serveurs + clients si jamais

  openssl req -new -x509 -days 1095 -nodes -text -out "${TOM_HOME}/server.crt"  -keyout "${TOM_HOME}/server.key" -subj "/CN=Absyss Visual TOM"  
  cat "${TOM_HOME}/server.key" >> "${TOM_HOME}/server.crt"  

        conf/ldapcheck.ini        : si présent, ln -s "$TOM_CUSTOMER_DATA/conf/ldapcheck.ini" "$TOM_HOME/vtom/bin/ldapcheck.ini"

    ../traces   : si présent, ln -s "$TOM_CUSTOMER_DATA/traces" "${TOM_HOME}/traces"
    ../logs     : logs agent, ln -s "$TOM_CUSTOMER_DATA/logs" "$TOM_HOME/logs"
```

## Répertoire de travail
Dans votre répertoire de travail, vous aurez besoin de :  

`docker-compose.yml`
```yaml
x-env-variables: &env-variables
    TZ: Europe/Paris
    TOM_SERVER_HOST: server
    TOM_PORT_tomDBd: ${TOM_PORT_tomDBd:-30001}
    TOM_PORT_vtserver: ${TOM_PORT_vtserver:-30007}
    TOM_PORT_svtserver: ${TOM_PORT_svtserver:-30017}
    TOM_PORT_vtnotifier: ${TOM_PORT_vtnotifier:-30008}
    TOM_PORT_svtnotifier: ${TOM_PORT_svtnotifier:-30018}
    TOM_PORT_vtapiserver: ${TOM_PORT_vtapiserver:-30002}
    TOM_PORT_bdaemon: ${TOM_PORT_bdaemon:-30004}
    TOM_PORT_sbdaemon: ${TOM_PORT_sbdaemon:-30014}
    TOM_SGBD_HOST: db
    TOM_SGBD_PORT: ${TOM_SGBD_PORT:-30009}
    TOM_SGBD_DBNAME: vtom
    TOM_SGBD_USER: vtom
    
x-service-base: &base-service
  image: ${DOCKER_IMAGE_NAME:-absyss/visual-tom-core}:${DOCKER_IMAGE_VERSION:-latest}  
  ulimits:
    nofile:
      soft: 65536
      hard: 65536
    memlock:
      soft: -1
      hard: -1

services:
  agent:
    <<: *base-service
    environment:
       <<: *env-variables
    command: agent
    volumes:
      - customer-data:/var/lib/absyss/visual-tom
    # Uncomment to expose agent service
    #ports:
    #  - "${TOM_PORT_bdaemon:-30004}:${TOM_PORT_bdaemon:-30004}"
    #  - "${TOM_PORT_sbdaemon:-30014}:${TOM_PORT_sbdaemon:-30014}"
    restart: unless-stopped
    
  server:
    <<: *base-service
    environment:
       <<: *env-variables
    command: server
    volumes:
      - customer-data:/var/lib/absyss/visual-tom
      - type: bind
        source: ./license.xml
        target: /opt/absyss/visual-tom/vtom/bin/license.xml
      - type: bind
        source: ./.vtom.ini
        target: /var/lib/absyss/visual-tom/conf/.vtom.ini
    ports:
      - "${TOM_PORT_tomDBd:-30001}:${TOM_PORT_tomDBd:-30001}"
      - "${TOM_PORT_vtserver:-30007}:${TOM_PORT_vtserver:-30007}"
      - "${TOM_PORT_vtnotifier:-30008}:${TOM_PORT_vtnotifier:-30008}"
      - "${TOM_PORT_svtserver:-30017}:${TOM_PORT_svtserver:-30017}"
      - "${TOM_PORT_svtnotifier:-30018}:${TOM_PORT_svtnotifier:-30018}"
    depends_on:
      - db
    restart: unless-stopped
  
  db:
    <<: *base-service
    environment:
       <<: *env-variables
    command: db
    volumes:
      - customer-data:/var/lib/absyss/visual-tom
    # Uncomment to expose db service
    #ports:
    #  - "${TOM_SGBD_PORT:-30009}:${TOM_SGBD_PORT:-30009}"
    restart: unless-stopped

  apiserver:
    <<: *base-service
    environment:
       <<: *env-variables
    command: apiserver
    volumes:
      - customer-data:/var/lib/absyss/visual-tom
    ports:
      - "${TOM_PORT_vtapiserver:-30002}:${TOM_PORT_vtapiserver:-30002}"
    depends_on:
      - db
      - server
    restart: unless-stopped

volumes:
  customer-data:

# NFS example
#    driver_opts:
#      type: "nfs"
#      o: "addr=10.10.10.10,nolock,soft,rw"
#      device: ":/vtom/data"

# External example
#    external: true
    name: visual-tom_customer-data
```

les différents "types" de container : agent, server, apiserver, db, shell  (ce sont les options de l'entrypoint de l'image docker)  
Vous pouvez vous connecter dans les containers : `docker compose exec server bash`

Tips : si vous faites un exec sur la db, pensez à `export LD_LIBRARY_PATH=${TOM_HOME}/sgbd/lib` pour pouvoir `${TOM_HOME}/sgbd/bin/psql -Uvtom -dvtom -p30009`


Le fichier `.vtom.ini` (exemple) :
```
[GLOBALES]
nbWaitRetry=2
StatusFailSubmit=AVENIR
StatusFailExist=ENCOURS

[VTSERVER]
TRACE_LEVEL=1
TRACE_FILE=/var/lib/absyss/visual-tom/traces/vtserver.log
TRACE_FILE_SIZE=10
TRACE_FILE_COUNT=10


[TENGINE:Exploitation]
TRACE_LEVEL=1
TRACE_FILE=/var/lib/absyss/visual-tom/traces/Exploitation.log
TRACE_FILE_SIZE=10
TRACE_FILE_COUNT=10
timeBexist=30

[job]
tagScript=#

[vtapiserver]
hostname=apiserver
port=30002
```

Votre fichier `license.xml`

## Lancer le déploiement
soit passer par le terminal, soit par l'interface graphique du Docker Desktop.

```sh
docker compose up -d
```
![Docker Desktop](/assets/img/docker-desktop-compose.png "Docker Desktop")


## Accès
Accès au client léger : `https://localhost:30002/xvision/`

Quand vous créez l'agent docker dans le référentiel vtom, il faut mettre le nom que vous avez mis dans le docker-compose. 
Moi c'est `agent` 
![VTOM agent docker](/assets/img/docker-agent.png "VTOM agent docker")
