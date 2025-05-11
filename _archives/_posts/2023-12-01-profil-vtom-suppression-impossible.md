---
layout: post
title: Suppression profil vtom impossible
date: 2023-12-01 12:00:00
author: Virtual Thom
---

```
vtdelprofile /name groupe_jedi
.\cs\jsrv_cs_profile.c (364) - jsrv_deleteProfile(PRO0a7700fxx0002cd65xxfd6c9300000000) errorLa commande de suppression de profil a echoue.
```
Ou que dans l'IHM vous essayez de supprimer le profil qui n'est lié à aucun compte utilisateur mais que ça ne fait rien, cherchez du côté des télédiffusions.  
Il est probable que des lots de télédif soient liés à ce profil.  
```powershell
(vttdf /list kit) | foreach { echo "vttdf /del kit /name `"$(($_ -split "`t")[0])`" /profile `"$(($_ -split "`t")[1])`"" }
# vous grep les lots avec votre profil en question
vtdelprofile /name groupe_jedi
La commande de suppression de profil a abouti.
```
