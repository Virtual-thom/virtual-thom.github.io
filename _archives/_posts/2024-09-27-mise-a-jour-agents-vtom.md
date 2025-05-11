---
layout: post
title: Mise à jour des Agents VTOM via "Gestion des paquets vtom"
date: 2024-09-27 18:00:00
author: Virtual Thom
---
On n'a plus aucune excuse pour ne plus avoir nos agents vtom à jour avec la livraison par package vtom.  
Ci-après une façon de faire et mes problèmes rencontrés avec leurs workaround vus avec Absyss pour certains, d'autres, tout bête, mais tellement insuportable, genre des alias sur linux en root rm = rm -i (merci Stephan pour l'idée de résolution)  
<!--more-->
v712  
Bon déjà il faut le savoir, les paquets qu'on télécharge les VT-CS-(Linux|Win|AIX|etc).Z fournis par Absyss, sont utilisables directement tels quels.  
Le principe est de déposer dans votre répertoire de dépôt (sur le serveur VTOM) ces fichiers VT-CSxxx.Z.  
Outils > "Gestion de paquets" > Ajout d'un dépôt si ce n'est pas déjà fait qui pointe vers votre répertoire avec vos paquets sur le serveur VTOM.  

Ma façon de faire et solution palliative pour contourner les problèmes qui sont au nombre de 4 :
 * pas assez de place sur /opt/vtom pour la livraison pour les linux   ==> faire un bout de script dans le script de préinstallation pour rajouter de l'espace jusqu'à 2GO minimum dans mon cas
 * alias interactifs type rm == rm -i sous linux    ==> rajouter dans le script de préinstallation `unalias -a`
 * impossible de démarrer le vtmanager v712  sous Windows par manque de dll, et en réalité du paquet REDIST c++    ==> en fait, Absyss le donne en livraison, il suffira de le passer en prérequis avant livraison du paquet client
 * service Windows bdaemon AbsyssBatchManager qui pointe vers l'ancien emplacement `%ABM_HOME%\services\bdaemon.exe` au lieu du nouvel emplacement `%ABM_BIN%\bdaemon.exe`    ==> rajouter dans le script de préinstallation un regedit qui change l'ImagePath du service

Pour Windows, passer en une fois tous les agents le paquet en prérequis (c'est très rapide) VT-RDIST-WNTxx.Z  
puis sélectionner le paquet VT-CS-Winxxx.Z > modifier le paquet >  
* supprimer de l'arborescence les queues abm\bin\submit_queue_wnt.bat et ps1.bat qu'on a tous à peu près modifiées à notre sauce (notamment pour l'args loop à remplacer par $*) et qu'ils relivrent constamment dans leur paquet
* ajouter dans une ligne dans le cmd de pré-installation (cocher la case) `reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AbsyssBatchManager" /v ImagePath /t REG_SZ /d "%ABM_BIN%\bdaemon.exe" /f`
* construire le paquet, ça va créer un autre paquet que le VT-CS-WINxxx.Z qui est comme en lecture seule, `Visual TOM Agent-7.1.2e1 FR NT64 Windows.vtpk` autant le laisser avec ce nom
* Transférer un paquet, sélectionner tous les agents à mettre à jour > Transférer et basta (on peut suivre dans Outils > Suivre des installations des paquets > Recharger)

Pour Linux, le bout de script pour l'espace disque est vraiment pour un cas personnel à rajouter que sur les quelques vieux agents mals foutus que j'avais.  
Sélectionner le paquet VT-CS-Linxxx.Z > modifier le paquet >  
 * pour les mêmes raisons, supprimer de l'aborescence les queues "dites standard" admin/tom_submit.ksh sh bash etc
 * rajouter des lignes dans le script de pré-installation déjà existant

```ksh
# lignes à rajouter en début de script, spécifique à mon contexte
set -x ; # parceque j'aime bien voir ce qu'il se passe dans le compte rendu d'exécution dans "Suivre des installations des paquets"
unalias -a ; # pour pallier aux alias interactifs

FSVTOM="/opt/vtom" # toutes mes installs sont là mais à voir pour utiliser un autre path
MAX_SIZE="2000"
FSDEVMAPPER=$(df --output=source $FSVTOM | tail -1)
CURRENT_SIZE=$(df -m --output=size $FSVTOM | tail -1)
# Vérifier si la taille actuelle est inférieure à la taille minimale
if [ $CURRENT_SIZE -lt $MAX_SIZE ]; then
    echo "La taille de $FSVTOM est inférieure à 2 Go. Extension du système de fichiers..."
    # étendre le volume logique et le système de fichiers à 2 Go
    lvextend -r -L 2G $FSDEVMAPPER ; # dans le cas où il y a assez de free space à étendre, sinon malheureusement il faudra augmenter la taille des vg voire des pe etc
    echo "Extension terminée."
else
    echo "La taille de $FSVTOM est supérieure ou égale à 2 Go. Aucune action nécessaire."
fi
# ... laisser le reste du script bien sûr
```
 * construire le paquet, ça va créer un autre paquet que le VT-CS-Linxxx.Z qui est comme en lecture seule, `Visual TOM Agent-7.1.2e1 FR X64 Linux.vtpk` autant le laisser avec ce nom
 *  Transférer un paquet, sélectionner tous les agents à mettre à jour > Transférer et basta (on peut suivre dans Outils > Suivre des installations des paquets > Recharger)
   
Pour info, de ce que j'ai pu voir, ça ne fait pas planter les jobs en cours, ça garde le "log on as" pour windows, ça garde le vtom.ini, bref tout bien pour ma part.  
Je n'ai plus aucune excuse pour ne pas mettre à jour mes agents régulièrement !
