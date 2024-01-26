---
layout: post
title: Supprimer le BOM d'un fichier encodé en UTF-8 sous linux
date: 2014-01-22 10:00
author: Virtual Thom
categories: [Linux, OS, Script, shell]
---
Parfois sur un head file (pour voir la premier ligne) les caractères ï»¿ apparaissent. Ca semble correspondre à un encoding UTF-8 avec BOM. 

Cela m'est déjà arrivé et mon shebang ne fonctionnait pas (vous savez le fameux  #! en début de script pour spécifier le shell dans lequel va s'exécuter les commandes du script)

Autre cas, vous faites un grep censé fonctionner et aucun retour sur votre grep. Pourtant le cat fonctionne.
essayez la commande head et vous serez fixé sur les premiers bits, les premiers caracteres devraient être étranges

```
head -n 1 fichier
```

Pour le supprimer sous LINUX :

```
tail --bytes=+4 UTF8WithBom.txt > UTF8WithoutBom.txt
```

Ca parait tout bête, mais supprimer les premiers caractères semble suffisant.

Pour voir tous les caractères sous LINUX vi : 

```
vi file
:set list
```

Pour modifier un encoding sous vi : 

```
vi file
:set fileencoding=utf-8
```

autre methode en ligne de commande (pratique pour scripter)

```
vim +"set bomb | set fileencoding=utf-8 | wq" fichier
```

Dans le même ordre d'idée, voici une solution pour convertir un fichier texte DOS en Unix : 

```
:e ++ff=dos
:setlocal ff=unix
```

**source** : [VI file_format](http://vim.wikia.com/wiki/File_format)
