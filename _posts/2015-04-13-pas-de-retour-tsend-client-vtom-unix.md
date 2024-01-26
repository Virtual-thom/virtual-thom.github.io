---
layout: post
title: Pas de retour tsend client vtom unix
date: 2015-04-13 19:58
author: Virtual Thom
comments: true
categories: [pas de retour tsend, tsend, vtom, client vtom unix]
---
Il peut arriver qu'un traitement s'exécute bien (code retour 0 terminé OK) mais qu'on n'ait pas de retour tsend sur VTOM (terminé en erreur)

Si le retour s'effectue bien avec l'utilisateur de soumission "vtom" ou "root" mais pas pour les autres utilisateurs, il y a de grandes chances que les droits du répertoire spool ne soient pas en 777 comme ils devraient l'être.
