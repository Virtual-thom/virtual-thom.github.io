---
layout: post
title: Rapport snapshots VMWare Powershell
date: 2015-06-13 09:19
author: Virtual Thom
comments: true
categories: [powershell,récupération des snapshots, vmware, get-vm, get-snapshot, vim.ps1]
---
```powershell

    Export-Console "C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\vim.psc1"
		import-module "C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1"
		Connect-VIServer -Server $script:VCENTER_SERVER -Protocol https -User $script:VCENTER_USER -Password $script:VCENTER_PASSWORD
		if($? -ne $True){
			fn_WriteLog "ERROR -- Impossible de se connecter au vCenter ${VCENTER_SERVER}"
			$script:vRC_CODE=20
			break
		}
		
		# Récupération des snaphots
		$script:SNAPSHOTS = get-vm |  foreach { $VM = $_ ; $_ } | get-snapshot | select VM,@{Label="VM Powerstate";Expression={$VM.PowerState}},Name,Description,@{Label="Size";Expression={"{0:N2}" -f ($_.SizeGB)}},Created
		# On tri selon les critères en paramètre 
		# et on filtre sur le ou les pattern
		$PATTERN = @()
		$script:SNAPSHOT_PATTERN | foreach { $_.getEnumerator() } | foreach { $PATTERN += "`$_." + $_.key + " -match `"" + $_.value + "`"" }
		$PATTERN = $PATTERN -join " -or "
		if($script:SNAPSHOT_SORT_DESCENDING){
			$script:SNAPSHOTS = $script:SNAPSHOTS | sort-object $script:SNAPSHOT_SORT_BY -descending | where-object { invoke-expression $PATTERN }
		}else{
			$script:SNAPSHOTS = $script:SNAPSHOTS | sort-object $script:SNAPSHOT_SORT_BY | where-object { invoke-expression $PATTERN }
		}
		
		if($? -ne $True){
			fn_WriteLog "ERROR -- Impossible de récupérer la liste des snapshots"
			$script:vRC_CODE=21
			break
		}
		
		# On se déconnecte
		Disconnect-VIServer -Server $script:VCENTER_SERVER -Force:$true -Confirm:$false
		
```
