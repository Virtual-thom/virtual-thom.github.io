---
layout: post
title: Control-M Premiers ressentis après 2 semaines d'utilisation
date: 2015-11-15 11:30
author: Virtual Thom
categories: [ordonnancement, Control-M]
---
Après les premiers jours de formation sur Control-M, j'étais très enthousiaste !

Je ne sais pas si c'était la nouveauté ou les possibilités natives du produit qui m'ont séduites mais, au début, j'étais conquis.

Ce que j'ai apprécié (v8 pour info) :

* le Do Action : on peut parser la log output directement, ajouter des conditions poussées, dire que le job est OK ou KO sur certaines conditions etc. etc.
* les liens : les liens sont textuels (même s'il y a une représentation graphique) ! alors c'est bien et c'est pas bien (parceque ça complique) mais je trouve ça très puissant
* les cycles : beaucoup d'options sympathiques (on peut relancer le cycle sur le début, la fin d'exécution par exemple), on peut spécifier le nombre de reruns etc.
* le module "planning" : c'est là qu'on effectue la conception et modélisation des jobs. Je trouve le module bien fait, on peut s'attribuer l'exclusivité de modification d'un folder, n'appliquer les modifications que lorsqu'on le souhaite etc.
* Les champs scripts "command line" : on peut écrire les commandes en ligne directement dans un champ texte
* les variables qu'on peut utiliser directement dans les commandline, ou dans les paramètres
* les modifications qu'on ne peut effectuer que sur le plan en cours
* module d'interface avec SAP pratique : on peut lister et sélectionner les programmes ABAP et variantes directement

Bon, le problème, c'est le reste de la semaine et la semaine d'après ... Quand j'ai commencé à utiliser le produit réellement pour modéliser et régler les premiers problèmes d'exploitation.

Ca fait deux semaines que je pète un câble sur l'exploitation de control-m. 

Par exemple, on ne peut pas voir le plan dans sa globalité. On ne voit que le plan du jour dans le module "Monitoring" ou les plans passés dans le module "History", a moins de faire du "Forecast" (en gros on monte fictivement un plan à une date future donnée).

Autre exemple, on ne peut voir les log d'exécution que de la journée en cours dans le "Monitoring". Pas moyen, non plus de voir le script en direct depuis l'outil ...


Le pire reste la visualisation du plan :

Imaginez que toutes les applications de tous vos environnements VTOM se retrouvent dans un seul et même plan et que la disposition ne soit pas définie comme vous le souhaitiez (un peu n'importe comment d'ailleurs) et que les liens partent dans tous les sens.

Après deux semaines d'intense utilisation sur Control-M pour un nouveau projet (migration de TNG à Control-M), je reviens sur mes premiers instants de découverte pendant lesquels j'ai vraiment apprécié le produit. 

Autant j'apprécie toujours la conception et les possibilités de Control-M, autant l'exploitation et l'utilisation quotidienne du produit est une vraie tannée (surtout que mon Control-M Desktop plante toutes les 10 minutes et présente des lenteurs vraiment contraignantes).

Au final, rien qu'on ne puisse pas faire avec VTOM si ce n'est quelques lignes de code pour gérer tel ou tel envoi de mail ou parsing de log pour pallier aux options natives de Control-M. 

Bref, vive VTOM !
