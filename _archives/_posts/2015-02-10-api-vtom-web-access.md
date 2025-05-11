---
layout: post
title: API VTOM webaccess
date: 2015-02-10 20:45
author: Virtual Thom
categories: [API, webaccess, Visual TOM, VTOM]
---
Vous n'êtes pas sans savoir que VTOM fournit, depuis quelques versions maintenant, un webaccess (un portail web d'accès à VTOM / vthttpd).

Sur une question de Stephane, je me suis penché sur son fonctionnement.

Voici quelques API VTOM glannées dans les pages du webaccess.

Peu importe comment vous y accédez, ici en curl (user:passwd à changer) mais on peut très bien faire ça avec POSTMAN.

# Liste de tous les environnements
```bash
curl -k -u user:passwd "http://localhost:30080/api/environment/list" -X GET  | python -m json.tool
```

# Liste de toutes les applications
```bash
curl -k -u user:passwd "http://localhost:30080/api/application/list" -X GET  | python -m json.tool
curl -k -u user:passwd "http://localhost:30080/api/application/list?envSId=ENV7f00000102a3106054b8e57700000014" -X GET  | python -m json.tool
curl -k -u user:passwd "http://localhost:30080/api/application/list?environmentName=VAGUE5_INT" -X GET  | python -m json.tool
```

# Liste de tous les jobs
```bash
curl -k -u user:passwd "http://localhost:30080/api/job/list" -X GET  | python -m json.tool
curl -k -u user:passwd "http://localhost:30080/api/job/list?appSId=APP7f00000129a98189539f1cb000000023" -X GET  | python -m json.tool
curl -k -u user:passwd "http://localhost:30080/api/job/list?applicationName=BASCULE_DATE" -X GET  | python -m json.tool
```

# Détails d'un job
```bash
curl -k -u user:passwd "http://localhost:30080/api/job/getById?id=JOB7f0000012b10ca88539f1cb4000000c2" -X GET  | python -m json.tool
```

# Détails de tous les jobs (ou autres items)
```bash
curl -k -u user:passwd "http://localhost:30080/api/job/getAll" -X GET  | python -m json.tool
```

## Exemple de résultat 
```json
{
    "rc": 0, 
    "result": {
        "ExpectedContexts": [], 
        "ExpectedResources": [], 
        "Script": "D:\\Script\\rotation_log_dxserver\\Rotate_log_dxserver.bat", 
        "appInErr": "1", 
        "applicationSId": "APP7f00000129a98189539f1cb000000023", 
        "blockDate": "0", 
        "cycle": "00:00:00", 
        "cycleEnabled": "0", 
        "descOnErr": "0", 
        "exploited": "E", 
        "frequency": "D", 
        "id": "JOB7f0000012b10ca88539f1cb4000000c2", 
        "information": " ", 
        "isAsked": "0", 
        "maxStart": "37:59:00", 
        "minStart": "25:30:00", 
        "mode": "E", 
        "movementTime": "0", 
        "name": "ROT_LOG_DXSERVER", 
        "onDemand": "0", 
        "restartCount": "0", 
        "restartLabel": "0", 
        "restartMax": "1", 
        "restartType": "M", 
        "retained": "0", 
        "retcode": "-1", 
        "status": "W", 
        "timeBegin": "1421112600", 
        "timeEnd": "1421112630", 
        "xid": "JOBc2"
    }
}
```
On a vérifié avec Stephane, les attributs sont hiérarchisés comme dans le vtexport xml (si pas dans Job, on remonte dans Application, si pas dans Application, on remonte sur Environnement).

# carrément le contenu du script !!!
```bash
curl -k -u user:passwd "http://localhost:30080/api/job/getScript?id=JOB7f0000012b10ca88539f1cb4000000c2"  -X GET  | python -m json.tool
```

# Liste des Logs (utiliser le job xid et non l'id tout court)
```bash
curl -k -u user:passwd "http://localhost:30080/api/log/getLogList?id=JOBc2"  -X GET  | python -m json.tool
```

# Si je résume :
```
Pour avoir toutes les informations détaillées d'un ensemble d'items (environment, application, job, date, host, instruction - pour info instruction c'est les consignes -  etc)
http://localhost:30080/api/<item>/getAll

Pour avoir toute la liste d'un ensemble d'items mais avec moins de détails 
http://localhost:30080/api/<item>/list

Pour avoir le détail d'un item en particulier
http://localhost:30080/api/<item>/getById?id=<id>

Pour filtrer la liste d'un ensemble d'item sur un attribut particulier
http://localhost:30080/api/<item>/list?<attribut>=<valeur>

Si l'attribut n'est pas présent dans l'item le plus bas (job), il faut remonter d'un cran (application) et encore d'un cran si besoin (environment). Notion de hiérarchie, notamment pour les dates, host, queue, user.
```

