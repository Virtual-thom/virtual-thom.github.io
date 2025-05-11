---
layout: post
title: Lister le contenu d'un répertoire Github en ajax 
date: 2015-02-28 09:14
author: Virtual Thom
categories: [ajax, github, lister, répertoire, images]
---
# But du jeu
* Héberger un site de photographies sur les [pages Github](https://pages.github.com/)
* Le site doit pouvoir récupérer dynamiquement les images push sur Github

# Démo 
[Laure Photographies](http://laure-photographies.github.io)

# Structure du site 
* img
  * &lt;prefix&gt;&lt;nom d'un répertoire menu images&gt;
  * img_dyptique (dyptique sera un menu)
    * image1.jpg
    * image2.jpg

# Méthode : ajax et API Github
Le principe est simple : il faut récupérer les informations du repository via l'API Github en ajax. 
Pas d'authentification, c'est juste du GET.

Les API Github :

* [repos](https://developer.github.com/v3/repos)
* [trees](https://developer.github.com/v3/git/trees)

* Récupérer le dernier commit du repository (son sha)

```javascript
$.ajax({
 url: "https://api.github.com/repos/laure-photographies/laure-photographies.github.io/branches",
 success: function(data){
  // récupération du dernier sha last commit du repos
  console.log(data[0].commit.sha) ;
 }
});
```

* Lister le contenu du répertoire img/ où se trouve les répertoires préfixés qui constitueront les menus

```javascript
$.ajax({
 // github_repo_sha qu'on a récupéré dans l'appel ajax précédant
 url: "https://api.github.com/repos/laure-photographies/laure-photographies.github.io/git/trees/"+github_repo_sha,
 success: function(data){
  
  // Récupération du sha du dossier img
  $.each(data.tree,function(){
   if( this.path == "img"){
    console.log(this.sha);
   }
  });
 }
});
```

* Lister les images du menu

```javascript
$.ajax({
 url: "https://api.github.com/repos/laure-photographies/laure-photographies.github.io/git/trees/"+img_sha,
 success: function(data){
  // data.tree array des items d'un menu
  $.each(data.tree,function(){
   // liste des noms des fichiers images
   console.log(this.path) ;
  });
 }
});
```

