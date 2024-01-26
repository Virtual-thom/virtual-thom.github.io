---
layout: post
title: Changer le fond d'écran du dashboard Umbrel
date: 2022-10-28 12:00:00
author: Virtual Thom
---
Pour ceux qui voudraient changer une image de fond d'écran de leur page d'accueil Umbrel :  
```
Copier en scp (avec WinSCP par ex) votreimage.jpg de votre PC vers votre umbrel dans votre home dir ~ (ceci est un exemple pour les noms et chemins)
Se connecter en ssh sur votre noeud umbrel
docker cp ~/votreimage.jpg $(docker ps | grep dashboard | awk '{print $1}'):/dist/wallpapers/1.jpg
```
  
ou copier/coller l'ID du container docker du dashboard à la place de `$(docker ps | grep dashboard | awk '{print $1}')`  
ou tout autre image wallpapers entre 1 et 16 (le code est comme ça, on peut pas mettre d'autres noms ou ajouter)  
```
 data() {
    return {
      wallpapers: ['1.jpg', '2.jpg', '3.jpg', '4.jpg', '5.jpg', '6.jpg', '7.jpg', '8.jpg', '9.jpg', '10.jpg', '11.jpg', '12.jpg', '13.jpg', '14.jpg', '15.jpg', '16.jpg']
    };
  },
```
  
Ca n'est pas permanent et "sautera" à la prochaine MAJ de l'image du dashboard ou reconstruction du container mais c'est easy à remettre.
