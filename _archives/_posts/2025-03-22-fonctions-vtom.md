---
layout: post
title: Fonctions VTOM
date: 2025-03-22
author: Virtual Thom
---
Les fonctions VTOM, c'est une sacré dinguerie quand même, j'étais complètement passé à côté (sorties en v71 vers là à priori).  
![Fonctions VTOM]({{ site.baseurl | prepend: site.url }}/assets/img/fonctions_vtom.png)  

Quelques infos en vrac :  
* documentation ici pour la 721e : [Formules de calcul et fonctions](https://docs.absyss.com//vtom/721e/fr/Visual_TOM_Guide_Utilisateur/#formules-de-calcul)
* fonctionne avec les variables de contexte `={$mavardecontexte AST UPPER}` par ex.
* c'était déjà implémenté sur le user portail, ça vient de là
* ça fonctionne dans tous les champs textes de tous les types de Traitement (paramètres de jobs, ou champ dans un job de transfert par ex) sauf le champ du chemin de script externe (pour info, dans ce champ les contextes fonctionnent)
* c'est évalué par le vtapiserver (et non pas le moteur) avant d'être envoyé au client - à ce propos, j'ai essayé sur mon pc avec docker, il a fallu rajouter `[vtapiserver] hostname=apiserver` dans le vtom.ini pour que ça fonctionne, thx Duke
