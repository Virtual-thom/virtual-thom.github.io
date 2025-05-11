---
layout: post
title: tremote vtcopy transfert via VTOM
date: 2017-12-13 20:14
author: Virtual Thom
categories: [tremote, vtcopy, vtom]
---
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
