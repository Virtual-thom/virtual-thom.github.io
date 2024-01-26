---
layout: post
title: Les variables d'environnement avec VTOM
date: 2017-03-16 23:07:05
author: Virtual Thom
categories: [unix, vtom, variables d'environnement, .profile, profil, startup files, shell, ksh, bash, csh]
---

unix : si ce n'est à l'intérieur des scripts même, les variables d'environnement sont souvent regroupées à un seul endroit dans les fichiers de démarrage (et sont disponibles pour l'ensemble des scripts)
 
 * ces fichiers de démarrage (startup files) peuvent être différents selon les shells utilisés : [Lien vers un article clair et précis sur ces fichiers](https://kb.iu.edu/d/abdy) / [lien alternatif](/wp-content/uploads/startup_files_shells.pdf)
 * Si on ne devait retenir qu'une chose, ce serait ces fichiers du répertoire `home` des utilisateurs de soumission selon les shells :
   * ksh, sh, bash : `.profile`
   * csh, tcsh : `.cshrc`
   * zsh : `.zprofile`
 * les variables d'environnement exportées sur la session de l'utilisateur d'administration (en général `vtom`) sont prises en compte lors du démarrage du client VTOM (`adminc` ou `start_client`)
 
   Résultat : j'ai des gens "bien intentionnés" qui m'ont surchargé le `.profile` du user `vtom` avec des variables d'env qui n'avaient rien à faire là
   
   Au cas où, il faut bien recharger le profil par ex. `. .profile` avant de relancer le client si vous avez apporté des modifications sur le .profile de vtom
