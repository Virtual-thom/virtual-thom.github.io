---
layout: post
title: Purge des modifications temporaires VTOM
date: 2021-09-17 12:00
author: Virtual Thom
categories: [powershell, Visual TOM, VTOM]
---
Script powershell ps1 de Purge des modifications temporaires (applications et jobs) qui sont déjà passées -3 jours.
```powershell
foreach($type in "app","job"){
	$items = & tlist "$($type)s_mdf"
	foreach ($item in $items){
		$dateFinMdf = [datetime]::parseexact($item.split("/")[-1], "dd-MM-yyyy",$null)
		if($dateFinMdf -lt (get-date).AddDays(-3)){
			& vtdel$($type) /name "$item"
		}
	}
}
```
