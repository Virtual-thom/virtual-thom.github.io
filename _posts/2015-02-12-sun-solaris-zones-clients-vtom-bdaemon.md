---
layout: post
title: Clients VTOM zones Solaris 
date: 2015-02-12 22:14
author: Virtual Thom
categories: [sun, solaris, zones, bdaemon, Visual TOM, clients VTOM]
---
Sur les superclusters Solaris, il ne faut pas faire un simple `ps -eaf | grep bdaemon` sous peine de voir tous les clients VTOM de toutes les zones (sortes de guest) du supercluster. 

Le plus drôle arrive si on commence à kill les bdaemon des zones depuis le supercluster en croyant que c'était des bdaemons zombies, ça kill vraiment le client VTOM sur la zone.

C'est pourquoi il vaut mieux effectuer la commande `ps -flz global |  grep bdaemon` pour afficher les process du supercluster et, `ps -flZ | grep bdaemon` pour voir tous les clients et les zones associées.

Autres commandes pratiques pour voir les zones : 
`zoneadm list` 

Si global ==> supercluster, si plusieurs lignes avec des hostnames, ce sont les zones du supercluster.

Si une seule ligne avec le hostname ==> zone