On peut aussi utiliser cette méthode pour s'authentifier, en passant par le header http : 

```
# echo -n "user:password" | base64, ici TOM:TOM
curl -H 'Authorization: Basic VE9NOlRPTQ=='
```

On peut aussi se pré-authentifier avec `/api/utilities/login` POST { login: "xxx", password: "xxx" }.
Ca renvoie un cookie avec `vtsession` et `webdoc_account_id` qu'il faudra rajouter aux futures requêtes.
Ce qui est bien avec cette méthode, c'est que les utilisateurs LDAP passent, alors que l'Authorization Basic ne fonctionne qu'avec des utilisateurs "locaux".

# Vous en voulez plus ? 

Aucune doc Absyss ne référence toutes les APIs. Donc petite astuce :

Ouvrez votre navigateur Chrome F12 et aller dans l'onglet Network pour voir les appels aux API. Baladez vous sur l'interface Web du web access et glannez les différentes adresses et requêtes XHR.

# Petite astuce côté client pour effectuer une request REST sur l'api VTOM sans utiliser jQuery
```javascript
var serveurVtom = "http://monserveurvtom:30080" ;
var xhr = new XMLHttpRequest();
xhr.onreadystatechange = function(){
      var status = xhr.status;

      if (status == 200) {
        
        if(xhr.response != null) {
                // toute la réponse avec les columns et les rows
                console.log( xhr.response ) ;
                // on récupère le nom par exemple et on l'affiche dans la console
                xhr.response.result.rows.forEach(function(entry){
                        console.log(entry.name);
                });
        }
        
      } else {
        console.log("error");
        console.log(status);
      }
}
xhr.open('GET', serveurVtom + '/api/job/list');
xhr.responseType = 'json';

// attention sous unix echo "user:passwdord" | base64 interprète le saut de ligne du echo et vous donne une mauvaise authentification
// il faut utiliser l'option -n, echo -n "user:password" | base64
// on peut utiliser un encodage base64 via javascript directement mais dans ce cas le user:mdp est en clair dans le code
// ex. VE9NOlRPTQ== => base64 pour TOM:TOM
xhr.setRequestHeader('Authorization', 'Basic VE9NOlRPTQ==');
xhr.send();
```


