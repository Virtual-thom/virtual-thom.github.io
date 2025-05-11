---
layout: post
title: Microsoft Excel Microsoft Excel cannot access the file 
date: 2023-07-28 12:00:00
author: Virtual Thom
---
Vous essayez d'ouvrir un workbook Excel sans être connecté en session (que ça soit un script via VTOM ou TaskScheduler win) ?  
Ca fonctionne en étant connecté et en lançant le script à la main, mais pas via VTOM avec le message étrange qu'il ne trouve pas le fichier (alors qu'il existe bien) :  
Open c:\path\fichier.xlsx (clsMSExcel::Open)  
Microsoft Excel: Microsoft Excel cannot access the file  

Essayez : 
```
It's likely a DCOM permissions issue. Automating Excel is sometimes fraught with peril...

The only way I've found around issues such as this is to set Excel to run as a specific user through DCOM permissions.

Open Component Services (Start -> Run, type in dcomcnfg)
Drill down to Component Services -> Computers -> My Computer and click on DCOM Config
Right-click on Microsoft Excel Application and choose Properties
In the Identity tab select This User and enter the ID and password of an interactive user account (domain or local) and click Ok
Keeping it as the interactive user or the launching doesn't work with the task scheduler unfortunately, even when setting the task up to run under an account that has admin access to the machine.
```

A savoir quand même : impossible d'ouvrir Excel mainteant en session mais vos scripts seront automatisables via TaskSCheduler ou via VTOM.
