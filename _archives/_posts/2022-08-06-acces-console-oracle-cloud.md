---
layout: post
title: Accès console Oracle Cloud
date: 2022-08-06 20:00:00
author: Virtual Thom
---
Si comme moi, vous avez mis à jour la version Ubuntu 22.04.1 LTS Jammy, et que votre clé ssh ne fonctionne plus ("Server refused our key"), c'est que la clé SSH RSA n'est plus assez "sécurisée" d'après leur nouvelle norme.  
Il faut créer une nouvelle paire de clé SSH ed25519. Reste à coller le nouveau .pub dans votre `authorized_keys`, encore faut-il avoir accès à la console de l'instance. 
  
Voici comment faire pour débugger et ouvrir une session temporaire via l'interface admin d'Oracle Cloud.  

Lancer une invite de commande (pour linux/mac pas de problème, sur windows, powershell 7.x semble mieux fonctionner)  
```
ssh-keygen
# laisser tout par défaut sans passphrase
# repérer le chemin du fichier id_rsa.pub
# sur windows normalement : %userprofile%\.ssh\id_rsa.pub
```

Copier le contenu de `id_rsa.pub` et le coller dans :  
Compute > Instances > Instance details (de votre instance à accéder) > Console connection (dans Resources en bas à gauche) > Create local connection > Paste public key  
Une nouvelle ligne est créée, menu (...) > "Copy serial console connection for Linux/Mac"  
```
# ça devrait ressembler à ça :
ssh -o ProxyCommand='ssh -W %h:%p -p 443 ocid1.instanceconsoleconnection.oc1.eu-marseille-1.xxxxxxxxxxxxxxxxxq@instance-console.eu-marseille-1.oci.oraclecloud.com' ocid1.instance.oc1.eu-marseille-1.xxxxxxxxxxxxxxxxxxxxx
```
Coller dans l'invite de commande et normalement c'est OK (répondre yes)  
  
Une fois sur la console de votre instance, coller la nouvelle clé ed25519 pub dans votre `~/.ssh/authorized_keys`


![oracle_cloud_console_connection.png]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/oracle_cloud_console_connection.png)