[Un exemple pour lister tous les jobs, il faut changer l'ip, le port et encoder le user:password]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/list_all_jobs.html)

```html
<html lang=fr">
<head>
<meta charset="utf-8" />
</head>
<body>

<button id="refresh-button">Refresh</button>
<table id="list-jobs"></table>

<script>
// Variables Globales
var serveurVtom = "http://192.168.99.100:30080" ; // A changer !
var authVtom = "VE9NOlRPTQ==" ; //base64 user:password
var itemsVtom = [ "environment", "application", "job", "date", "host", "queue" ] ; 
itemsVtom.forEach(function(item){
	eval("window.API_" + item + "_LIST = null ;") ;
});


// Fonctions
function findItemById(source, id){
    return source.filter(function( obj ) {
        return obj.id == id;
    })[ 0 ];
}

function debutAffichage(){
	
	window.API_job_LIST.result.forEach(function(entry){
		var application = findItemById(window.API_application_LIST.result, entry.applicationSId) ;
		var environment = findItemById(window.API_environment_LIST.result, application.environmentSId) ;
		var host = findItemById(window.API_host_LIST.result, entry.host) ;
		if(!host){
			var host = findItemById(window.API_host_LIST.result, application.host) ;
			if(!host){
				var host = findItemById(window.API_host_LIST.result, environment.host) ;
			}
		}
		var dateVtom = findItemById(window.API_date_LIST.result, entry.date) ;
		if(!dateVtom){
			var dateVtom = findItemById(window.API_date_LIST.result, application.date) ;
			if(!dateVtom){
				var dateVtom = findItemById(window.API_date_LIST.result, environment.date) ;
			}
		}
		var queue = findItemById(window.API_queue_LIST.result, entry.queue) ;
		if(!queue){
			var queue = findItemById(window.API_queue_LIST.result, application.queue) ;
			if(!queue){
				var queue = findItemById(window.API_queue_LIST.result, environment.queue) ;
			}
		}
		
		var tableListJobs = document.querySelector('table#list-jobs') ;
		var this_tr = document.createElement("tr");
		this_tr.innerHTML = "<td>" + environment.name + "</td>" +
			"<td>" + application.name + "</td>" +
			"<td>" + entry.name + "</td>" +
			"<td>" + dateVtom.name + "</td>" +
			"<td>" + queue.name + "</td>" +
			"<td>" + host.name + "</td>" +
			"<td>" + entry.Script + "</td>" ;

		if(entry.Parameters){
			this_tr.innerHTML = this_tr.innerHTML + "<td>" ;
			entry.Parameters.forEach(function(parameter){
				this_tr.innerHTML = this_tr.innerHTML + parameter + "<br>" ;
			});
			this_tr.innerHTML = this_tr.innerHTML + "</td>" ;
		}

		tableListJobs.appendChild(this_tr);
	}); //eof foreach job list

} // eof debutAffichage

function getItemsVtom(){
	if(typeof(Storage) !== "undefined") {
		var isAllItemsInStorage = true ;
		itemsVtom.forEach(function(item){
			if(sessionStorage["API_"+item+"_LIST"]){
				eval('window.API_'+item+'_LIST = JSON.parse(sessionStorage.getItem("API_'+item+'_LIST")) ;') ;
			}else{
				isAllItemsInStorage = false ;
			}

		});
		if(! isAllItemsInStorage){
			getItemsVtomAPI() ;
		}

	}else{
		getItemsVtomAPI() ;
	}
} // eof getItemsVtom

function removeItemsFromSessionStorage(){
	itemsVtom.forEach(function(item){
		sessionStorage.removeItem("API_"+item+"_LIST");
	});
}

// http://www.html5rocks.com/en/tutorials/cors/
// cross domain 
function getItemsVtomAPI(){
  
 itemsVtom.forEach(function(item){

	eval('var xhr'+item+' = new XMLHttpRequest();') ; 
	var strCode = 'xhr'+item+'.onreadystatechange = function(){' + 
	      'var status = xhr'+item+'.status;' +

	      'if (status == 200) {'+
		'if(xhr'+item+'.response != null) {' +
			'window.API_'+item+'_LIST = xhr'+item+'.response ;' +
			'if(typeof(Storage) !== "undefined") {' +
				'sessionStorage.setItem("API_'+item+'_LIST",JSON.stringify(window.API_'+item+'_LIST)) ;' +
			'}' +
		'}' + 
	      '}' +

	'}' ;
	eval(strCode);
	eval('xhr'+item+".open('GET', serveurVtom + '/api/"+item+"/getAll',true);") ;
	eval('xhr'+item+".responseType = 'json';") ;
	eval('xhr'+item+".setRequestHeader('Authorization', 'Basic ' + authVtom);");
	eval('xhr'+item+'.send();') ;
 });

} // eof getItemsVtomAPI

// On récupère les items
getItemsVtom() ;

function _isAllItemsLoaded(){

 console.log((new Date()).getTime()); // debug to make sure we pass through this
 
 var isAllItemsLoaded = true ;
 itemsVtom.forEach(function(item){
  
	if(eval('window.API_'+item+'_LIST') == null){
		isAllItemsLoaded = false ;
	}else if(eval('window.API_'+item+'_LIST.rc') == 4){
		isAllItemsLoaded = false ;
    console.log(eval('window.API_'+item+'_LIST.errmsg')) ;
    clearInterval(window.intervalDebutAffichage);
  }
 });
 if( isAllItemsLoaded )
 { 
  console.log("loaded"); // debug to make sure we pass through this 
	clearInterval(window.intervalDebutAffichage);
	debutAffichage();
  return true ;
 }else{
  return false ; 
 }  
}
if(! _isAllItemsLoaded()){ // si les items ne sont pas chargés au démarrage, on lance une boucle interval
  // On vérifie qu'on a bien chargé toutes les données, on affiche quand c'est ok
  window.intervalDebutAffichage = setInterval(_isAllItemsLoaded,1000); 

  // quoi qu'il arrive on sort de la boucle au bout de x secondes
  setTimeout(function(){ 
    clearInterval(window.intervalDebutAffichage);
  }, 60000);
}

// Events

// Refresh data
document.querySelector('#refresh-button').addEventListener('click',function(e){
	removeItemsFromSessionStorage();
	window.location = window.location ;	
}) ;

</script>

</body>
</html>
```

Bon évidemment ça ne donnera rien mais importer cette page chez vous, et changer l'IP, le port et le mot de passe pour que ça fonctionne.


## Exemple pour lister toutes les consignes

```
# on récupère les données en JSON depuis l'API web access VTOM
curl -k -u user:passwd "http://localhost:30080/api/instruction/getAll > /var/tmp/instructions.json

# on créé le script qui va générer les consignes au format HTML
vi /var/tmp/create_instructions_html.py
#!/usr/bin/python
import json
import sys
import io

jdata = open(sys.argv[1])
data = json.load(jdata)

for result in data["result"]:
        with io.open(result["name"] + ".html", "w", encoding='utf-8') as f:
                f.write(result["content"])
                f.close()
jdata.close()


# On exécute le script 
chmod +x /var/tmp/create_instructions_html.py
/var/tmp/create_instructions_html.py /var/tmp/instructions.json
```
