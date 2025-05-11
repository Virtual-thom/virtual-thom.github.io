---
layout: post
title: API VTOM webaccess (update)
date: 2018-05-01 20:00:00
author: Virtual Thom
categories: [API, webaccess, Visual TOM, VTOM]
---

## Avertissement
* Les APIs ne sont pas soutenues pas Absyss pour le moment (ni documentées). Vous pouvez les utiliser mais on ne vous fournira aucune aide, assistance, ou débuggage d'après moi. (maj 11/05/20 à priori, les API seront supportées dès la v6.4.5)
* Il n'y a aucune garantie que ce qui fonctionne aujourd'hui fonctionnera de la même manière avec la prochaine version.
* Il est donc actuellement déconseillé de les exploiter en environnement productif.

Petite update du [1 er post API VTOM via le WebAccess ici](/api-vtom-web-access).

## Rappels importants sur le portail web et les API

* Côté serveur : Démarrez le service `vthttpd` et tapez `vtping` pour voir son état et son port. (le port est défini dans `/etc/services`). Le démarrage automatique peut être décommenté du script `$TOM_ADMIN/start_servers`
* Côté client : Interface web type client léger afin d'explorer, piloter, et suivre l'exploitation d'un serveur VTOM. Rendez-vous sur l'url http://&lt;nomdevotreserveur ou sonIP&gt;:&lt;port&gt; et authentifiez-vous.
* Ouvrez votre navigateur Chrome F12 et allez dans l’onglet Network pour voir les appels aux API. Baladez dans les menus du portail web et glannez les différentes adresses et requêtes XHR.
* Requêter : 
  * Rajouter dans le header des requêtes le user:mdp en base64 (voir mon premier post pour les détails) : ex. pour une XMLHttpRequest `xhr.setRequestHeader('Authorization', 'Basic VE9NOlRPTQ==')`
  * En local depuis le même serveur VTOM, les appels directs XMLHttpRequest Chrome passent sans soucis. En revanche, je n'ai pas réussi à faire fonctionner depuis un autre domaine (à cause du Cross-origin resource sharing - [CORS](https://developer.mozilla.org/fr/docs/Web/HTTP/CORS))
  * sinon les appels en back-end fonctionnent très bien de n'importe où : `curl`, `node js`, `php` etc. 
<!--more-->
Exemple avec NodeJS

```javascript
// ./vtom-api-client.js
const rp = require('request-promise-native')

module.exports = class VtomApiClient {
    constructor(url, token, options) {
        this.url = url
        this.token = token
        this.options = options || {}
    }
    
    getJob(env, app, job){
        return this._request('GET',
        "/api/job/list?"+
            "environmentName="+env+
            "&applicationName="+app+
            "&name="+job
        )
    }

    _buildOptions(method, endpoint, data) {
        return {
            method: method,
            uri: this.url + endpoint,
            headers: {
                'Content-Type': 'application/json',
                'Authorization': this.token ? `Basic ${this.token}` : undefined,
            },
            body: data,
            json: true,
            strictSSL: this.options.strictSSL,
        };
    }

    _request(method, endpoint, data) {
        const options = this._buildOptions(method, endpoint, data);
        //console.log(options);
        return rp(options);
    }
};
```

```javascript
// ./server.js 
// (...)
const VtomApiClient = require('./vtom-api-client.js')
const makeBasicToken = (user,password) => {
  return Buffer.from(
    user+":"+Buffer.from(password, 'base64').toString('ascii')
  ).toString('base64')
}
let monVtomApiClient = new VtomApiClient(
  Config.vthttpd[domaine].url,
  makeBasicToken(Config.vthttpd[domaine].user,Config.vthttpd[domaine].password),
  {strictSSL: false}
)
// (...)
monVtomApiClient.getJob(Jalon.env,Jalon.app,Jalon.job)
            .then(data => {
              // data resultat de la requête API webaccess
              io.emit('updateAllStatus', data)
            })
            .catch((e) => console.log('Error: ' + e))
// (...)
```

## La grosse nouveauté que j'attendais !

