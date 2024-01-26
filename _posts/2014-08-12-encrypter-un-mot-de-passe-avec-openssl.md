---
layout: post
title: Encrypter un mot de passe avec openssl
date: 2014-08-12 12:32
author: Virtual Thom
comments: true
categories: [encoder mot de passe, encrypter, Linux, openssl, Script, shell]
---
J'ai souvent besoin d'écrire des scripts avec utilisateur et mot de passe de connexion. Je ne trouve pas très glamour le fait d'avoir le mot de passe en dur dans les scripts.

Voici ma manière de procéder pour avoir un semblant de sécurité pour masquer le mot de passe, avec openssl.

<!--more-->
Exemple d'encodage et décodage d'un mot de passe. Personnellement, je fais un petit script pour créer un fichier dans lequel sera stocké le mot de passe encrypté, que je pourrais décrypter avec le mot de passe de salage (passphrase). Ca évite aussi que le mot de passe se retrouve en clair dans l'history de votre shell.
Je change les droits en 700 pour le script et le fichier généré. Ca évite que d'autres personnes que le propriétaire puissent le lire.
Encodage, peu importe la passphrase mais elle doit être la même au décodage (vous pouvez aussi utiliser une variable d'environnement, comme ceci : -pass env:mavariable)
<pre lang="bash">read -s mdp # taper une fois votre mot de passe (-s = silence / invisible)
echo $mdp | openssl enc -e -aes-256-cbc  -pass pass:votrepassphrase > luke.dat # peu importe le nom et l'extension
</pre>
Décodage, que vous pouvez inclure dans vos scripts. (j'ai mis 700 sur luke.dat et ne peut être décodé que par le owner du fichier, mais vous pouvez changer selon les besoins)
<pre lang="bash">openssl enc -d -aes-256-cbc -in luke.dat -pass pass:votrepassphrase
</pre>
Stockez le résultat de cette commande dans une variable ou afficher le résultat directement dans vos script. Je vous invite à voir un exemple d'utilisation sur mon article <a title="Element Manager API, ou API web pour le VPLEX" href="/api-vplex-restful/">API web VPLEX</a>.
