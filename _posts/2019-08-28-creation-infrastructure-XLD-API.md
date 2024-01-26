---
layout: post
title: Création infrastructure XLD via API
date: 2019-08-28 08:14
author: Virtual Thom
categories: [xld, api, DevOps]
---

Exemple de création d'une infrastructure XLD (v7) via API. C'est à adapter bien sûr, mais ça donne une bonne idée pour créer en masse des infra' en ligne de commande.
<!--more-->
```sh
urlAPI="http://urlxldserver:4516/deployit/repository/ci/"

## A changer à chaque fois pour chaque besoin
baseID="Infrastructure/FULL/PATH/ARBOXLD/"
debug="echo"

function writeJSON(){
  id=$1
  machine=$2
  username=${3:-luke}
  password=${4:-luke}
  if test -z "$id" -o -z "$machine";then 
    return 123
  fi
  ficJSON=`basename $id`".json"

# ici besoin de création WINDOWS host
  cat << EOF > ${ficJSON}
{
id: "${id}",
type: "overthere.SmbHost",
os: "WINDOWS",
connectionType: "WINRM_NATIVE",
address: "${machine}",
username: "${username}",
password: "${password}",
smbPort: "445"
}
EOF
  # azertyiopxxxxx -> echo -n user:mdp | base64
  $debug curl -X POST -H "Content-type:application/json" -H "Authorization: Basic azertyiopxxxxx" ${urlAPI}${id} -d@${ficJSON}
  return 0
}

cat << EOF | while read srv ; do writeJSON "${baseID}${srv}" "${srv}" ; done
MONSERVERWIN1
MONSERVERWIN2
MONSERVERWIN3
MONSERVERWIN4
MONSERVERWIN5
MONSERVERWIN6
MONSERVERWIN7
MONSERVERWIN8
MONSERVERWIN9
MONSERVERWIN10
MONSERVERWIN11
MONSERVERWIN12
MONSERVERWIN13
EOF

```

## Docs

[https://docs.xebialabs.com/xl-deploy/7.0.x/rest-api/](https://docs.xebialabs.com/xl-deploy/7.0.x/rest-api/)

Notre version XLD v7 étant vieillissante, voir la doc du latest :

[https://docs.xebialabs.com/xl-deploy](https://docs.xebialabs.com/xl-deploy)
