---
layout: post
title: Répertoire courant VTOM Bdaemon 
date: 2019-03-02 19:00
author: Virtual Thom
comments: true
categories: [bdaemon, vtom, find]
---
Note à moi-même, le répertoire courant d'où sont lancés les scripts sur un client VTOM est celui d'où on lance le bdaemon (ou n'importe quel script le lançant ex start_bdaemon, /etc/init.d/vtom_bdaemon, $ABM_BIN/bdaemon etc)

Et ce, quelque soit le user de soumission.

On peut avoir ce genre d'erreur par exemple quand on lance le client VTOM bdaemon depuis une home dir en 700 /home/vtom (ex) :
`find: failed to restore initial working directory: Permission denied`

En fait, le `find` essaie de revenir au répertoire d'où il s'est lancé (et sur un 700 n'y arrive pas selon le user de soumission)

note à moi-même, éviter de lancer le client bdaemon depuis / :X ça peut être grave du coup
