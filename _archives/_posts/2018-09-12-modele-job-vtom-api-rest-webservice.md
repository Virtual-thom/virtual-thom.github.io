---
layout: post
title: Webservice / Modele Job VTOM REST
date: 2018-09-12 12:00:00
author: Virtual Thom
categories: [API, webservice, Visual TOM, VTOM, modele, REST]
---
> All service interfaces, without exception, must be designed from the ground up to be externalizable. That is to say, the team must plan and design to be able to expose the interface to developers in the outside world. No exceptions.
> Anyone who doesn't do this will be fired.
> Thank you; have a nice day!

Dixit [Jeff Bezos (Amazon's CEO) Mandate 2012]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/modularization.pdf). 

2012 ... C'est pourtant devenu la norme. Et la paraphrase "Si vous développez une application sans API, vous êtes viré !" est toujours d'actualité. Les API sont partout. 

Vous connaissez sans doute XLDeploy / XLRelease et Jenkins ?! Dans le monde DevOps, ces outils semblent incontournables, notamment pour le déploiement et/ou intégration continu, la gestion d'un workflow, etc...
Et, devinez quoi ? ils fonctionnent et proposent des API REST. 

What about notre ordonnanceur préféré VTOM dans tout ça ? Après tout, il pourrait très bien déclencher et gérer ces workflows. Il suffirait de scripter (nodejs, powershell ou autre) les appels API.

Oui, mais pas que ! Sâchez qu'il existe des modèles de traitement "Web Service REST" qui peut nous simplifier la vie et avoir quelque chose de bien plus exploitable et visuel.

Je vais faire deux exemples GET et je m'arrêterai là pour cette introduction. Mais ça donnera les bases pour faire du GET, PUT, POST, DELETE.
 * Une récurépation de fichier XML si, dans la réponse, j'ai une certaine valeur, d'un noeud en particulier, qui me sied (grâce à une expression XPath)
 * Une récupération de fichier JSON si dans la réponse j'ai un attribut JSON "status" à OK (grâce au JSONPath)
<!--more-->
# Prérequis pour utiliser les modèles de Job Webservice REST VTOM

 * Version VTOM : (je n'ai pas la version minimum requise mais j'ai déjà ce modèle en 5.7.4, et ma version testée et présentée est la 6.2.3)
 * une licence, pour le module complémentaire "Web Service REST", à voir avec Absyss
 * un client relativement récent avec la queue VTOM `queue_vt2wsrest` fournie par Absyss et java JRE installé et dans le PATH (ex. `apt-get install default-jre` ira très bien pour une debian)

Et c'est à peu près tout en fait.

# Mes premiers jobs Webservice REST via VTOM

J'ai mis quelques minutes à comprendre le truc, mais une fois qu'on a tâtonné dans les différents onglets, c'est assez facile.

 1. Glisser/Déposer le modèle de traitement "Web Service REST" dans une application VTOM. Donner un nom au job, et aller dans l'onglet "Paramètres REST"
 ![Job VTOM Webservice REST 01]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/job_vtom_modele_webrest_01.jpg "Job VTOM Webservice REST 01")
 2. Ajouter une étape avec le +, on obtient une étape "GET" de base qu'on va pouvoir personnaliser.
     * Pour chaque étape, la personnalisation se résume à : 
        * Saisir une URL "type API REST". Cette requête pourra déclencher quelque chose ou retourner du JSON ou du XML par exemple
![Job VTOM Webservice REST 02]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/job_vtom_modele_webrest_02.jpg "Job VTOM Webservice REST 02")        
        * Saisir des en-têtes si besoin (exemple : Content-Type => application/xml) en cliquant sur +
![Job VTOM Webservice REST 04]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/job_vtom_modele_webrest_04.jpg "Job VTOM Webservice REST 04")
        * Saisir un user/pwd si besoin d'authentification dans l'onglet "Authentification"
     * Au sein même de chaque étape, on peut effectuer une à n plusieurs actions dans l'onglet "Résultat". Ca se résume pour le "GET" à :
        * Valoriser une variable avec la valeur d'une expression XPath ou JSONPath
        * Contrôler la valeur d'une variable et sortir au besoin
        * Ecrire le résultat dans une ressource VTOM
        * Ecrire le résultat dans un fichier
