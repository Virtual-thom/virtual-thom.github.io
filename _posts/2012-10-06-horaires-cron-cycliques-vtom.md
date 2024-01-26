---
layout: post
title: Horaires cron pour les cycliques VTOM
date: 2012-10-06 10:11
author: Virtual Thom
comments: true
categories: [cron, cyclique, horaire cron, Ordonnancement, Visual TOM, VTOM, VTOM]
---
On ne s'en sert pas souvent mais ça a le mérite d'exister et c'est bien pratique dans certains cas : les horaires en format cron dans les cycliques VTOM.

MM HH1,HH2 -> se lance à HH1:MM, et HH2:MM  

MM1,MM2 HH1,HH2 -> se lance à HH1:MM1, HH1:MM2, HH2:MM1, et HH2:MM2


Pour l'exemple de Guillaume, pour un lancement à 13h, 16h et 19h, il faudra définir un cycle comme cela : 

00 13,16,19

Attention cependant : 

Dans la crontab, il me semble que l'exécution peut s'effectuer en parallèle et plusieurs occurences peuvent se lancer en parralèle si le temps d'exécution est supérieur au temps du cycle.

Sous VTOM, non. La prochaine heure du cycle est evaluée à la fin du cycle précédant. Idem si on éteint le moteur, on peut perdre les cycles qui ont dépassé les heures cron.

(mais ça peut être bien si c'est voulu : on ne veut lancer le job qu'à ces heures précises et pas en dehors)

Merci à ma référence au sommet, alias Dieu, pour les confirmations.


### Cyclic launch in cron format  

Value: MINUTES [HOURS]. The job starts as soon as the minute indicated in the format corresponds to that of the system.  

Remarks:  
 * The extra fields are ignored ("cron" command "day" and "month" fields).
 * If a cycle cannot be performed, for example because the job duration has exceeded the planned cycle, the corresponding iteration is ignored The cycle resets itself on the next iteration.
 * The earliest start time is not dependant of cycle. The first execution will not take it into account.
 * List type declaration: elements in a list are separated by a comma.  

Example:  
The "1,3,5,6 * value corresponds to the declaration of the minutes 1,3,5 and 6 of all the hours.
 * Interval type declaration: an interval is defined by two numbers separated by a hyphen ("-" sign)  

Example: The value "10-15 *" corresponds to all the minutes between 10 and 15 (inclusive) of all the hours.  
 * Declaration including special characters: the joker character "*" corresponds to the "all" expression. the "/" character may be added to an interval or to a joker to express a cycle.  

 Examples:  
  * The "10-40/5 *" value means every 5 minutes between the 10th and 40th minutes, of all the hours. Therefore the chosen times are 00.10, 00.15, 00.20 [..] , 00.35, 00.40, 01.10, 01.15,…
 * The "*/2 1,3 *" value means every 2 minutes in the intervals from 01.00 to 01.59 and 03.00 to 03.59.