Le Suivi en temps réel du WebAccess était pas trop mal pour avoir les statuts en temps réel sur VTOM. Malheureusement, on était limité à 1000 jobs dans la requête (très peu donc). Bref, ça n'allait pas. 

Maintenant, on a une nouvelle fonctionnalité depuis la v6.2, le "Suivi d'exploitation". On peut filtrer par env, app, ou job. C'est excellent. On a tout ce qu'il faut pour un suivi météo : vtbegin, vtend, status etc.

Voici un exemple (notez qu'on n'est pas obligé de mettre les noms en entier, genre de LIKE %) : 

```
/api/suiviExploit?environmentName=thom&name=te
```

Et une capture d'écran :

![Suivi d'exploitation VTOM WebAccess API]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/suivi_exploitation_webaccess.png)

## Pour mes collègues de la 89C3 : Est-il possible de déclencher un job VTOM par API ?

Of course !

 * Lister les applications/jobs à la demande : 

`/api/status/getOnDemand`

```json
{
  "result": [
    {
      "jobSId": "JOBc0a8178000001547559555ab00000010",
      "environmentSId": "ENVc0a8178000000029559555a900000001",
      "applicationSId": "APPc0a81780000041bb559555a900000009",
      "isAsked": "0",
      "retained": "0",
      "status": "F",
      "environmentName": "exploitation",
      "comment": "Traitement termine (0)",
      "timeEnd": "1536755283",
      "applicationName": "APPLICATION",
      "jobName": "JOB_Unix",
      "onDemand": "1",
      "executionMode": "E",
      "timeBegin": "1536755282",
      "exploited": "E",
      "cycleEnabled": "0"
    },
    {
      "jobSId": "JOBc0a8178000004d06559555ab0000000e",
      "environmentSId": "ENVc0a8178000000029559555a900000001",
      "applicationSId": "APPc0a81780000041bb559555a900000009",
      "isAsked": "0",
      "retained": "0",
      "status": "F",
      "environmentName": "exploitation",
      "comment": "Job en simulation, considere termine",
      "timeEnd": "1536710401",
      "applicationName": "APPLICATION",
      "jobName": "JOB_Windows",
      "onDemand": "1",
      "executionMode": "S",
      "timeBegin": "1536710400",
      "exploited": "E",
      "cycleEnabled": "0"
    }
  ],
  "rc": 0
}
```

 * On récupère `jobSId` et on le demande (en changeant les paramètres si nécessaire) `/api/utilities/setObjectAction?id=JOBc0a8178000001547559555ab00000010&action=JOB_ACTION_ASK&parameters=%5B%22aurevoir+luke%22%5D`

 (il faut faire des requêtes authentifiées bien sûr)
 
 
 ```
 Pour le test dans la définition du « Type » dans XLR :
http://url:port/api/utilities/login
Il faut passer en clair les clés :
{ login : "logintest", password : "logintest" }
(user sans aucun droit)
Et attendre un retour comme ça : 
{
    "rc": 0,
    "result": {
        "rc": "0"
    }
}
 


Dans la tâche, ça sera des appels de ce type :

avec en Header : 
Authorization   Basic 
Avec user XLRTest et mdp XLRTest
Ou directement :
Authorization : Basic WExSVGVzdDpYTFJUZXN0
Ce user n’aura que les droits qu’on lui donne dans VTOM


Pour tout un tas de raison, il faut récupérer le jobSId, applicationSId et environmentSId.
Dans tous les cas, on devra connaître le nom du job VTOM à lancer : environmentName/applicationName/jobName

Deux possibilités,  : 
•	Soit on liste tous les jobs à la demande (le user ne voit que ce qu’on lui donne dans les droits du profil)
Je ne peux pas filtrer les tâches à la demande VTOM. Il faudra le faire sur le retour JSON.
Liste des tâches à la demande : 
/api/status/getOnDemand
{
    "rc": 0,
    "result": [
        {
            "jobSId": "",
            "jobName": "",
            "environmentName": "89C3",
            "environmentSId": "ENV7ef670af000006df5b990a310000000f",
            "exploited": "E",
            "status": "F",
            "comment": "",
            "applicationName": "APPTEST01",
            "applicationSId": "APP7ef670af00007faa5b990a4e000013bb",
            "timeEnd": "0",
            "timeBegin": "0",
            "onDemand": "1",
            "retained": "0",
            "isAsked": "1",
            "cycleEnabled": "0",
            "executionMode": "J"
        },
        {
            "jobSId": "JOB7ef670af0000053b5b990a95000062e4",
            "jobName": "JOB01",
            "environmentName": "89C3",
            "environmentSId": "ENV7ef670af000006df5b990a310000000f",
            "exploited": "E",
            "status": "F",
            "comment": "termine (0)",
            "applicationName": "APPTEST01",
            "applicationSId": "APP7ef670af00007faa5b990a4e000013bb",
            "timeEnd": "0",
            "timeBegin": "1537966364",
            "onDemand": "1",
            "retained": "0",
            "isAsked": "0",
            "cycleEnabled": "0",
            "executionMode": "E"
        }
    ]
}

•	Soit on sait que le job est bien un job à la demande VTOM, dans ce cas, on peut filtrer et on récupère les SId :
/api/job/list/?environmentName=89C3&applicationName=APPTEST01&name=JOB01
{
    "rc": 0,
    "result": {
        "rows": [
            {
                "envSId": "ENV7ef670af000006df5b990a310000000f",
                "exploited": "E",
                "status": "F",
                "comment": "",
                "applicationName": "APPTEST01",
                "environmentName": "89C3",
                "isAsked": "0",
                "retained": "0",
                "appSId": "APP7ef670af00007faa5b990a4e000013bb",
                "onDemand": "1",
                "id": "JOB7ef670af0000053b5b990a95000062e4",
                "name": "JOB01",
                "message": "termine (0)",
                "cycleEnabled": "0",
                "execMode": "E"
            }
        ],
        "columns": [
            "envSId",
            "environmentName",
            "appSId",
            "applicationName",
            "id",
            "name",
            "comment",
            "message",
            "status",
            "exploited",
            "retained",
            "onDemand",
            "isAsked",
            "cycleEnabled",
            "execMode"
        ]
    }
}


(a voir si on fait cette étape)
Il faut s’assurer que le moteur de l’environnement est bien démarré (result.rows[0].enginePid = 1): 
/api/environment/list?id=environmentSId
{
    "rc": 0,
    "result": {
        "rows": [
            {
                "id": "ENV7ef670af000006df5b990a310000000f",
                "enginePid": "1",
                "name": "89C3"
            }
        ],
        "columns": [
            "id",
            "name",
            "enginePid"
        ]
    }
}


Si status différent de W, Remettre AVENIR l’application - si tous les jobs à l’intérieur sont à lancer - et le job – si un job en particulier dans une application VTOM plus globale : 
/api/utilities/setObjectAction?id=applicationSId&action=APP_ACTION_SET_WAIT
/api/utilities/setObjectAction?id=jobSId&action=JOB_ACTION_SET_WAIT

Pour « demander » l’application VTOM : 
/api/utilities/setObjectAction?id=applicationSId&action=APP_ACTION_ASK

Dans tous les cas, on demande le job avec les paramètres :
/api/utilities/setObjectAction
1.	id: 
JOB7ef670af0000053b5b990a95000062e4
2.	action: 
JOB_ACTION_ASK
3.	parameters: 
["taskIdXLR"]
```

Forcer un statut sur APP ou JOB_ACTION_SET_XXX, on remplace XXX
(ce qui vaut pour JOB, vaut pour APP)

```
JOB_ACTION_SET_FINISHED ==> TERMINE
JOB_ACTION_SET_ERROR ==> EN ERREUR
JOB_ACTION_SET_RUNNING ==> EN COURS
JOB_ACTION_SET_WAIT ==> A VENIR
JOB_ACTION_SET_UNSCHEDULED ==> NON PLANIFIE
```

Forcer une action 

```
JOB_ACTION_RETAIN ==> RETENIR
JOB_ACTION_CONTINUE ==> RETENIR
JOB_ACTION_ASK ==> DEMANDER
```
