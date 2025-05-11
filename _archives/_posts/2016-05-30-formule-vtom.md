---
layout: post
title: Formules VTOM
date: 2016-05-30 12:00
author: Virtual Thom
categories: [ordonnancement, vtom, formule]
---
Je rassemble ici un recueil des formules VTOM qui valent le coup d'oeil.

Attention, une formule VTOM dépend du calendrier sur lequel elle s'appuie. (jours fériés et jour chômés)

 * Veille du premier jour ouvre mois : By Fred 

```
test{(aujourd'hui=1.jour.ouvr.mois-1.jour.cale) ou (aujourd'hui=dern.jour.cale.mois+1.jour.ouvr-1.jour.cale)}
```

 * Premier Lundi du mois s'il est ouvré, sinon le jour ouvré qui suit

```
test { (aujourd'hui=prem.lu.cale.mois et aujourd'hui=ouvr) ou (prem.lu.cale.mois=chom et aujourd'hui=prem.lu.cale.mois+1.jour et aujourd'hui=ouvr) }
```

version corrigée par Hervé G.

```
test { (aujourd'hui=prem.lu.cale.mois et aujourd'hui=ouvr) ou (prem.lu.cale.mois=chom et aujourd'hui=prem.lu.cale.mois+1.jour.ouvr ) }
ou plus "simple"
test { aujourd'hui>=prem.lu.cale.mois et aujourd'hui=ouvr et aujourd'hui-1.jour.ouvre<prem.lu.cale.mois}
```

 * premier jour ouvré du mois sauf en Janvier, et dernier jour ouvré de Décembre :
 
```
test{
(aujourd'hui = prem.jour.ouvr.mois et aujourd'hui <> janvier)
ou
(aujourd'hui = dern.jour.ouvr.annee)
}
```

 *  les lendemains de jour ouvré avec les dimanches chomés et les jours fériés de france. Calendrier = Dimanche chômés + jours fériés France
 
```
test{
 aujourd'hui - 1.jour.cale = ouvr
}
``` 

 * 2ème dimanche du mois
 
 ```
 test{ aujourd'hui = 2.di.cale.mois }
 ```
 
 
```
Syntaxe d'une expression: base[ +/- nnn.jour[.type] ]
base
aujourd'hui
ordre.jour.type.durée
jj.mm[.aa]
libellé_jour
libellé_mois
type
ordre
premier
dernier
xxx (quantième du jour dans la durée associée)
jour
jour
libellé_jour
libellé_jour
(lu)ndi
(ma)rdi
(me)rcredi
(je)udi
(ve)ndredi
(sa)medi
(di)manche
type
(ouvr)é
(chom)é
(cale)endaire
durée
(trim)estre
(sem)estre
(anne)e
(mois)
(quin)zaine
(sema)ine
(peri)ode[ nom de la période ]
libellé_mois
libellé_mois
(janv)ier
(fevr)ier
(mars)
(avri)l
(mai)
(juin)
(juil)let
(aout)
(sept)embre
(octo)bre
(nove)mbre
(dece)mbre
A noter:
pour l'ordre et les libellés jours et mois, seule la partie entre parenthèses est à inscrire
les espaces, tabulations et retours à la ligne sont facultatifs
les lignes commençant par « # »sont traitées comme des commentaires
tous les mots-clefs sont en minuscules non accentuées
il est possible d'ajouter des parenthèses pour regrouper les comparaisons afin d'établir les priorités entre les opérateurs logiques (« et » & « ou »).
Il est également possible d’étendre ce langage afin de décrire des contraintes de planification dans une terminologie propre à l’entreprise.
L’évaluation de la formule choisie se fera lors du contrôle de planification de l’application ou du traitement par le moteur de Visual TOM qui renverra un résultat de valeur VRAI ou FAUX.
Exemples:
# le dernier jeudi férié de l’année test {today=dern.je.chom.anne}
# les lundi fériés test {today=lu et today‹›ouvr}
# le premier jour ouvré du mois test {today=1.jour.ouvr.mois}
# le dernier jour ouvré de la semaine test {today=dern.jour.ouvr.sema}
# le vendredi avec report au jour ouvré suivant si férié test {today=4.jour.cale.sema+1.jour.ouvr} test {today=1.jour.cale.sema-4.jour.cale+1.jour.ouvr}
# le mercredi de la deuxième semaine complète test {today›8.jour.cale.mois et today‹15.jour.cale.mois et today=me}
# les jours ouvrés de janvier et fériés de décembre test {today=janv et today=ouvr} test {today=dece et today=chom}
# les jours fériés consécutifs qui précèdent un lundi test {today=chom et today+1.jour.ouvr=lu}
# les jours ouvrés du mois si le 1 est un lundi test {1.jour.cale.mois=lu et today=ouvr}
# les 3 derniers jours du mois s'ils sont ouvrés et si la semaine est incomplète test {today=dern.jour.cale.mois et today=ouvr et today‹›di} test {today=dern.jour.cale.mois-1.jour.cale et today=ouvr et today‹›sa} test {today=dern.jour.cale.mois-2.jour.cale et today=ouvr et today‹›ve}
# le jeudi qui précède le dernier jour ouvré du mois test {today‹dern.jour.ouvr.mois et today+8.jour.cale›dern.jour.ouvr.mois et today=je}
# le dernier jeudi ouvré du mois test {today=dern.je.ouvr.mois}
# les mardi et jeudi ouvrés test {today=ouvr et (today=ma ou today=je)}
# le 18 juin test {today=18.06}
 ```
