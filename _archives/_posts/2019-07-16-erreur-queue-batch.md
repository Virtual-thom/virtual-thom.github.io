---
layout: post
title: Erreur nouvelle queue windows
date: 2019-07-16 18:00:00
author: Virtual Thom
categories: [vtom, queue]
---

Note à moi-même, nouvelle queue sur un client windows, vérifier l'encodage.

J'ai ce genre d'erreur avec l'encode UTF-8 with BOM (réglé en changeant en UTF-8 tout court)

```
C:\WINDOWS\system32>﻿@echo OFF 

C:\WINDOWS\system32>echo ______________________________________________________________________ 
______________________________________________________________________

C:\WINDOWS\system32>echo Contexte Visual TOM du traitement 
Contexte Visual TOM du traitement

C:\WINDOWS\system32>echo.
```

avec l'erreur :

```
'﻿@echo' is not recognized as an internal or external command, operable program or batch file.
```

