---
layout: post
title: VTOM export consigne html - Docker et python 
date: 2016-02-27 08:44
author: Virtual Thom
categories: [ordonnancement, vtom, astuce, consignes, python, docker]
---
Voici mon premier Tuto en image ! soyez indulgents :) 
Si ça plait, j'en ferai d'autres (mieux, avec le son etc)

Ce tuto permet d'exporter les consignes VTOM et d'appréhender Docker.

J'utilise Docker pour l'environenemnt de test (voir mon tuto sur Docker : [Environnement de test VTOM avec Docker]({{ site.baseurl | prepend: site.url }}/docker-installation-serveur-vtom-test/) )

Et python pour le code d'export des consignes VTOM.

<iframe width="560" height="315" src="https://www.youtube.com/embed/QfWva3NoZCE" frameborder="0" allowfullscreen></iframe>

### Code et commandes utilisés : 

```bash
# construire l'image à partir du DockerFile
docker built <répertoire>

# lister les images docker
docker images

# lancer un conteneur de votre image en interactif tty et en redirigeant les ports de votre machine vers le conteneur (IHM)
docker run -ti -p 30007-30008:30007-30008 <nomImage|ID>

# les instances de container qui sont en cours
docker ps

# connaitre l'adresse IP de votre machine docker (utile sous Windows)
docker-machine ip

# pour donner un nom à votre image
docker tag imageID imageName

# pour supprimer l'image
docker rmi -f monImage

# Export de la base VTOM en xml
vtexport -x > /var/tmp/vtexport.xml
```

```python
import encodings
from lxml import etree
tree = etree.parse('/var/tmp/vtexport.xml')

for Instruction in tree.xpath('/Domain/Instructions/Instruction'):
		nameFileConsigne = Instruction.get('name')
		for Content in Instruction.xpath('Content'):
			f = open(nameFileConsigne +  ".html","w")
			s = Content.text
			s = s.decode('base64').decode('zlib')
			f.write(s)
			f.close
```


Au fait, comment j'en suis arrivé là ?!

C'est sur la demande d'un client qui voulait toutes les consignes VTOM.

J'ai vraiment galéré pour décoder les consignes qui sont encodées.

En fait, ma piste a pris le bon chemin quand j'ai fait un `strings $TOM_BIN/vthttpd` car j'ai vu que le web access le décodait à la volée. Et là, on voit qu'il y a du `abs_zipbase64` et du `base64Binary`.

Autant le base64, c'était assez clair, la chaîne avait une bonne tête de base64.

Autant, je peux vous dire que j'en ai essayé des encodages pour trouver le zlib ! et j'ai perdu mon temps sur les sites de décodages du net car ils me supprimaient des caractères à chaque fois.

Heureusement que python est là !

A l'inverse, si vous voulez intégrer massivement des consignes à partir de fichiers html, c'est possible - à vos risques et périls, testez toujours en environnement de test -  en encodant en ('zlib') puis en ('base64') et en intégrant un node &lt;Instruction&gt; dans le vtexport.xml.

```python
import encodings
import sys
f = open("monfichier.html","r")
s = f.read()
s.encode('zlib').encode('base64')
sys.stdout.write(s)
```

```
(attention aux sauts de ligne, ils sont importants)
eJyzyTC0c8rPy8ovLVLwKc1OVVC00QcKcdkU2HmlKhSXZhYrlOTnKdgk2QW8KEq10U8CSukX2HEB
APm2EWI=
```

```
<Instructions>
...
  
    <Instruction name="MA_CONSIGNE_1" comment="ceci est un commentaire">
      <Content><![CDATA[eJyzyTC0c8rPy8ovLVLwKc1OVVC00QcKcdkU2HmlKhSXZhYrlOTnKdgk2QW8KEq10U8CSukX2HEB
APm2EWI=]]></Content>
    </Instruction>
...
</Instructions>
```

Pour le web access si ça vous intéresse, regarder mon tuto [Web Access API VTOM]({{ site.baseurl | prepend: site.url }}/api-vtom-web-access/)  : 

```
api/instruction/getAll 
```
