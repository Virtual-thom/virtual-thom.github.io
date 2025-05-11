---
layout: post
title: Une autre façon de parcourir et rechercher des infos dans VTOM
date: 2024-01-10 09:00:00
author: Virtual Thom
---

Ex. Dates non utilisées dans aucun env
```powershell
# Charger le fichier XML dans une variable
[xml]$xml = Get-Content "vtexport.xml"

# Extraire tous les noms de dates
$dateNames = $xmlContent.Domain.Dates.Date | ForEach-Object { $_.name }

# Extraire tous les noms utilisés
$usedNames = $xmlContent.Domain.Environments.Environment.UsedDates.names -split ' '

# Trouver les noms de dates qui ne sont pas utilisés
$unusedNames = $dateNames | Where-Object { $_ -notin $usedNames }

# Afficher les noms non utilisés
$unusedNames
```
