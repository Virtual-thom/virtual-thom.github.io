---
layout: post
title: Port 30004 encore en LISTENING malgré l'arrêt du client VTOM
date: 2015-10-30 20:21
author: Virtual Thom
categories: [client VTOM, port, 30004, WerFault.exe, bstat, LISTENING, VTOM]
---

J'ai eu ce bug récemment : je stoppe le client VTOM, je le restart et plus aucune communication n'est possible.

## Symptômes
* Le `bstat` pour connaitre le statut du client VTOM ne répond pas.
* Client à STOP dans le suivi des clients VTOM.
* `netstat -ano | grep 30004` donne des ports en LISTENING alors que le bdaemon est arrêté et les process ID n'existent plus

## Solution :
kill les process WerFault.exe (passer en surbrillance sur le process et vous verrez les PID donnés dans le `netstat -ano`)

Ca vous permetra de ne pas reboot votre serveur pour rien !
