---
layout: post
title: VTOM ajouter une ressource en mode commande 
date: 2015-07-22 23:40
author: Virtual Thom
comments: true
categories: [vtom, vtaddjob, ressource vtom]
---
## ajout/modification/suppression d'attente de ressource sur app ou job
Le vthelp vtaddjob n'est pas très intuitif.
Voici un exmple pour rajouter (+) une ressource texte VTOM avec les options d'attente indéfiniment.

`vtaddjob /nom=env/app/job /script='monscript' /res="+nom_ressource = OK [attend==oui jusqu'a==Illimité]"`


 * Modifier (~) une ressource de type poids en ligne de commande avec libération

`vtaddapp /nom=$ITEM_VTOM /Res="~${ITEM_VTOM_RES} ! 1 [attend==oui jusqu'a==Illimité liberation==oui]"`

 * Remplacer une ressource de type fichier par une autre (P présent)
 
 `vtaddjob /nom=$ITEM_VTOM /res="-${OLD_RESS} P,+${NEW_RESS} P [attend==oui jusqu'a==Illimité]"`

exemple de changement de masse sur des jobs. Retrait d'une ressource poids et ajout d'une autre (prend 1, libère et attente illimité) :

```
tlist jobs -f MONENV | egrep -i "UNPATTERN.*I2" | awk '{printf"vtaddjob /nom=%s/%s/%s /res=\"-P_ENV_00_PARAOAG P, +P_ENV_00_PARAING ! 1 [attend==oui jusqu'"'"'a==Illimite liberation==oui]\"\n",$1,$2,$3}'
# donne
vtaddjob /nom=MONENV/UNEAPP/UNPATTERNXXXI2 /res="-P_ENV_00_PARAOAG P, +P_ENV_00_PARAING ! 1 [attend==oui jusqu'a==Illimite liberation==oui]"
(...)
```

## ajout/modification/suppression ressource vtom
```
vtaddres  -  ajout ou modification d'une ressource globale

Usage:
 vtaddres /name <nom_ressource> [options]

Exemples :
 vtaddres /name rgen /type gen /value jobok.bat /host localhost /user myUser /parameter 1,2
 vtaddres /name rpil /type pil /value 1,2
 vtaddres /name rpil /type pil /value ""


Liste des options :

 Parametres    Caracteristiques
 ------------- -----------------------------------------------------------------------------------
 /help         (ou -h) affiche l'aide
 /name         (ou -n) nom de la ressource
 /type         (ou -y) type (poi|pil|tex(defaut)|num|fic|gen)
 /value        (ou -v) script pour les ressources generiques, valeur pour les autres types
 /host         (ou -o) machine (ressources generiques seulement)
 /user         (ou -u) utilisateur de soumission (ressources generiques seulement)
 /parameter    (ou -p) parametres (ressources generiques seulement)
 /max          (ou -m) valeur maximum pour les ressources poids
 /att_ALL_env  (ou -t) attachement a tous les environnements
 /det_ALL_env  (ou -e) detachement de tous les environnements
 /att_env      (ou -a) attachement aux environnements de la liste
 /det_env      (ou -d) detachement des environnements de la liste
 /sepopt       (ou -s) separateur utilise dans les listes

Remarques :
 Les attachements et detachements sont possibles en meme temps.
 Les attachements sont effectues avant les detachements. En cas de conflit, le resultat est le detachement.
 Les options /att_ALL_env et /det_ALL_env s'excluent mutuellement.
 L'option /sepopt=# permet d'indiquer un caractere separateur pour les listes, autre que la virgule (par defaut).
 Attention, cette option doit etre utilisee avant toutes celles qui contiennent des listes pour etre operationnelle.

 IMPORTANT : LA COMMANDE VTADDRES NE PERMET PAS LA GESTION DES RESSOURCES DE TYPE DATE.
```

```
vtdelres  -  suppression d'une ressource

Usage:
 vtdelres /name <nom_ressource>

Exemple :
 vtdelres /name res_1

Liste des options :

 Parametres    Caracteristiques
 ------------- --------------------------------------------------------------------------
 /help         (ou -h) affiche l'aide
 /name         (ou -n) nom de la ressource
 /force        (ou -f) supprime les references si la ressource est liee uniquement aux
               environnements
 /purge        (ou -p) suppression des ressources non utilisees

Remarque :
 Si la ressource est liee a d'autres objets, elle ne pourra pas etre supprimee.
```
