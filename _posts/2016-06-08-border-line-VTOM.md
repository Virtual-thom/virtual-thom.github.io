---
layout: post
title: Border Line VTOM
date: 2016-06-07 22:03
author: Virtual Thom
categories: [ordonnancement, vtom, vtexport, vtaddaccount, TOM]
---
Si vous lisez ces mots, c'est que le côté obscur vous a déjà envahi et que le border line ne vous fait pas peur ! :smiling_imp:

Par conséquent, ce qui va suivre ne vous effraiera point et pourrait même vous intéresser :scream:

<small>(mais quand même, attention à vos prod, ne jouez que sur vos bacs à sable !)</small>

## Ouvrir les DBF (ne concerne que les versions < v6.1 VTOM)

Les .dbf c'est les fichiers de Table qui constituent la base de données VTOM actuelle (bientôt full Postgres SQL, adieu les .dbf) dans votre répertoire TOM_BASES (ou de votre vtbackup)

 * installer simpledbf et pandas pour Python

```python
from simpledbf import Dbf5
dbf = Dbf5('/mnt/workspace/temp/monvtbackup/appl.dbf', codec='latin-1')
dbf.to_csv('/mnt/workspace/temp/appl.csv')
```

## Restaurer votre pg_dump_sgbd.backup en un fichier SQL exploitable

```
$TOM_HOME/sgbd/bin/pg_restore /mnt/workspace/temp/monvtbackup/pg_dump.bakcup > /mnt/workspace/temp/pg_dump.sql
```

## vtexport, vthtools, vtstools, vtping ...

On peut tout faire à distance (ou localement pour changer d'instance VTOM si plusieurs VTOM d'installés sur le même serveur).

Il suffit de : 

 * récupérer les ports dans /etc/services
 * avoir à disposition les binaires (user vtom qui charge les variables d'environnement $TOM_ADMIN/vtom_init.ksh ou avoir copié quelque part les binaires)
 * exporter les variables
 
```
export TOM_REMOTE_SERVER=monserveurdistant
export TOM_PORT_vtsgbd=30509
export TOM_PORT_vtserver=30507

# quelques exemples de commandes qui afficheront les résultats comme si on était sur le serveur distant
vtping
vtstools -x -e "01-01-2000 00:00:00 07-06-2016 23:59:00" 
```

### plus dangereux, vtaddaccount

Imaginons que j'importe la base de PROD sur mon bac à sable pour faire des tests (je suis un hacker gentil quand même hein). 

Imaginons que je n'ai pas de user / mdp pour effectuer des modifications. On rajoute le user TOM avec un profil par défaut.

```
vtaddaccount -l 
vtom@36122a68438c:/mnt/workspace$ vtaddaccount -l
Nom           : ADM_prf
Commentaire   :

Nom           : PIL_PROD_prf
Commentaire   :

Nom           : TOM_prf
Commentaire   :

vtaddaccount -n TOM -p TOM -d ADM_prf
```

Et biensûr, je peux faire ça à distance avec la magie du `export TOM_REMOTE_SERVER etc.`

## Accéder aux stats directement depuis la base VTOM

```
$TOM_HOME/sgbd/bin/psql -d vtom -p VOTRE_PORT_SGBD << EOF
\pset tuples_only
\pset footer off
\a
select *
from vt_stats_job 
limit 1
;
EOF

# autre exemple de requête pour avoir tous les traitements TERMINE ou en ERREUR
\pset footer off
\t
\f ;
\a
\o /var/tmp/20160125-123246_export_stats.csv
select vtenvname,vtapplname,vtjobname,
CASE WHEN vtstatus=4 THEN 'EN-ERREUR'
  WHEN vtstatus=3 THEN 'TERMINE'
END,
to_char(vtbegin,'DD-MM-YYYY HH24:MI:SS'),to_char(vtend,'DD-MM-YYYY HH24:MI:SS'),vterrmess,to_char(vtexpdatevalue,'DD-MM-YYYY HH24:MI:SS'),'MONDOMAINE',vtfamily,vthostname,vtbqueuename,vtusername,vtcomment,''
from vt_stats_job
where vtjobname != ''
and (vtstatus = 3 or vtstatus = 4)
;
```
