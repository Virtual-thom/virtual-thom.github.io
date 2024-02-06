---
layout: post
title: Exemple script python API VTOM
date: 2024-02-06 09:00:00
author: Virtual Thom
---
Petit script python pour donner un exemple de ce qu'il est désormais possible de faire avec les API VTOM. 
Le besoin : écrire dans un fichier texte la liste de tous les agents d'une unité de soumission en particulier. 
<!-- more -->
 
Pour info en v7.1, l'API `/vtom/public/domain/2.0/submitUnits` est censée donner la liste des unités de soumissions avec les agents mais elle est buggée acutellement. Elle ne renvoie pas les agents associés.  
```
[
  {
    "name": "MySubmitUnit",
    "comment": "A simple comment",
    "type": "Single",
    "agents": [
      "string"
    ]
  }
]
```

Contournement : `/vtom/public/domain/2.0/submitUnits/{unit}/agents` qui va donner la liste des agents d'une unité de soumission en particulier. 

```python
#!/bin/python
import requests
import sys

urlAPI = "https://srvvtom:30002/vtom/public/domain/2.0"
urlSubmitUnits = urlAPI + "/submitUnits"
headers = {"accept": "application/json", "X-API-KEY": "votrecleAPIvtom"}
response = requests.get(urlSubmitUnits, headers=headers, verify=False)

ficNameListe      = sys.argv[1]
searchCommencePar = sys.argv[2]
searchContientLot = sys.argv[3]
searchContientOS  = sys.argv[4]

with open(ficNameListe, "w") as f:
	if response.status_code == 200:
	    data = response.json()

	    filtered_data = [item for item in data if item["name"].startswith(searchCommencePar) and searchContientLot in item["name"] and searchContientOS in item["name"] ]
	    for item in filtered_data:
		name = item["name"]
		urlAgents = urlSubmitUnits + "/" + name + "/agents"
		response2 = requests.get(urlAgents, headers=headers, verify=False)
		if response2.status_code == 200:
		    agents = response2.json()

		    agents_str = ",".join(agents)
		    print(name + ";" + agents_str)

		    for agent in agents:
		      f.write(agent + "\n")
		else:
		    print("Erreur: {}".format(response2.status_code))
		    sys.exit(1)
	else:
	    print("Erreur: {}".format(response.status_code))
	    sys.exit(1)
f.close()
```

Prérequis : AbsyssRESTServer démarré, un jeton API avec les bons droits dans VTOM Outils Sécurité du serveur API.

Pour rappel, vous avez une super "doc" en ligne des API VTOM en parcourant l'url : `https://localhost:30002/swagger-ui` depuis votre serveur VTOM.
