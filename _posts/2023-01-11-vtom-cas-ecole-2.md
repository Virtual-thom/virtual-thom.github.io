---
layout: post
title: VTOM Cas d'école n°2
date: 2023-01-11 18:00:00
author: Virtual Thom
---
Contexte et souhait du client (désolé je ne les invente pas 🤐) :  
* 3 applications A, B, C, cycliques 5 min (chaînes de jobs plutôt complexes à l'intérieur, on verra que ça excluera une des possibilités)
* l'application C ne doit pas tourner si A ou B est en cours
* A de 6h à 23h
* B de 18h à 23h
* C de 6h à 23h
* on part du principe que les cycles s'enchainent correctement et qu'une fois C en cours, peut importe le comportement de A ou de B
<!--more-->
Problème évident, sur un chaînage "classique" des 3 applications, l'application B attend 18hn, reste AVENIR et bloque (lien non valide) l'exécution de C :  

![vtom_cas_ecole_n2_problem.jpg](/wp-content/uploads/vtom_cas_ecole_n2_problem.jpg)

## Les trucs qui ne fonctionnent pas
### Liens OR
Séduisant, car effectivement jusqu'à 18h, ça fonctionne. A mon grand étonnement d'ailleurs car de prime abord, je pensais qu'il fallait que les deux liens soient statués. Mais non, tests en image, un seul lien OR est valide pour le déclenchement de C.  

![vtom_cas_ecole_n2_OR_1.jpg](/wp-content/uploads/vtom_cas_ecole_n2_OR_1.jpg)  

Mais à 18h, on risque de tomber sur le cas (par ex) où A est TERMINE et B ENCOURS, et C se lance quand même étant donné qu'un lien OR est valide.  

![vtom_cas_ecole_n2_OR_2.jpg](/wp-content/uploads/vtom_cas_ecole_n2_OR_2.jpg)  

### B date différente, bascule à 42h (18h J+1)
(solution du client, aie aie aie)  

Alors oui, c'est élégant à première vue, car B reste à DEPLANIFIE de 23h à 18h J+1, la date bascule à 18h, B reprend son cycle jusqu'à 23h etc. Sauf que non, C ne se déclenche pas.   

![vtom_cas_ecole_n2_datexy.jpg](/wp-content/uploads/vtom_cas_ecole_n2_datexy.jpg)  

Bon, je tiens à rappeler qu'autant que possible (toujours en fait pour ma part) ON NE MET PAS DE DATES DIFFERENTES DANS UNE MEME CHAINE VTOM.  
Ca, c'est dit :p sauf qu'une fois qu'on vous a dit ça depuis que le monde est monde (au moins), on ne vous a peut-être jamais expliqué pourquoi.  
Pourquoi : car 1 date == 1 plan, et ça n'est pas logique de lier entre eux des objets qui ne sont pas sur le même plan, mais surtout un lien prend aussi en compte la date et reste invalide si le parent est à une date différente (J-1 pour l'ex.)  

## Ca marche, classé de la pire ... à la moins pire ^^
### Ressources Textes
Je ne m'attarde pas trop là dessus. Comme je le disais au début, c'est compliqué de relier tous les jobs à l'intérieur des chaînes pour avoir une en-tête qui valorise à ENCOURS et une fin qui remet à OK la ressource. Et je ne trouve pas la solution hyper élégante ; les goûts et les couleurs.    
Mais quand même, voici une réflexion possible : 
 * C attend T_RES_A et T_RES_B à OK
 * Dès que A ENCOURS, valorise T_RES_A ENCOURS
 * Dès que B ENCOURS, valorise T_RES_B ENCOURS

Petite précision, ça me parait compliqué de mettre des applications d'en-tête et de fin pour les valorisations de ressource texte. On n'est pas sûr à 100% que les cycles se suivent par ex.  

### Ressource poids
 * ressource poids à max 2
 * A et B prennent 1, attendent indéfiniment, et libère
 * C prends 2, attend indéfiniment, et libère

![vtom_cas_ecole_n2_poids.jpg](/wp-content/uploads/vtom_cas_ecole_n2_poids.jpg)  

Bon ça fonctionne, rien à dire. Mais je n'ai jamais aimé les poids. Deux raisons à cela :
1. Selon les cas, si on force à TERMINE, ça ne libère pas la ressource (je dis ça de mémoire, à vérifier mais j'ai eu beaucoup d'incidents de ce genre, notamment avec les équipes de Pilotage).     
Evidemment, si une ressource reste à 1/2 pour x ou y raison, C ne se lancera jamais.
2. C'est assez difficile, selon moi, de suivre la vie d'une ressource poids. Rien dans l'historique. Pas de job, donc pas d'exécution / log non plus. 

### Ressource numérique
Je n'arrive plus à me rappeler dans quels cas on utilisait les ressources numériques chez BPCE-IT (surement des jours de mois). Mais ça m'a permis de penser à cette dernière solution.  

 * ressource numérique  
 * une application cyclique toutes les heures, de 0h à 23h59, avec un job qui valorise à HH la ressource numérique (1h ress à 1, 2h ress à 2, etc. jusqu'à 23)  
en powershell, c'est assez simple : `tval -name NOMRESNUM -value $(date -format "HH")` à exécuter sur le client du serveur VTOM  
En général, c'est le genre de job qu'on mettrait bien dans un ENV admin VTOM mais je le déconseille. Ca rajouterait une dépendance peu souhaitable entre divers environnements. Autant le mettre dans le même env applicatif, si c'est possible.  
 * B de 6h à 23h (cette fois hmin doit être identique au reste et non 18h), "ne pas attendre", expect ressource numérique >= 18 

Avant 18h, B se déplanifie bien (enfin resnopla=o je trouve plus "joli" d'avoir des objets NONPLANIFIE plutôt que DEPLANIFIE quand la contrainte n'est pas vérifiée et qu'on est en "ne pas attendre". Juste pour rappel, NONPLANIFIE == valide les liens, DEPLANIFIE == ne valide pas les liens)  
![vtom_cas_ecole_n2_ress_num_1.jpg](/wp-content/uploads/vtom_cas_ecole_n2_ress_num_1.jpg) 

Après 18h, B peut s'exécuter, mais C attendra bien que A ET B soient statués.  
![vtom_cas_ecole_n2_ress_num_2.jpg](/wp-content/uploads/vtom_cas_ecole_n2_ress_num_2.jpg) 

J'y vois un inconvénient majeur : le top départ pourrait être retardé (dépend du cycle qui valorise la ress num, ex. pour x ou y raison, on redémarre un moteur à xxh32min, le cycle d'une heure qui valorise la ress num va être décalé à HH+32min)  

### Ressource texte (bis)
C'est en faisant l'article que j'ai pensé à celui-ci.  
On part sur la même idée de la ressource numérique avec une contrainte et "ne pas attendre" mais presque sans les incovénients.  

 * Application 18h hmin, job qui valorise ressource texte à GO
 * B de 6h à 23h (cette fois hmin doit être identique au reste et non 18h), expect ressource text à GO, "ne pas attendre"

Seuls inconvénients que je vois là tout de suite, c'est le fait d'être encore dépendant d'un top horaire d'une autre application (mais déjà plus sûr que le num) et de rajouter encore 1 autre application en début, ou fin de journée, pour réinitialiser la ressource texte à "WAIT".  
  
  
Et vous, comment auriez-vous fait ?

