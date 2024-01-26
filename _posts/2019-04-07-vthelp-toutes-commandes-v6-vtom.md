---
layout: post
title: Détails de toutes les commandes VTOM - VTHELP
date: 2019-04-07 12:00:00
author: Virtual Thom
categories: [vtom, v6, vthelp, ligne de commande]
---
Je viens de prendre une claque. Ca fait 10 ans, peu ou prou, que j'ai fait la connaissance de mon Sergent-Chef préféré (et par la même occasion, mon instructeur - Dieu - VTOM et futur bon ami).

A défaut de m'accueillir convenablement, pour sauver la France sans doute, je me souviens d'un charmant cadeau : une pile de dossiers à éplucher pour découvrir VTOM.

Une des mes premières tâches consistait à effectuer une boucle sur toutes les commandes VTOM (en ligne de commande) afin de savoir comment elles fonctionnaient.

Je n'y connaissais rien à l'époque (et surtout pas le scripting) et je me rappelle en avoir bavé ! Sorte de revanche face à l'adversité de cette (belle) époque, j'espère aider ce petit jeune qui, comme moi, commence et galère aujourd'hui.

L'idée est de boucler sur la commande `vthelp` qui donne à l'écran toutes les commandes VTOM.

Placez-vous sous votre user d'admin serveur vtom bac à sable (je précise ! car on ne sait jamais quand on commence, on pourrait lancer un vtserver sans le vouloir ou autre) et c'est parti :
<!--more-->

```bash
# commande pour lister toutes les commandes - et même + (fichiers ini etc)
vthelp
VTHELP : 6.2.3 FR LINUX_X64 2018/01/18 Visual Tom (c) Absyss
(C) Copyright 2018 ABSYSS.

vthelp - affiche l'aide d'une commande Visual TOM

Usage :
 vthelp <commande>

Exemple :
 vthelp vtaddapp

Liste des commandes :
abswhat          bdaemon          bdel             bdown            bstat            buser            eclear
epresent         estart           estop            fw2vtmib         tchkdate         tdateinfo        tempty
tengine          tfile            tgetdate         timezone         tlist            tmail            tmessage
tpop             tpush            tremote          treset           tresetApp        tresetJob        tsend
tsms             tsnmp            tval             vtaddaccount     vtaddapp         vtaddcal         vtadddate
vtaddjob         vtaddlegend      vtaddmach        vtaddperiod      vtaddprofile     vtaddqueue       vtaddres
vtaddtoken       vtaddunit        vtadduser        vtbackup         vtcmd            vtcopy           vtdcs
vtdelaccount     vtdelalarm       vtdelapp         vtdelcal         vtdeldate        vtdelenv         vtdelinstruction
vtdeljob         vtdellegend      vtdellink        vtdelmach        vtdelperiod      vtdelprofile     vtdelqueue
vtdelres         vtdeltoken       vtdelunit        vtdeluser        vtexport         vtgestlog        vthelp
vthtools         vthttpd          vtimport         vtlclient        vtlist           vtmachine        vtmanager
vtmigrate        vtmonitor        vtmsg            vtom.ini         vtomkill         vtping           vtplan
vtserver         vtsgbd           vtstart          vtstep           vtstools         vttdf            VTXVision.ini

# unitairement pour connaître le détail d'aide pour une commande : vthelp <une commande vtom>
vthelp vtlist
```

```bash
# une boucle for avec la sortie à l'écran du vthelp 
# for <une variable n'importe - admettons : luke> in des mots separes par un espace; do # ici on écrit toutes les instructions qu'on souhaite séparées par un point virgule ou un saut de ligne - et on pourra reprendre la variable for luke du début en rajoutant un $ dollar. ex echo $luke ; done
# $luke prendra alors, tour à tour, la valeur : des, mots, separes, par, un, espace
# $(instructions) permet d'exécuter les instructions et d'en avoir la sortie à l'écran - plus ou moins idem que `instructions`
# le pipe | permet de prendre la "sortie de gauche" pour la "mettre en entrée" de la commande à droite
# le grep -A200 permet de prendre 200 lignes After/Après la chaîne de caractères "Liste des commandes" - c'est arbitraire
# notez que mon vthelp est en français mais il faudra remplacer cette chaîne de caractère si vous êtez dans une autre langue ou que la sortie du vthelp change
# l'idée est juste de récupérer les commandes et seulement les commandes de la sortie à l'écran du vthelp
# le grep -v enlève cette première ligne qui ne nous sert pas
for cmd in $(vthelp | grep -A200 "Liste des commandes" | grep -v "Liste des commandes"); do
vthelp $cmd
done

# Je me souviens que j'avais tout imprimé à l'époque ! pour cela, j'avais tout mis dans des fichiers txt, rapatriés ces derniers, et imprimés
# commande > monfichier va créer ou remplacer monfichier avec le contenu de la sortie d'écran de commande
mkdir mon_dossier ; cd mon_dossier
for cmd in $(vthelp | grep -A200 "Liste des commandes" | grep -v "Liste des commandes"); do
vthelp $cmd > ${cmd}.txt
done
```

```bash
# c'est loin d'être la seule méthode !!! amusez-vous avec les boucles while, for, awk
# regardez sur le net ces commandes pratiques pour parser, triturer, modifier des chaînes de caractères : sed, grep, egrep, tr, cut, awk
# quelques petits exemples
# vous pouvez aussi vous orientez vers une boucle while read <un nom de variable, peu importe> mais dans ce cas, il faudra "parser votre" ligne car une ligne contient plusieurs commandes (ou mettre à plat les commandes ligne à ligne)
# exemple sur une colonne ligne à ligne
vthelp | grep -A200 "Liste des commandes" | grep -v "Liste des commandes" | tr [:space:] "\n" | egrep -v "^$"
# puis while
vthelp | grep -A200 "Liste des commandes" | grep -v "Liste des commandes" | tr [:space:] "\n" | egrep -v "^$" | while read cmd ;do
vthelp $cmd
done

# avec awk
# sur une colonne ligne à ligne
vthelp | awk '
BEGIN{i=0}
{
  if(i){
    for(j = 1; j <= NF; j++) { print $j; }
  };
  if(match($0,/Liste des commandes/)){i=1};
}'
# avec l'exécution du vthelp cmd
vthelp | awk '
BEGIN{i=0}
{
  if(i){
    for(j = 1; j <= NF; j++) { system("vthelp "$j); }
  };
  if(match($0,/Liste des commandes/)){i=1};
}'
```
