---
layout: post
title: Représentation graphique Nom + Commentaire
date: 2017-08-08 22:00:01
author: Virtual Thom
categories: [VTOM, graphique, commentaire]
---
Mise à jour 20/04/18 !

Bon en fait mon astuce est nulle ! Absyss nous avait déjà tout pré-mâché et avait prévu le menu contextuel qui va bien.

Testé en version 5.7

Représentation graphique (app, job) > clique droit dans le champ "Texte" et vous avez toutes les variables !

![VTOM Représentation Graphique Zone Texte](/wp-content/uploads/commentaires_representation_graphique.JPG)

... old post

Vous n'êtes pas sans savoir que l'on peut changer le mode d'affichage dans l'IHM en cliquant droit dans le vide > Afficher et en choisissant parmis ce qu'on nous propose :

![VTOM IHM Afficher](/wp-content/uploads/vtom_ihm_afficher.jpg)

Mais quand on est pénible comme moi, on aimerait bien avoir le Nom + Commentaire par exemple. Et ça ne nous est pas proposé ! 

Qu'à cela ne tienne, on peut changer la représentation graphique (soit du/des noeuds, soit du graphique par défaut).

![VTOM IHM Représentation Graphique](/wp-content/uploads/vtom_ihm_representation_graphique.jpg)

```
<html>
{prefix}<b>{name}</b>{suffix}<br>{comment}
</html>
```

Et ça nous donne ce joli graphique :

![VTOM IHM Afficher Commentaire](/wp-content/uploads/vtom_ihm_afficher_commentaire.jpg)

Encore eût-il fallu qu'on le susse !

Après si vous êtes joueur comme moi, vous testez d'autres variables :

```
<html>
{prefix}<b>{name}</b>{suffix}<br>{comment}<br>{host}
</html>
```


Mise à jour 06/03/18 ! Bon en fait, Absyss nous met même un exemple sur sa base de démo

![VTOM IHM Base de démo Absyss](/wp-content/uploads/vtom_ihm_base_demo.jpg)

```
<html>
<font size='3'>
<center>
{prefix}<b> {name} </b>
<br>
Début : {statExecBeginHourAvg} - Durée : {statExecTimeAvg}
<br><br>
{comment}
</center>
</font>
```


