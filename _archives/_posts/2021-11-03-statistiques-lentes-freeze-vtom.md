---
layout: post
title: Statistiques VTOM Lenteurs
date: 2021-11-03 12:00:00
author: Virtual Thom
categories: [statistiques, lenteur, freeze, Visual TOM, VTOM]
---
S'il y a encore des irréductibles Gaulois en v5.8 (ou moins de v6 - han je suis choqué), vous avez peut-être remarqué que votre base grossit, et les requêtes sur les statistiques VTOM (purges ou visu) sont très lentes et / ou freezent l'IHM - malgré vos purges `vtstools` régulières.  

Solution : faire un petit réinit de la base en bonne et dûe forme. Franchement ça change la vie. (passé d'une base de 16Go à moins de 2Go, plus de freeze, requêtes instant)  
 * arrêt des moteurs,
 * vtbackup,
 * stop services vtserver et vtsgbd,
 * save du rep BASES actuel - ceinture et bretelles,
 * suppression BASES/*,
 * copie du contenu vtbackup/ dans BASES/
 * démarrage vtsgbd (attendre dans les logs traces que la resto soit ok)
 * démarrage vtserver
 * démarrage des moteurs

Sinon, en v6, ils ont rajouté l'option `/clean` dans `vtstools` :  
```
 /clean                  (ou -c) libere l'espace disque recuperable   all | date_count | job | job_occ | current
                         plusieurs valeurs peuvent etre saisies en    | realtime
                         les separant par une virgule
```
