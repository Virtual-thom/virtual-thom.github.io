---
layout: post
slug: fonction vtom exemple
title: Exemple de fonction VTOM
---
Mon client a conçu une solution qui alimente une pile avec des nomsfichier.zip  
BUT : supprimer les .OK avec le même `basename` que les entrées des piles  
script : votre script rm favori  

## Fonction vtom dans le param :  
Rappel et doc : [fonction vtom](https://virtual-thom.github.io/archives/fonctions-vtom/)  
le param commence par `=` et est interprété ce qu'il y a entre `{}`  

Ici j'utiliserai une fonction de `replaceLast(text,old,new)` pour remplacer la dernière occurrence de `.zip` en `.OK` (mon fichier à supprimer)  
et `getRes(nomRessource)` pour avoir la valeur de la ressource pile en cours de traitement (un path de fichier zip)  
```
="D:\monrep\{replaceLast(getRes(PI_APP_ZIP),.zip,.OK)}"
```

![vtom fonction param](/assets/img/vtom_fonction_replace.png)  

Voilà c'est tout, ça fonctionne super bien.   
C'est l'APIServer qui calcule et interprète.  
Apparemment, il ne faut pas en abuser. Mais là c'était bien pratique dans mon cas (je n'avais pas la maitrise de ce qu'il rentrait dans la pile)  

Merci au Dieu de l'ordonnancement et à la prochaine.  
