---
layout: post
title: Ressource pile
date: 2016-08-18 22:03
author: Virtual Thom
categories: [ordonnancement, vtom, ressource pile, ressource VTOM]
---
# Lister le contenu de la ressource pile VTOM

`tpush -name <nom ressource pile> -info`

```
valeur         : 1
contenu:
1
2
3
```

Le problème, c'est qu'on a des informations qu'on ne souhaite pas forcément. Pas très pratique pour faire une boucle for par exemple.

On filtre avec `awk` tous les élements de la ressource pile VTOM qui sont après le mot `contenu` et où la ligne n'est pas vide (dernière ligne vide dans le résultat de mon `tpush`)

```powershell
tpush -name <nom ressource pile> -info | select -skip 3  | select-string -NotMatch "^$"
```

```bash
tpush -name <nom ressource pile> -info | awk '\
BEGIN{ligneContenu="x";nbValues=0;}\
($1 ~ /contenu/ || NR > ligneContenu) && $0 != ""\
{\
if(ligneContenu == "x"){ ligneContenu = NR ; next } ;\
print $0;\
}'
1
2
3
```

# Compter le nombre d'éléments dans la pile
```powershell
(tpush -name <nom ressource pile> -info | select -skip 3  | select-string -NotMatch "^$").count
```

```bash
tpush -name <nom ressource pile> -info | awk '\
BEGIN{ligneContenu="x";nbValues=0;}\
($1 ~ /contenu/ || NR > ligneContenu) && $0 != ""\
{\
if(ligneContenu == "x"){ ligneContenu = NR ; next } ;\
nbValues++;\
}\
END{print nbValues}'
3
```

# Afficher le premier élément de la ressource pile VTOM

`tval -name <nom ressource pile>`

# Vider le premier élément de la ressource pile VTOM

```
tpop -name <nom ressource pile>
OK: <nom ressource pile>

# le premier élément 1 que j'avais dans ma pile a été supprimé
tpush -name <nom ressource pile> -info
valeur         : 2
contenu:
2
3
```

# Ajouter un élément à la fin de la ressource pile VTOM

```
tpush -name <nom ressource pile> -value 1
OK: 1

# la valeur 1 a été rajoutée en fin de pile
tpush -name <nom ressource pile> -info
valeur         : 2
contenu:
2
3
1
```

# Vider tous les éléments de la ressource pile VTOM

`tempty -name <nom ressource pile>`

# A quoi ça sert ?

## Dans VTOM

### Une ressource pile VTOM peut être attendue sur une application ou un traitement

* Présent = au moins un élement dans la pile
* Absent = aucun élément dans la pile

`mis à jour sur mon v5.7, on dit "Vide" et "Non vide" au lieu de présent/absent (plus logique remarquez)`

Pratique par exemple pour exécuter une cyclique autant de fois que qu'il y a d'éléments dans une pile.

`Sur une remarque de nagnag, je me rends compte que ce que je dis peut prêter à confusion. La pile ne se décharge pas automatiquement à chaque exécution de la cyclique. C'est bien un mécanisme perso par tpop (via un job/script) qui doit dépiler à chaque cycle.`


Autre exemple plus tordu : on a une pile initialisée avec `n` éléments (avec n = nombre de couloirs attendus, ces couloirs sont sur des environnements ou des serveurs VTOM différents par exemple), à chaque fois qu'un couloir (une chaine) est terminé, on dépile d'1 élément la ressource ; une autre chaine attend que les `n` couloirs se soient exécutés (la tête de chaine attend la ressource pile à `Absent`)

### Une ressource pile VTOM peut être ajoutée en tant que paramètre d'un traitement

Le traitement peut prendre en paramètre la ressource pile qui aura comme valeur le premier élément de cette dernière `{nomressource}`, on peut aussi vouloir le nom de la ressource plutôt que sa valeur `{nomressource,name}`.

## Dans les scripts

Et pourquoi pas ?

Exemple : à l'issue d'une sauvegarde, vous empilez le nom de la sauvegarde et son statut (un genre de clé:valeur, `tpush -name <nom de la ressource> -value "masave1:OK"`). à l'issue de toutes vos sauvegardes, ou le matin, vous faites un reporting en dépilant tous les élements (`tval` pour récupérer la valeur courante, `tpop` pour supprimer la valeur courante). Ainsi, par exemple, on peut envoyé par mail un tableau avec le nom de la sauvegarde et OK vert ou KO rouge.

# Les axes d'améliorations que j'aimerais voir

C'est bien dommage qu'on soit limité à `Présent` ou `Absent`. J'aimerais voir apparaître le `$#index [<>=!] value` et qui conditionnerait le lancement si le nombre total d'éléments ($#index) était égal (ou autre comparateur) à une certaine valeur (value).

Bien dommage aussi qu'on ne puisse pas supprimer l'index souhaité ou ajouter avant/après l'index souhaité, genre de `splice` (c'est du FIFO, premier arrivé, premier sorti)
