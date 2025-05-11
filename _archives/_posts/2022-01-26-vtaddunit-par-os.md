---
layout: post
title: vtaddunit par OS
date: 2022-01-26 12:00:00
author: Virtual Thom
categories: [vtom,vtaddunit]
---
Pense-bête pour ajouter tous les agents d'un certain type d'OS dans une unité de soumission

```
# vtmachine, vtaddunit 6.5.1l
$portAgent=30004
vtmachine |Select-String $portAgent | convertfrom-csv -Delimiter "|" -Header "blank","Name","Hostname","Iv4","Agent Port","Agent SSL","Agent Status","OS","Agent Version" | Where-Object { $_.OS -match "^Win" } | ForEach-Object { & vtaddunit.exe /name="ALL_WIN" /mode="M" /agent="+$($_.Name.trim())" }
vtmachine |Select-String $portAgent | convertfrom-csv -Delimiter "|" -Header "blank","Name","Hostname","Iv4","Agent Port","Agent SSL","Agent Status","OS","Agent Version" | Where-Object { $_.OS -match "^Lin" } | ForEach-Object { & vtaddunit.exe /name="ALL_LIN" /mode="M" /agent="+$($_.Name.trim())" }
vtmachine |Select-String $portAgent | convertfrom-csv -Delimiter "|" -Header "blank","Name","Hostname","Iv4","Agent Port","Agent SSL","Agent Status","OS","Agent Version" | Where-Object { $_.OS -match "^AIX" } | ForEach-Object { & vtaddunit.exe /name="ALL_AIX" /mode="M" /agent="+$($_.Name.trim())" }
```
