---
layout: post
title: Purge shell
date: 2018-02-13 20:14
author: Virtual Thom
categories: [purge, shell]
---
```shell
#!/bin/ksh
# Script de purge unix
# fichier de param nécessaire à passer en paramètre de ce script
# 1 ligne = une conf de purge (champs séparés par des ;)
# REP(chemin du répertoire);FIC_PATTERN(fichier(s) à supprimer, peut contenir des étoiles);RETENTION(en jour);VERSION(nombre de version gardée à minima - peut être 0)

FIC_PARAM=$1
export CR=0

# on peut mettre DEBUG à "true" pour ne pas réellement purger et passer le script en simulation
export DEBUG="true"

if ! test -s "$FIC_PARAM";then
    echo "[ERROR] Le fichier de param n'existe pas ou est vide"
fi

# on boucle sur le fichier param
while read ligne ; do

    # on saute les lignes vides ou commentées
    echo "$ligne" | egrep "^$" > /dev/null && continue
    echo "$ligne" | egrep "^#" > /dev/null && continue

    # on parse la ligne de conf
    REP=$(echo "$ligne" | cut -d";" -f1)
    FIC_PATTERN=$(echo "$ligne" | cut -d";" -f2)
    RETENTION=$(echo "$ligne" | cut -d";" -f3)
    export VERSION=$(echo "$ligne" | cut -d";" -f4)

    # on affiche la conf
    echo "[INFO] Purge de REP=$REP FIC=$FIC_PATTERN RETENTION=$RETENTION VERSION=$VERSION"

    # on vérifie que REP est un répertoire
    if test ! -d "$REP" -o -z "$REP"; then
        echo "[ERROR] $REP n'est pas un répertoire"
        CR=`$CR + 1`
        continue
    fi


    # on purge
    # on peut tomber sur une erreur si la liste de fichier à supprimer est trop grande à cause du ls
    # dans ce cas, supprimer ceci de la commande find : -exec ls -1td "{}" +
    # mais vous n'aurez plus l'assurance d'avoir garder les n $VERSION les plus vieilles
    export i=0
    find $REP -name "$FIC_PATTERN" -mtime "+$RETENTION" -exec ls -1td "{}" + | while read findLine; do
        i=`expr $i + 1`
        # on garde n version de fichiers
        test $i -le $VERSION && continue

        # on liste ou on purge selon DEBUG
        if test "$DEBUG" == "true";then
            ls -ld $findLine
        else
            rm -Rf $findLine || CR=`$CR + 1`
        fi
    done


done < "$FIC_PARAM"

test $CR -ne 0 && echo "[ERROR] Au moins une erreur dans le script de purge"

exit $CR
```
