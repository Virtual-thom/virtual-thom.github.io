---
layout: post
title: RPI4 WiFi wlan0 lost its ip address
date: 2022-11-08 12:00:00
author: Virtual Thom
---
Umbrel sur rpi4 utilise docker pour déployer ses applis. A priori, moi j'ai un problème avec le dhcpcd sur mon interface wlan0 qui perd régulièrement (toutes les 24h more or less) son adresse ip.  

Pour résoudre le problème :

```
# ajouter à la fin du fichier /etc/dhcpcd.conf
denyinterfaces veth*
```

```
The veth (virtual ethernet) devices are used in software-defined networking to pass data across network namespaces (e.g. between a host and a container).
https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking#veth

The veth interfaces you see are half of the pairs created by Docker, the other halves live in each container Docker runs.
Docker should manage these interfaces completely, but under Raspios dhcpcd tries to configure every interface that appears in the host.
So the denyinterfaces option makes sure dhcpcd leaves these interfaces and Docker alone.

If you don’t add the line, dhcpcd will likely interfere with Docker, causing load on the system and possibly disrupting networking completely.
```

```
# pour vérifier si vous avez ce problème, regardez ces logs
journalctl -u dhcpcd
 veth*: no IPv6 Routers available
 route socket overflowed - learning interface state
```

source [https://forums.raspberrypi.com/viewtopic.php?t=315363#p1886355](https://forums.raspberrypi.com/viewtopic.php?t=315363#p1886355)  

Petite astuce quand même si jamais vous voulez debug sans redémarrer le rpi et que vous n'arrivez plus à vous co en ssh :  
 * enable VNC sur le rpi
 * installer VNC Viewer sur votre PC
 * configurer une connexion avec le nom de votre rpi (hostname) + .local, exemple : raspberrypi.local
 * une fois co sur votre rpi via VNC, `sudo service dhcpcd restart`
 
 Pas sûr de comment ça fonctionne si c'est par adresse MAC ou ipv6 ou je ne sais quoi, mais ça fonctionne même quand j'ai perdu l'IPv4 local sur mon wlan0 (alors que je n'ai pas de câble ethernet de connecté et que je n'ai plus d'adresse ipv4 sur mon wlan0 ^^)