![Job VTOM Webservice REST 03]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/job_vtom_modele_webrest_03.jpg "Job VTOM Webservice REST 03")
 3. Ajouter autant d'étapes que l'on souhaite

## Résultats 
 
 1. Job récup' JSON
 Je ne fais que du copier/coller des actions définies dans l'onglet "Résultat". On voit que c'est très "compréhensible" :
 
  * 1ère étape du job sur l'url /api/ qui me retourn `{"version":"1.0","status":"ok"}` :
    * Valoriser la variable 'status' avec le résultat de l'expression jsonPath 'status'
      (ici, je valorise une variable - peu importe le nom - avec la valeur de l'attribut `status` de mon retour JSON /api)
    * Sortir avec un code retour 0 si la variable 'status' est égale à 'ok'
      (un peu bizarre à construire celui-là, il faut donner la condition OK. Moi j'aurais plutôt donné la condition "sort KO si") sous-entendu, sort si différent de "OK" et on aura un joli code 244
  * 2ème étape du job sur un autre url /api/getAllDomainesDB qui me retourne un tableau JSON de valeur (peu importe) : 
    * Sauvegarder la réponse dans le fichier 'test.json' (bon ça se passe de commentaire mais sâchez que le répertoire courant semble être celui de l'install du client VTOM)
```
vtom@5a21957e2896:~$ ls -l
total 76
drwxr-xr-x  5 vtom vtom  4096 Sep 11 07:55 abm
drwxr-xr-x  2 vtom vtom  4096 Sep 11 07:55 admin
drwxrwxrwx  2 vtom vtom  4096 Jan 18  2018 scripts
-rw-r--r--  1 vtom vtom 10697 Sep 11 08:23 serveurs.log
-rw-rw-rw-  1 vtom vtom   235 Sep 12 09:00 test.json
...
vtom@5a21957e2896:~$ cat test.json
["xxxxx.db","yyyyyy.db","zzzzzzzz.db"]
```

 2. Job récup' XML
   * Set variable 'classPathEntry' with result of XPath expression '/server-info/classpath/classpath-entry[1]/text()' (ici je récupère le texte du premier noeud classpath-entry)
   * Sortir avec un code retour 0 si la variable 'classPathEntry' est égale à 'D:\XLDeploy\xl-deploy-7.0.1-server\serviceWrapper\wrapperApp.jar' (je teste la valeur ou je sors)
   * Sauvegarder la réponse dans le fichier 'server-info.xml' (j'écris dans la réponse dans un fichier)
 
```
vtom@5a21957e2896:~$ cat server-info.xml
<server-info>
 <classpath>
  <classpath-entry>D:\XLDeploy\xl-deploy-7.0.1-server\serviceWrapper\wrapperApp.jar</classpath-entry>
  <classpath-entry>D:\XLDeploy\xl-deploy-7.0.1-server\conf</classpath-entry>
  <classpath-entry>D:\XLDeploy\xl-deploy-7.0.1-server\hotfix\lib\readme.txt</classpath-entry>
  ....
```

log VTOM plutôt explicite : 
 ```
10:12:26 | INFO  | Add Header name: 'Content-Type' value: 'application/xml'
10:12:26 | INFO  | Perform request
10:12:26 | INFO  | Response status code: 200
10:12:26 | INFO  | Set variable 'classPathEntry' with xpath expression '/server-info/classpath/classpath-entry[1]/text()'
10:12:26 | INFO  | Response media type: 'text/xml'
10:12:27 | INFO  | Xpath expression returns 1 node(s)
10:12:27 | INFO  | Set variable 'classPathEntry' with xpath expression value
10:12:27 | INFO  | Exit if variable 'classPathEntry' EQUALS 'D:\XLDeploy\xl-deploy-7.0.1-server\serviceWrapper\wrapperApp.jar'
10:12:27 | INFO  | Variable value is a NodeList
10:12:27 | INFO  | Variable 'classPathEntry' value: 'D:\XLDeploy\xl-deploy-7.0.1-server\serviceWrapper\wrapperApp.jar'
10:12:27 | INFO  | Save result to file: 'server-info.xml'
```

<small>
Petite dédicace à DukeAstar car il me semble que s'il n'y est pas pour quelque chose, il n'y est pas pour rien non plus. Enfin j'me comprends ! ON T'AIME DUKEEEE HashTag*pourceverslehaut* HashTag*DukeEqualsDieu*</small>
