---
layout: post
title: Compte rendu package vtmanager
date: 2024-09-26 09:00:00
author: Virtual Thom
---
Note à moi même, les données et comptes rendus des livraisons de paquets via vtom sont stockées sur le client dans le répertoire du manager/bin, dans le fichier db.dat sqlite3.  
```
$ cd $TOM_HOME/manager/bin
$ /bin/sqlite3 db.dat
SQLite version 3.7.17 2013-05-20 00:56:22
Enter ".help" for instructions
Enter SQL statements terminated with a ";"
sqlite> .tables
CRCS             PACKAGES         PROPERTIES       TASK_PROPERTIES
HISTO            PACKAGE_REPORTS  TASKS
sqlite> select * from PACKAGE_REPORTS limit 1 ;
1|Visual TOM Agent|7.1.2c FR LINUX_X64|1719480454||I> Verification du paquet : VT-CS-LINUX_X64.71.Z
I> Contenu du paquet
 - install/ (0 )
 - install/boot_start_client.1 (116 )
 - install/boot_start_client.2 (65 )
....
```
