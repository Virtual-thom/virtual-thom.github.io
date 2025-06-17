---
layout: post
slug: vtbackup TOM_HOME keys
title: vtbackup TOM_HOME keys
---
*A partir de la version 7.2.1b, une paire de clé de chiffrement est créée dans le répertoire 'keys'. En cas d'utilisation d'un serveur de backup, ce répertoire doit être synchronisé.*

*Pour un coffre-fort externe (type AWS, Azure), la clé de chiffrement est gérée par Visual TOM dans le répertoire `TOM_HOME/keys`, avec les fichiers 'default.key' (clé privée) et 'defaut.key.pub' (clé publique).*

Ces infos sont passées un peu sous les radars, en tous cas des miens.  
Ce que ça ne dit pas clairement, c'est que le `vtbackup` est chiffré avec la clé publique `TOM_HOME/keys/default.key.pub`.  
Si comme moi, vous aviez l'habitude de sauvegarder vos vtbackup en cas de PRA ou gros crash ou même, en cas de refresh d'un bac à sable ou autre, pensez à bien intégrer la clé privée `TOM_HOME/keys/default.key` afin que le pgrestore ou le vtserver puisse déchiffrer le vtbackup.
Je ne sais pas exactement qui fait quoi, mais perso, c'est au moment du lancement du vtserver que j'ai l'erreur :  
```
14:37:50 12-06-2025 | th-0348 | 01 |          main_primary.c   114 |   * db version is v5.1.0...
14:37:50 12-06-2025 | th-0348 | 01 | *urity_encryption_key.c	66 | Initialize encryption key
14:37:50 12-06-2025 | th-0348 | 01 | *urity_encryption_key.c	89 | Encryption key exists
14:37:50 12-06-2025 | th-0348 | 01 |        abs_crypto_aes.c   279 | Error finalizing decryption
14:37:50 12-06-2025 | th-0348 | 01 | *urity_encryption_key.c   172 | Failed to verify encryption challenge
14:37:50 12-06-2025 | th-0348 | 01 |          main_primary.c   160 | Error has occured during encryption key initialization
```

Dans le futur, j'imagine un vtbackup cohérent avec les clés - ou pas, car le but justement, c'est que personne ne puisse déchiffrer votre vtbackup (qui contient forcément des données sensibles), même le support Absyss ne peut pas déchiffrer votre vtbackup sans la clé.  

Mais en attendant, veillez à bien sauvegarder ce répertoire - sinon vos vtbackup seront inutilisables - et à synchroniser les répertoires TOM_HOME/keys quand c'est nécessaire.  


