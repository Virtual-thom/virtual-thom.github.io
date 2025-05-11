---
layout: post
title: Compter le nombre de traitements VTOM par client
date: 2015-03-09 21:10
author: Virtual Thom
categories: [Visual TOM, VTOM]
---

Comment compter le nombre de traitements par client VTOM ?

Rien de bien sorcier :

```bash
#on liste tous les jobs et on redirige dans un fichier temporaire
tlist jobs > /var/tmp/tlistjobs

#on compte le nombre de lignes trouvées dans le fichier tlistjobs pour chaque client
tlist machine | while read machine
do
echo -e "$machine;"
nbJobs=`grep $machine /var/tmp/tlistjobs | wc -l`
echo -en "$nbJobs\n"
done
```
