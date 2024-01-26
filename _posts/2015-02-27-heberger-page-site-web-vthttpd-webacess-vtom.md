---
layout: post
title: Héberger une page web depuis vthttpd web access VTOM
date: 2015-02-27 22:14
author: Virtual Thom
categories: [webaccess, vthttpd, alias, VTOM, Visual TOM]
---

Comment héberger une page ou un site web depuis votre service vthttpd web access VTOM ? en utilisant les alias :

## Pré-requis
service WebAccess VTOM installé (vhttpd) 

## Configuration du webacces VTOM
Modifier le vthttpd.ini

```
httpAliases="/monsiteweb/=C:\VTOM5\WWW\monsiteweb\"
httpAllowedURI=/monsiteweb/*
```

Se rendre sur la page de votre webacces VTOM suivi de l'alias ex. `localhost:30080/monsiteweb/`
