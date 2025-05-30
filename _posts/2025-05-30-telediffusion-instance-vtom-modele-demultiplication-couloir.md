---
layout: post
slug: telediffusion instance vtom modele demultiplication couloir
title: VTOM Télédiffusion Les instances Demultiplication par couloir
---
Le but : avoir un modèle d'application vtom et le démultiplier par couloir (ici des banques mais peu importe) grâce aux Instances en Télédiffusion VTOM v7.2.1e.

## Le Modèle
Il faut juste utiliser un pattern facilement reconnaissable. Par exemple, `XXXBANQUEXXX` (mais ça pourrait être `ZZ` pour démultiplier en couloir `01 02 03` par ex)  
![télédiffusion vtom instance vtom modèle demultiplication couloir](/assets/img/instance_01.PNG "télédiffusion vtom instance vtom modèle demultiplication couloir")  

A l'intérieur, je démultiplie aussi par `XXXTYPEXXX` pour me compliquer la tâche. On y reviendra dans les redflags.  
![télédiffusion vtom instance vtom modèle demultiplication couloir](/assets/img/instance_02.PNG "télédiffusion vtom instance vtom modèle demultiplication couloir")  

## Les règles de télédiffusion
J'avoue, il faut beaucoup de règles. Mais une fois définies et bien regroupées, puis ajoutées dans les instances, c'est plutôt clair finalement. Ca n'est à faire qu'une fois et modifier à la marge si besoin.  
Il ne faut rien oublier (je mets des exemples mais c'est non exhaustif) :  
 * alias nom pour la démultiplication `XXXBANQUEXXX` en `le nom de la banque` : application (si démult au niveau app), ressource
 * transformation pour les commentaires
 * transformation pour les valeurs des ressources
 * transformation abscisse par couloir
 * transformation paramètres de jobs

![télédiffusion vtom instance groupe de règles](/assets/img/instance_1.PNG "télédiffusion vtom instance groupe de règles")  

## Les groupes de règles
On regroupe les règles qui concernent la même démultiplication.  

## Les instances et le site de d'intégration
On regroupe tous les groupes de règles de toutes les démultiplications à effectuer pour un site d'intégration en particulier.
Ce qui est bien c'est qu'on peut ajuster finement selon si c'est la REC, PROD etc. On ne mettra pas toutes les banques en REC mais la totalité en PROD par exemple.  

## Génération et Intégration des lots, premier redflag
Et ça, c'est mon premier redflag. Je vais creuser encore.
Le problème vient du fait que la génération d'un lot d'instance va créer autant de lots que de démultiplication.
Perso, j'ai une trentaines de banque à démult au niveau des applications VTOM et une dizaine de "types" à démultiplier au niveau des jobs. Je vous laisse faire le calcul, mais ça fait un paquet de lots.  
Et, vous verrez, qu'à la main en tous cas, il faut intégrer un lot par un lot (pas possible actuellement de sélectionner plusieurs).  

![télédiffusion vtom génération lots](/assets/img/instance_2.PNG "télédiffusion vtom génération lots")  

![télédiffusion vtom intégration lots](/assets/img/instance_3.PNG "télédiffusion vtom intégration lots") 

## Autres redflags
Par exemple, la transformation de valeur de ressource distante ne fonctionne pas dans mon cas (mais pour moi, c'est plus un bug à corriger) :  

![télédiffusion vtom redflag transformation ressource distante](/assets/img/instance_redflag_1.PNG "télédiffusion vtom redflag transformation ressource distante")

Obligé de faire en plusieurs fois dans mon cas pour les jobs `XXXTYPEXXX` :  
 * Une instance de démultiplication des applications par `XXXBANQUEXXX`, 
 * Une instance en reprenant toutes les applications démultipliées une fois les lots de la première instance passés qui va démultiplier les chaines de jobs par `XXXTYPEXXX`

Ca créé pleins de ressources qui sont « entre deux » et qui vont le rester (ressources démultipliées par BANQUE mais avec le XXXTYPEXXX)  
Idéalement, il faudrait un vtom "tampon". A réfléchir.

## Conclusion
En l'état, je ne peux utiliser la solution des instances que partiellement. Mais ça prend bonne tournure. Je pense que dans des cas plus simples, ça peut être génial et surtout, plus de bidouilles des exports etc. 

Bref, Très très bon !
