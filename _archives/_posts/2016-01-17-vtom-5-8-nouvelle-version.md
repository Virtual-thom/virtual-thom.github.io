---
layout: post
title: VTOM version 5.8
date: 2016-01-17 11:30
author: Virtual Thom
categories: [ordonnancement, vtom, version]
---
Bravo aux équipes d'Absyss (gros clin d'oeil à mon DukeAstar) pour cette nouvelle version 5.8 ! 
C'est incroyable comment le produit évolue dans le bon sens (c'est à dire, le notre :O).

Les deux évolutions que j'adoooooooooore :

## variables d'environnement personnalisables

Enfin !!! On peut désormais passer des variables personnalisables aux traitements.

Elles sont accessibles comme n'importe quelle variable d'environnement. **LOVE** 

Cerise sur le gâteau, on peut utiliser les variables directement dans le champ script ou paramètre **TRIPLE LOVE**

![variable_perso_vtom_v5.8]({{ site.baseurl | prepend: site.url }}/assets/img/variable_perso_vtom_v5.8.jpg)

## unité de soumission

Alors là, chapeau. 

Prenons l'exemple qu'on a tous fait : on veut purger le répertoire logs de VTOM sur tous nos clients VTOM.

### AVANT : 

On crée une application (ou plusieurs regroupées par plateformes par exemple) avec des myriades de jobs lançant le même script de purge sur tous nos clients.

### avec la version VTOM > 5.8  : 

Lorsqu'on définit un nouvel agent VTOM, on peut aussi créer une unité de soumission. 

Par défaut, si on fait du 1 pour 1, on aura la même unité de soumission que l'agent définit. 

Mais on peut aussi regrouper les agents dans une même unité de soumission.

![unite_de_soumission_vtom_v5.8]({{ site.baseurl | prepend: site.url }}/assets/img/unite_de_soumission_vtom_v5.8.JPG)

J'appelle mon unité de soumission PROD\_PAIE\_UNIX, par exemple, afin d'y regrouper tous mes agents Unix de l'application de PAIE, pour l'environnement de PROD.

Je crée un seul job avec mon script de purge avec cette unité de soumission. Et voilà ! tous mes jobs de purges sont définis.

En mode pilotage, si on double clique sur le job, on a accès à une sorte de "suivi d'exploitation" avec les différents agents et le statut.

![suivi_exploitation_unite_de_soumission_vtom_v5.8]({{ site.baseurl | prepend: site.url }}/assets/img/suivi_exploitation_unite_de_soumission_vtom_v5.8.JPG)

On double clique sur une ligne et on a les logs d'exécution de l'agent final en question.

On peut aussi faire un clique droit sur un agent spécifique et relancer le traitement uniquement sur cette machine.


## What Else ?

* En plus, je trouve l'interface de plus en plus belle et rapide. 

On peut vraiment paufiner les représentations graphiques (pour moi, il manque encore la possiblité de réorganiser les différents éléments graphiques à différents plans - premier plan, arrière plan, augmenter ou diminuer de plan graphique)


* ah une autre évolution que j'aime bien : on peut définir une heure de bascule sur les dates d'exploitation (exemple on veut une journée d'exploitation de 14h à 14h J+1, on n'est plus obligé de créer une application qui attend 37:59:00 !
