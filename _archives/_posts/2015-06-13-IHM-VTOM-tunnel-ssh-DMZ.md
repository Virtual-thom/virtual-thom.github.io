---
layout: post
title: IHM VTOM via un tunnel ssh
date: 2015-06-13 10:30
author: Virtual Thom
comments: true
categories: [vtom, IHM, console VTOM, tunnel ssh]
---
Enfin un truc fun ! (merci Stéphane pour l'astuce du tunnel)

Je suis sûr que ça vous est déjà arrivé d'avoir un serveur VTOM dans une DMZ (une zone démilitarisée sécurisée) et, de n'avoir que le port ssh d'ouvert pour vous connecter en putty au serveur.

Du coup, pas d'IHM VTOM sur votre poste de travail (IHM = Interface Homme Machine = console graphique d'admin et pilotage VTOM).

Qu'à cela ne tienne ! avec cette astuce, on peut créer un tunnel ssh de votre poste de travail vers votre serveur VTOM. On redirige alors tous les flux nécessaires (vtnotifier 30008 et vtserver 30007, ou les votres perso) de votre poste vers le serveur VTOM.

* Configurer le tunnel ssh avec les flux VTOM dans PuTTY

```
PuTTY Configuration > Connection > SSH > Tunnels :
Source Port = 30007
Destination = <@IP ou nom DNS du serveur VTOM>:30007 
==> Add
```

```
Source Port = 30008
Destination = <@IP ou nom DNS du serveur VTOM>:30008
==> Add
```

![Tunnel SSH pour IHM VTOM]({{ site.baseurl | prepend: site.url }}/assets/img/putty_Tunnels.jpg)

A vérifier, mais il faut peut-être rajouter les services dans %systemroot%\system32\drivers\etc\services 

```
vtserver 30007
vtnotifier 30008
```
(ou vos ports spécifiques)

* Se connecter au serveur VTOM avec PuTTY pour créer le tunnel ssh

Connexion classique. PuTTY Configuration > Session > Host Name (or IP) = @IP du serveur VTOM

Et "Open"

* Se connecter à VTOM via l'IHM depuis votre poste de travail

Ouvrir l'IHM VTOM, et mettre localhost au lieu du serveur VTOM. Et, voilà !
