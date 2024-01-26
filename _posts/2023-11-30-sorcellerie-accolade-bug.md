---
layout: post
title: Sorcellerie bug accolade dans param
date: 2023-11-30 12:00:00
author: Virtual Thom
---
v7.1.1b5  
Petit bug si `{` ouvrante dans un paramètre vtom (genre un mdp, oui je sais c'est mal). Quand vtom envoie dans la queue, on retrouve une accolade fermante } (en trop du coup).  
Sorcellerie de dev chez Absyss, palliatif qui fonctionne en tous cas, en attendant de résoudre, rajouter `E[]|` devant le paramètre en question.  
Ex.  
```
Dans l'onglet Param du job VTOM :
/mdp:"bonjour{tralala"

== bug on retrouve au final dans la queue / script :
/mdp:"bonjour{tralala"}

Palliatif :
E[]|/mdp:"bonjour{tralala"
```
D'ailleurs si vous voulez identifier vos jobs concernés, c'est un peu pénible car beaucoup de jobs avec param {} notamment pour les ressources. Pas si évident à chercher. Sinon `vtexport -x` et chercher la pattern regex `^.*{[^}]+$`, vous aurez les "test {" des formules de planning, vous excluez ça et vous avez vos vraies lignes.
