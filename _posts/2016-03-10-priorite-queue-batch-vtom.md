---
layout: post
title: Priorité queue batch VTOM
date: 2016-03-10 22:53
author: Virtual Thom
categories: [queue, queue batch, Visual TOM, VTOM]
---

&lt;EDIT&gt;
<small>
Une option de priorité a été ajoutée depuis 5.7+ et se gère au niveau des objets Applications et Traitements. (case à cocher "Priorité" de 0 jusqu'à 127, 0 étant le moins prioritaire). Cette nouvelle fonctionnalité palie à la décision arbitraire du moteur de mettre tel ou tel job (ou application) à ENCOURS avant tel ou tel autre, mais ne remplace pas la priorité de la queue batch dans la file d'attente.</small>

## Problématique des gros environnements de production

Certains clients VTOM à forte charge d'ordonnancement voient leurs files d'attente saturées, et des traitements non prioritaires qui durent des heures bloquent le passage de traitements "rapides" (qui pourraient débloquer des chaînes bien plus prioritaires).

## Priorité dans la file d'attente : principe

Tous les jobs dont le moteur a validé les contraintes (horaires, liens, ressources) passent à « EN COURS » dans VTOM selon un ordre  propre au moteur. (ex. JOB_1 commence avant JOB_2 qui commence avant JOB_3 etc. quelque soit la priorité de vos queues).

« EN COURS » dans VTOM != d'en cours d’exécution sur le host.

Seuls les n premiers jobs (nombre de jobs simultanés configuré dans le queue.conf) s’exécutent réellement, le reste passe en file d’attente (souvent illimitée -1).

Dès qu'un job se termine, il libère une place et les jobs avec la queue batch la plus prioritaire se déclenchent.

## Mise en place des queues prioritaires

La gestion des priorités est prise en charge suite à :

* Paramétrage du fichier vtom.ini,
* Déclaration des queues batch dans le référentiel.

Paramètre ABM_QUEUES_PRIORITY_INCREMENT dans le vtom.ini sous [BDAEMON] sont les suivants :

* DISABLED : 	la gestion est désactivée.
* BY_ONE : 	après chaque fin de Traitement, la priorité des travaux présents dans la file est incrémentée de 1. (activé par défaut)
* BY_PRIORITY : 	après chaque fin de Traitement, la priorité des travaux présents dans la file est incrémentée de la priorité initiale.

Ex. priorité sur la queue batch « queue_ksh » :

* queue_ksh.0 » pour les Traitements non prioritaires,
* queue_ksh.3 » pour les Traitements peu prioritaires,
* queue_ksh[.5] » par défaut,
* queue_ksh.7 » pour les Traitements relativement prioritaires,
* queue_ksh.10 » pour les Traitements prioritaires.

Remarques :

* Les Traitements ayant une priorité initiale à 10 la conservent et sont prioritaires quelque soit la priorité des autres Traitements.
* Les Traitements ayant une priorité initiale à 0 la conservent.

## Solutions pour améliorer votre file d'attente

* mettre en place ce système de priorisation des queues batch &lt;nom queue&gt;.[0-10]
* analyser vos jobs, et éviter d'exécuter des jobs sur des clients de traitement/applicatif alors qu'ils pourraient/devraient tourner sur les clients du serveur VTOM (valorisation de ressource par exemple)
* éviter les scripts qui ne font rien d'autres que temporiser ou attendre des ressources (typiquement le job : exit 0, qui attend que telle ou telle ressource soit dispo)
  * à une époque, il était pratique d'avoir la log d'exécution sur le traitement pour connaître les heures de passage, mais maintenant avec les statistiques sélectives, on s'en passe
  * soit on remplace par un job en simulation (pas de passage dans la file d'attente), soit on essaye de positionner les ressources au niveau de l'application plutôt que du job (si c'est faisable)
* multiplier les queues d'exécution :
  * 1 queue pour les traitements techniques "rapides"
  * 1 queue pour les traitements applicatifs "longs"

## rappel queue batch

* 1 file d’attente = 1 queue batch VTOM sur 1 client VTOM
* 1 client VTOM = 1 process bdaemon sur 1 machine (si plusieurs bdaemon sur une machine, ce sont des clients VTOM différents - port qui change)

* Les queues sont configurées dans $ABM/config/queues du client
  * 1 répertoire / queue :

```bash
$ ls -l $ABM/config/queues
drwxr-xr-x    2 u1vtom   vtom            256 Jun  7 2012  $job$
drwxr-xr-x    2 u1vtom   vtom            256 Jun  7 2012  $none$
drwxr-xr-x    2 u1vtom   vtom            256 Jun  7 2012  queue_csh
drwxr-xr-x    2 u1vtom   vtom            256 Jun  7 2012  queue_ksh
drwxr-xr-x    2 u1vtom   vtom            256 Jun  7 2012  queue_perl
drwxr-xr-x    2 u1vtom   vtom            256 Jun  7 2012  queue_rexx
drwxr-xr-x    2 u1vtom   vtom            256 Jun 30 2014  queue_sap
drwxr-xr-x    2 u1vtom   vtom            256 Jun  7 2012  queue_sh
drwxr-xr-x    2 u1vtom   vtom            256 Jun  7 2012  queue_tcsh
```
  * 1 queue.conf + 1 users / répertoire :

```bash 
$ cat $ABM/config/queues/queue_ksh/queue.conf
queue_ksh     nom de la queue
10            nombre max. de jobs en simultané
-1            nombre max. de jobs dans la file d’attente (-1 illimité)
/bin/ksh      binaire pour lancer la queue
20            obsolète
$ cat $ABM/config/queues/queue_ksh/users
any:-1:-1     on peut surdéfinir la priorité par utilisateur unix : user:nb max. parall:nb max. file
```

  * 1 job en cours dans VTOM = 1 fichier dans $ABM_SPOOL (+ .env si dans la file)
 
```bash  
$ ls $ABM_SPOOL
10      12      14      16      18      20      21      22      23      24      25      26      27      28      29      30      31      32
11      13      15      17      19      20.env  21.env  22.env  23.env  24.env  25.env  26.env  27.env  28.env  29.env  30.env  31.env  32.env
```

[Ecrire sa queue batch VTOM](https://virtual-thom.github.io/ecrire-sa-queue-batch-vtom-cygwin-php-perl/)
