---
layout: post
title: Lister les dates VTOM liées à plusieurs environnements
date: 2024-01-10 08:00:00
author: Virtual Thom
---
```
$data = vtlist env/date | ConvertFrom-Csv -Delimiter "`t" -Header ENV, DATE

$groupedData = $data | Group-Object DATE | ForEach-Object {
    [PSCustomObject]@{
        DATE = $_.Name
        ENV = ($_.Group.ENV | Sort-Object -Unique) -join ', '
    }
}

$sortedData = $groupedData | Sort-Object { ($_.ENV.Split(',').Count) } -Descending

$filteredData = $sortedData | Where-Object { ($_.ENV.Split(',').Count) -ge 2 }

$filteredData

```
