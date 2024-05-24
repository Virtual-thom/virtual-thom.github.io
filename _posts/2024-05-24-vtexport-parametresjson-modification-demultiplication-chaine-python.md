---
layout: post
title: vtexport parametresjson modèle de job - démultiplication de chaine vtom
date: 2024-25-24 13:39
author: Virtual Thom
categories: [script, python, vtexport, Visual TOM, Visual TOM, VTOM, VTOM]
---
J'en avais déjà discuté sur ce blog, certaines données, notamment dans le vtexport, sont "encodées" dirons-nous.  
Pas très pratique pour faire des modifications. Un peu mieux et en clair sur l'export xml en ce qui concerne les modèles de job vtom (type Transferts) mais ça reste une chaîne de caractère qui représente le job sous format JSON.  
  
Allez ! petit exercice sympa que j'ai eu à faire récemment, démultiplication d'une chaine de jobs de transfert - basés sur Modèle de Job VTOM Transfert donc - sur  multibanques et multi-typedefichier.  
~ 300 jobs, hors de question que je conceptionne (immaculée) à la main.  

<!--more-->
Ma première idée, c'est de créer un modèle, de l'exporter, et de bidouiller.  
Sauf que, comme on l'a dit, c'est encodé. On a ce genre de data pour la définition du job :  
```ini
parametresjson=eJyFkE1rwz********Dv21k/Yod1GM8********r4bEugs8BxLwSNSk*****rexDrYL*****Wakc34j+0*********
```

On variabilise notre chaîne modèle avec XXXBANQUEXXX et XXXTYPEXXX là où les valeurs sont à changer.  
1 application par XXXBANQUEXXX à démultiplier en une quinzaine de banques et 7 différents XXXTYPEXXX par banque, chaine de 3 jobs par type.  

Premièrement une fonction python qui décode, remplace, et rencode :  
```python
import zlib
import base64
import json
import re

def parametresjsonReplace(a):
  # valeur récupérée du modèle qui doit comporter les variables à modifier, ex. XXXBANQUEXXX, XXXTYPEXXX
  # parametresjson=
  #a = 'eJyFkE1rwz********Dv21k/Yod1GM8********r4bEugs8BxLwSNSk*****rexDrYL*****Wakc34j+0*********' 
  encoded = a.encode()
  decoded_base64 = base64.b64decode(encoded)
  decompressed = zlib.decompress(decoded_base64)
  json_obj = json.loads(decompressed)
  # on boucle sur toutes les clés du modèle de job de transfert vtom, et on remplace les valeurs du modèle par la variable
  for cle in json_obj["transfer"]["task"]:
      if isinstance(json_obj["transfer"]["task"][cle], str):
          json_obj["transfer"]["task"][cle] = json_obj["transfer"]["task"][cle].replace("XXXBANQUEXXX", _XXXBANQUEXXX)
          json_obj["transfer"]["task"][cle] = json_obj["transfer"]["task"][cle].replace("XXXTYPEXXX", _XXXTYPEXXX)

  json_str = json.dumps(json_obj)
  compressed = zlib.compress(json_str.encode())
  encoded_base64 = base64.b64encode(compressed)
  a = encoded_base64.decode()
  return a
```

Bon bah voilà, c'est tout. Maintenant, y a plus qu'à faire une boucle et démultiplier, en bougeant un peu l'axe des abscisses pour chaque job.  
Je pars sur 1 export / banque et type de fichier pour ne pas me faire suer. J'importerai tous les fichiers export d'un coup.  
Ah ! et je ne me fais pas suer non plus avec la position X de l'application par banque car flemme, je les bougerai joliement en Dessin > Distribuer plus tard après import.  

```python
import zlib
import base64
import json
import re


def parametresjsonReplace(a):
  # valeur récupérée du modèle qui doit comporter les variables à modifier, ex. XXXBANQUEXXX, XXXTYPEXXX
  # parametresjson=
  #a = 'eJyFkE1rwz********Dv21k/Yod1GM8********r4bEugs8BxLwSNSk*****rexDrYL*****Wakc34j+0*********' 
  encoded = a.encode()
  decoded_base64 = base64.b64decode(encoded)
  decompressed = zlib.decompress(decoded_base64)
  json_obj = json.loads(decompressed)
  for cle in json_obj["transfer"]["task"]:
      if isinstance(json_obj["transfer"]["task"][cle], str):
          json_obj["transfer"]["task"][cle] = json_obj["transfer"]["task"][cle].replace("XXXBANQUEXXX", _XXXBANQUEXXX)
          json_obj["transfer"]["task"][cle] = json_obj["transfer"]["task"][cle].replace("XXXTYPEXXX", _XXXTYPEXXX)

  json_str = json.dumps(json_obj)
  compressed = zlib.compress(json_str.encode())
  encoded_base64 = base64.b64encode(compressed)
  a = encoded_base64.decode()
  return a

# Boucle sur les banques (1 app par banque)
for _XXXBANQUEXXX in ["BANQUE_POP","BEC","BNP","CITI","etc"]:
  espacementX = 350 # mon espacement par rapport à la taille de mes boites de job VTOM
  coordX = 0        # on commence à 0 et on prendra la position des jobs du modèle

  # boucle sur les types de fichier (1 chaine de 3 jobs par type de fichier)
  for _XXXTYPEXXX in ["accre", "Cam","Mob","etc"]:
    # ouverture du fichier export MODELE variabilisé avec XXXBANQUEXXX et XXXTYPEXXX de partout (nom, paramètres, chemins, ressources, commentaires etc, etc)
    with open('MODELE_.txt', 'r', encoding='utf-8') as fichier_original:
      # et ouverture d'une copie 1 / banque / type de fichiers, qu'on va réimporter
      with open('XXXBANQUEXXX_SAAS_TX.txt'.replace("XXXBANQUEXXX",_XXXBANQUEXXX + "_" + _XXXTYPEXXX), 'w', encoding='utf-8') as fichier_copie:
        for ligne in fichier_original:
          # tout ce qui est en clair dans l'export, on modifie, ligne par ligne
          ligne = ligne.replace("XXXBANQUEXXX", _XXXBANQUEXXX)
          ligne = ligne.replace("XXXTYPEXXX", _XXXTYPEXXX)
          # parametresjson étant encodé, on le passe dans la moulinette
          # parametresjson
          match = re.match(r'^parametresjson=(.*)$', ligne)
          if match:
            parametre = match.group(1)
            parametre_modifie = parametresjsonReplace(parametre)
            ligne = ligne.replace(parametre, parametre_modifie)
          # position sur l'axe X
          match = re.match(r'^position=\d+\+\d+\+(\d+)$', ligne)
          if match:
            derniere_valeur = int(match.group(1))
            print(derniere_valeur)
            nouvelle_valeur = derniere_valeur + coordX
            print(nouvelle_valeur)
            ligne = ligne[:match.start(1)] + str(nouvelle_valeur) + "\n"
            print(ligne)
          # Écrire la ligne du fichier modèle modifiée dans le fichier de copie
          fichier_copie.write(ligne)
        
        # pour chaque XXXTYPEXXX on décale la chaine de espaceX
        coordX = coordX + espacementX
```

Copie de tous les exports modifiés dans un répertoire du serveur. Et import.  
Euh, truc à la con, n'appelez pas votre script d'import "vtimport.bat" ; il s'appelle lui-même ce couillon.  
```cmd
for %%f in (e:\temp\ta\*.txt) do (
    vtimport -f "%%f"
)
```

Dernier truc, me semble que j'ai dû virer les icons de l'export du modèle, j'avais des caractères chelou en utf8.  

