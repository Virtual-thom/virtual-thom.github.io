---
layout: post
title: Netlify déploiement continu gratuit
date: 2020-02-12 09:00
author: Virtual Thom
comments: true
categories: [devOps, nodejs, parcel, deno, Netlify]
---
Petit exemple de site : [https://thomax.netlify.com/](https://thomax.netlify.com/). Le code de ce site est hébergé sur Github [monsite](https://github.com/virtual-thom/monsite). A chaque commit sur la branch de mon choix (master), le déploiement du site statique est effectué par [Netlify](https://netlify.com). Le build se fait avec [Parcel Bundler](https://parceljs.org/) que j'adore pour sa simplicité.
A petite échelle, c'est ce qu'on appelle du déploiement continu. 

J'ai outrageusement pompé l'idée et la façon de faire de Ryan Dahl (juste le développeur de NodeJS qui planche en ce moment sur le successeur de son bébé : Deno. Le site [deno.land](https://deno.land) utilise à peu près le même principe de déploiement, au Cloudflare worker près - qui lui sert à présenter de l'html ou du code raw brut selon si on a un header navigateur ou si c'est un appel API par ex - et son front qui est codé en React)

<!--more-->
# Prix
Netlify est Gratuit pour sa version de base. C'est un peu fou mais pas plus qu'un site perso en Jekyll sur Github après tout. (truc complètement fou aussi mais qui n'a rien à voir : Gefoce Now est gratuit aussi pour sa version de base et permet de jouer en ligne avec leur puissance compute et graphique, à vos jeux steam par ex, 0 download, c'est fou. Je ne sais même pas comment c'est possible. J'imagine les coûts d'une telle infra' : vpn, compute, GPU, hébergement des images de jeux, etc)

# Comment mettre en oeuvre
 * Avoir un compte Github et l'utiliser très classiquement (rien de change de ce côté là). Repo, coder, avoir une branche principale, publier.
 * Avoir un nom de domaine à vous si vous voulez le faire correspondre à votre site déployé sur Netlify. Sinon, notamment pour des besoins de Dev, Netlify fournit un DNS, sous-domaine de son domaine Netlify.com (personnalisable en plus).
 * Créer un compte Netlify et rajouter le lien vers son repo/branch Github (Tout est très intuitif)
 `Create a new site` &gt; `Continuous Deployment` en selectionnant Github (ou autre fournisseur git). Personnellement, je n'ai autorisé que le repo' que je souhaitais à Netlify.
 * Configurer le `Build & Deploy`
```
Build settings
Repository : github.com/virtual-thom/monsite
  Donc ça, c'est mon repo Github
Base directory : Not set
  Pour mon besoin, je n'ai pas besoin de changer de répertoire de base. Le workflow clone/pull les derniers commit et se place directement à la racine.
Build command : npm run build
  Ceci est un exemple, dans mon cas - Parcel Bundler - j'ai fait un npm init dans mon projet et j'ai rajouté la commande script dans package.json suivante : 
  "scripts": {
    "build": "parcel build index.html",
  }
Publish directory : dist
  Dans mon cas, parcel build va construire le site et le déposer dans le répertoire dist
```

Et voilà. Pas plus compliqué. Dès qu'on modifie la branche configurée, et qu'on push, un webhook de Netlify se déclenche, suivi du process de build & deploy. A noter que dans le process, le `npm install -y` est automatique et télécharge tous les node_modules nécessaires.
