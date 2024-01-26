---
layout: post
title: Statistiques VTOM PSQL
date: 2021-09-02 12:00
author: Virtual Thom
categories: [PSQL, postgresql, powershell, Visual TOM, Visual TOM, VTOM, VTOM]
---
I'm Back ! qui l'eut cru. A faire du VTOM en plus ... Même dans le fin fond de ma campagne, VTOM vient me hanter (et me nourrir, il faut bien l'admettre même si j'ai des tonnes de courgettes et tomates au jardin :)).  
Bref, voici comment je fais pour requêter les stats VTOM en powershell.  

```powershell
# pour le port faire un vtping en cas de doute
# le fichier sqlFile contient les instructions SQL (vous mettez ce que vous voulez bien sûr, dans mon cas c'était pour avoir la dernière exécution d'un job donné en paramètres
# petit exemple avec les -v nomparam="'valeur'" pour passer des param au script SQL :nomparam
# -F";" (séparateur | de base mais je voulais ";")
# -P "footer=off" (pour ne pas avoir de récap (rows(xxx) à la fin du résultat)
# -A (pour ne pas avoir d'espaces entre les séparateurs)
$statCSV = (& $ENV:TOM_HOME\SGBD\bin\psql.exe -d"vtom" -p"20009" -U"vtom" -f $sqlFile -v vtenvname="'$vtenvname'" -v vtapplname="'$vtapplname'" -v vtjobname="'$vtjobname'" -v vtexpdatevalue="'$dateStatAge'" -A -F";" -P "footer=off") | ConvertFrom-Csv -Delimiter ';'
```
<!--more-->

`$sqlFile`
```sql
select vtenvname,vtapplname,vtjobname,vtstatus,vtbegin,vtend,vtnbretry,vtretcode,vterrmess,vthostname,vtcalname,vtdatename,vtexpdatevalue,vtbqueuename,vtusername,vtscript,vtcomment,vtfamily from vt_stats_job 
where vtenvname = :vtenvname and vtapplname = :vtapplname and vtjobname = :vtjobname
and vtexpdatevalue > :vtexpdatevalue::date
and (vtstatus = 2 or vtstatus = 3 or vtstatus = 4)
order by vtbegin desc
limit 1;
```

```
# convertfrom-csv l'avantage c'est que l'objet est bien propre, on peut accéder à tous les attributs
vtenvname      : ENV1
vtapplname     : LUKESKY
vtjobname      : LEIAENSHORT
vtstatus       : 3
vtbegin        : 2021-08-31 20:00:01
vtend          : 2021-08-31 20:00:07
vtnbretry      : 0
vtretcode      : 0
vterrmess      : **Job termine sans erreur
vthostname     : HOST1
vtcalname      : EveryDay
vtdatename     : D_DATE1
vtexpdatevalue : 2021-08-31
vtbqueuename   : queue_PS_script
vtusername     : USER1
vtscript       : #C:\\exploit\\Scripts\\script.ps1
vtcomment      :
vtfamily       :
```

Tiens tant que j'y suis, petit script SQL pour voir le nombre d'exécution de tous les jobs pour une date donnée dans les statistiques VTOM. Je pense que je vais m'en servir pour purger plus finement les stats de jobs qui s'exécutent 1000 fois dans la journée.
```sql
SELECT vtenvname,vtapplname,vtjobname,count(*) as nbexec
FROM vt_stats_job
WHERE vtexpdatevalue = :vtexpdatevalue::date
and vtjobname != ''
and (vtstatus = 2 or vtstatus = 3 or vtstatus = 4)
GROUP BY vtenvname,vtapplname,vtjobname
order by nbexec desc, vtenvname,vtapplname,vtjobname
;
```

Au cas où, pour ceux qui ne savent pas, on peut effectivement filtrer les purges de stats au job près (ne prenez pas peur du message qui s'affiche pendant la purge, ça affiche le nombre total d'enregistrement mais à la fin ça vous dit les lignes qu'il a purgées).
```bash
vtstools -f env1/app1/job1 -p "01-01-2000 01-01-2021"
```
