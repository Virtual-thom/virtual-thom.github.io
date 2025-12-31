---
layout: post
title: tremote vtcopy transfert via VTOM
date: 2017-12-13 20:14
author: Virtual Thom
categories: [tremote, vtcopy, vtom]
---
edit 2025 : le tremote n'existant plusv version ps1 du vtcopy par exemple pour transferer un vtexport.xml d'un serveur vtom vers un agent : 
 * job à lancer depuis l'agent du serveur VTOM
 * params :
     * source (chemin du fichier à copier depuis l'agent du job)
     * dest (chemin répertoire de destination sur l'agent en 3ème param
     * nom de l'agent sur lequel transférer le fichier
  

```ps1
<#
vtcopy.ps1
Transfert d'un fichier via VTOM
Doit être exécuté dans un environnement VTOM
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$FIC_SOURCE,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$REP_DEST,

    [Parameter(Mandatory = $true, Position = 2)]
    [string]$AGENT

)

# Vérification du nombre de paramètres
if ($PSBoundParameters.Count -lt 3) {
    Write-Host "1 parametre = chemin complet du fichier source"
    Write-Host "2 parametre = chemin complet du repertoire de destination"
    Write-Host "3 parametre = agent vtom de destination"
    exit 123
}

$TOM_REMOTE_SERVER_OLD=$env:TOM_REMOTE_SERVER
$env:TOM_REMOTE_SERVER=$AGENT

$cmd = "vtcopy -i `"$FIC_SOURCE`" -o `"$REP_DEST`""

# Exécution de la commande
Invoke-Expression $cmd

# Vérification du code retour
if ($LASTEXITCODE -ne 0) {
    Write-Host "Erreur lors du transfert (code retour = $LASTEXITCODE)"
    exit $LASTEXITCODE
}

$env:TOM_REMOTE_SERVER=$TOM_REMOTE_SERVER_OLD

Write-Host "Transfert terminé avec succès"
exit 0
```


Exemple de script de transfert via VTOM avec tremote et vtcopy
```sh
#!/bin/ksh
# tremote_vtcopy.ksh
# Transfert d'un fichier via VTOM
# doit etre execute en vtom

FIC_SOURCE="$1"
REP_DEST="$2"
SRV_DEST="$3"
SRV_PORT="$4"

if test $# -lt 3;then
	echo "1 parametre = chemin complet du fichier source"
	echo "2 parametre = chemin complet du repertoire de destination"
	echo "3 parametre = nom serveur client VTOM de destination"
	echo "4 parametre (facultatif) = port du client bdaemon du serveur de destination"
	exit 123
fi

if test "$SRV_PORT" -ne "";then
	export TOM_PORT_bdaemon=$SRV_PORT
fi

rm ${SRV_DEST}.err ${SRV_DEST}.out 2> /dev/null
echo "tremote /machine=$SRV_DEST vtcopy -i $FIC_SOURCE -o $REP_DEST"
tremote /machine=$SRV_DEST vtcopy -i $FIC_SOURCE -o $REP_DEST
cat ${SRV_DEST}.*
grep "vtcopy exited with status 0" ${SRV_DEST}.out
if test $? -ne 0; then
	echo "Erreur lors du transfert"
	exit 10
fi
```
