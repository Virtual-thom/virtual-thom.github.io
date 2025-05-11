---
layout: post
title: Shell Lister tous les fichiers sauf les x derniers
date: 2015-08-27 22:58
author: Virtual Thom
categories: [unix, shell, bash, lister fichiers, ls, head, awk]
---

```bash
(ls -1t | head -n 2; ls) | sort | uniq -u
```

head -n 2 affiche les deux premières lignes du ls (-t pour trier par date, les plus vieilles en tête)

uniq -u supprime les lignes identiques


Ou plus simple avec awk, mon préféré :

```bash
ls -t | awk 'NR > 2'
```
 
