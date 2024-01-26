---
layout: post
title: Lister les processus java weblogic
date: 2017-06-12 21:10
author: Virtual Thom
categories: [Java, Weblogic, ps, /usr/ucb/ps -auxwww, ps, nom complet processus, processus tronqué]
---

### Mise à jour 12/06/17 pour Windows 

```cmd
WMIC PROCESS WHERE (name="java.exe") get CommandLine 
ou
jps
```

De visu' aussi avec le task manager :

![process_java_windows_taskmg](/wp-content/uploads/process_java_windows_taskmgr.jpg)


Petite astuce pour lister les processus java weblogic, avec le nom de l'application. 
En effet, un simple `ps -ef` ne vous donnera, bien souvent, qu'une ligne tronquée ne contenant pas toutes les informations que vous aimeriez.

## Première solution : ucb ps -aux

si vous avez ce binaire, le fameux /usr/ucb/ps -auxwww.

## Deuxième solution : pargs

```bash
# On fait un simple ps et on récupère les PID des process grepés (ici par exemple, les processus java lancés par l'utilisateur webadm
# Ensuite on passe ce PID dans pargs -l pour les détails
ps -ef | grep java | grep webadm | while read line; do pargs -l $(echo $line | awk '{print $2}') 2> /dev/null ; done
```

## Troisième solution : /proc/pid/cmdline

```
/proc/<pid>/cmdline

# attention si on fait du grep sur du binary file comme dans /proc il faut utiliser l'option --text ou -a
egrep --color --text "pattern" /proc/<pid>/cmdline
```

## pid job en cours dans VTOM

Petit truc sympa pour voir les process tree des jobs en cours sur un client VTOM :

 * ls des fichiers dans ABM_SPOOL, on grep ceux qui ont un process inscrit (différent de 0, car ceux-là sont dans la queue d'attente)
 * le 4ème champ représente le PID du job (on fait un ps tree dessus)

```
/usr/vtom/abm/spool$ for id in $(ls -1) ; do grep -w $id $ABM_SPOOL/* | awk '$4 != 0{system("ps -o args -T "$4);}' ; done
COMMAND
-ksh /usr/vtom/admin/tom_submit.ksh
    \--/bin/ksh /home/vtom/PATH_DWH_SHELL/OSEFBIS_010_M105_ETI_odi.ksh
        \--/bin/ksh /tech/ODIXXX/tools/startjob.ksh OSEFBIS_010_M105_ETI_odi OSEFBIS_010_M_ETI_105 -1 GLOBAL.G_JDBC_INSTANCE=USID1 GLOBAL.G_JDBC_PASSWORD= G
            \--/bin/sh /tech/ODIXXX/oracledi/agent/bin/startscen.sh OSEFBIS_010_M_ETI_105 -1 CTX_UTI_VARIABLE -name=AGT11_UTI_SERVXXXX -KEYWORDS=UU1DC002
                \--/usr/java6_64/jre/bin/java -Xms128m -Xmx256m -Djava.security.policy=server.policy -Doracle.security.jps.config=./jps-config.xml -DO
COMMAND
-ksh /usr/vtom/admin/tom_submit.ksh
    \--/bin/ksh /home/vtom/PATH_DWH_SHELL/OSEF_010_M501_odi.ksh
        \--/bin/ksh /tech/ODIXXX/tools/startjob.ksh OSEF_010_M501_odi OSEF_010_M_EXTR_FLUX_CRDT_501 -1 GLOBAL.G_JDBC_INSTANCE=USID1 GLOBAL.G_JDBC_PASS
            \--/bin/sh /tech/ODIXXX/oracledi/agent/bin/startscen.sh OSEF_010_M_EXTR_FLUX_CRDT_501 -1 CTX_UTI_VARIABLE -name=AGT11_UTI_SERVXXXX -KEYWOR
                \--/usr/java6_64/jre/bin/java -Xms128m -Xmx256m -Djava.security.policy=server.policy -Doracle.security.jps.config=./jps-config.xml -DO
COMMAND
-ksh /usr/vtom/admin/tom_submit.ksh
    \--/bin/ksh /home/vtom/PATH_DWH_SHELL/OSEF_020_M005_odi.ksh
        \--/bin/ksh /tech/ODIXXX/tools/startjob.ksh OSEF_020_M005_odi OSEF_020_M_MFP_FLUX_CRDT_005 -1 GLOBAL.G_JDBC_INSTANCE=USID1 GLOBAL.G_JDBC_PASSW
            \--/bin/sh /tech/ODIXXX/oracledi/agent/bin/startscen.sh OSEF_020_M_MFP_FLUX_CRDT_005 -1 CTX_UTI_VARIABLE -name=AGT11_UTI_SERVXXXX -KEYWORD
                \--/usr/java6_64/jre/bin/java -Xms128m -Xmx256m -Djava.security.policy=server.policy -Doracle.security.jps.config=./jps-config.xml -DO
COMMAND
-ksh /usr/vtom/admin/tom_submit.ksh
    \--/bin/ksh /home/vtom/PATH_DWH_SHELL/OSEF_010_M601_odi.ksh
        \--/bin/ksh /tech/ODIXXX/tools/startjob.ksh OSEF_010_M601_odi OSEF_010_M_EXTR_PALR_CRDT_601 -1 GLOBAL.G_JDBC_INSTANCE=USID1 GLOBAL.G_JDBC_PASS
            \--/bin/sh /tech/ODIXXX/oracledi/agent/bin/startscen.sh OSEF_010_M_EXTR_PALR_CRDT_601 -1 CTX_UTI_VARIABLE -name=AGT11_UTI_SERVXXXX -KEYWOR
                \--/usr/java6_64/jre/bin/java -Xms128m -Xmx256m -Djava.security.policy=server.policy -Doracle.security.jps.config=./jps-config.xml -DO
COMMAND
-ksh /usr/vtom/admin/tom_submit.ksh
    \--/bin/ksh /home/vtom/PATH_DWH_SHELL/OSEF_010_M502_odi.ksh
        \--/bin/ksh /tech/ODIXXX/tools/startjob.ksh OSEF_010_M502_odi OSEF_010_M_EXTR_FLUX_NAFI_502 -1 GLOBAL.G_JDBC_INSTANCE=USID1 GLOBAL.G_JDBC_PASS
            \--/bin/sh /tech/ODIXXX/oracledi/agent/bin/startscen.sh OSEF_010_M_EXTR_FLUX_NAFI_502 -1 CTX_UTI_VARIABLE -name=AGT11_UTI_SERVXXXX -KEYWOR
                \--/usr/java6_64/jre/bin/java -Xms128m -Xmx256m -Djava.security.policy=server.policy -Doracle.security.jps.config=./jps-config.xml -DO
```
