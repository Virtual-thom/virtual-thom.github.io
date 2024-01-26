---
layout: post
title: Psexec et VTOM sur Windows 2008 r2 x64 
date: 2013-09-05 10:46
author: Virtual Thom
comments: true
categories: [Cmd, OS, Script, VTOM, Windows]
---
Commande non reconnu par le système :
Si le programme psexec n'est pas reconnu en passant par VTOM (même en mettant le path dans les variables d'environnement ou full path dans un script), il faut installer le psexec.exe dans %systemroot%SysWOW64 au lieu de system32. 

