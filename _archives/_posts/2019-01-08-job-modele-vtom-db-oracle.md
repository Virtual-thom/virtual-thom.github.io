---
layout: post
title: Modèle de job SGBD (VT-XAP-SGBD) vtom (ex oracle)
date: 2019-01-08 00:00:00
author: Virtual Thom
categories: [VTOM, sgbd, oracle]
---

1. Copier les drivers JDBC sur le client et dans votre répertoire IHM
2. Créer une connexion à la base SGBD dans VTOM (partie Modèle)
3. Glisser / Déposer le modèle de Job SGBD dans une APPLICATION VTOM (je précise APPPLICATION :smile:)
4. Configurer le job (requête SQL ou fichier SQL, actions à effectuer etc)

### configuration client (v6 ok avec queue_vt2db obligatoire)

copier les drivers JDBC dans $ABM_BIN/jdbc/drivers/

exemple /usr/vtom/abm/bin/jdbc/drivers/ojdbc6.jar

### configuration IHM

copier les drivers JDBC dans votre répertoire IHM (où se trouve le VtomXvision.exe) .\plugins\jdbc\drivers

### configuration de la chaîne de connexion (Exemple Oracle)

```
Driver JDBC         : oracle.jdbc.driver.OracleDriver
Chaine de connexion : jdbc:oracle:thin:@server:port:sid
Utilisateur         : user
```

### exemple de log

```
00:00:05 | INFO  | Vtom2Db : 6.2.3 FR LINUX_X64 2018/01/18 Visual Tom (c) Absyss
00:00:05 | INFO  | Load JDBC Drivers
00:00:05 | INFO  | Search for JAR in :./jdbc/drivers
00:00:05 | INFO  | /usr/vtom/abm/bin/./jdbc/drivers
00:00:05 | INFO  | Add Driver to classloader : /usr/vtom/abm/bin/./jdbc/drivers/ojdbc6.jar
00:00:05 | INFO  | Retrieve connection properties from environment
00:00:05 | INFO  | Execute task
00:00:08 | INFO  | Execute Sql: select * from OSEF
00:00:08 | INFO  | Use result: 1
00:00:08 | INFO  | Begin actions with conditions 1/1
00:00:08 | INFO  | Check conditions
00:00:08 | INFO  | Check Task returns a result
00:00:08 | INFO  | Condition is ok
00:00:08 | INFO  | Execute action: Show result
00:00:08 | INFO  | Result:
00:00:08 | INFO  | ENV1|APP1|OSEF|OSEF
....
```
