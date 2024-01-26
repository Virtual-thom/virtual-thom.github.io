---
layout: post
title: Déployer une application Sails JS (framework Node.js) sur Openshift - gratuit
date: 2014-08-24 23:10
author: Virtual Thom
comments: true
categories: [héberger sails js gratuitement, node, node js, sails, sails js openshift, Script, shell, ssh]
---
Je me mets à Node.js et plus particulièrement au framework Sails JS. Pour déployer mon application, il me fallait une solution robuste et un service gratuit qui puisse héberger du Node js.
C'est là que j'ai découvert <a href="https://www.openshift.com/" title="openshift">Openshift</a>.

Le service de RedHat offre carrément l'accès à une VM en ssh et la possibilité de déployer n'importe quelle type d'application (j'ai aussi une base MongoDB qui tourne).

Tout est plutôt bien expliqué sur le site mais rien de très clair pour le framework Sails js. C'est l'objet de cet article.

&lt;edit 16/01/2015&gt;J'ai trouvé encore mieux ! <a href="https://c9.io/">Cloud9</a>. Environnement de développement complet sur le Cloud, gratuit.&lt;/edit&gt;

Je suppose que votre application fonctionne déjà sous sails js en local sur votre machine.

# Procédure
1. Ouvrir un compte sur <a href="https://www.openshift.com/" title="openshift">Openshift</a> (le plus petit est gratuit)
2. Déployer un gear / application Node JS depuis l'interface web d'openshift
3. Définir une clé ssh en copiant votre clé publique locale (bien souvent ~/.ssh/id_rsa.pub, sinon lancer ssh-keygen)<a href="/wp-content/uploads/openshift.png"><img src="/wp-content/uploads/openshift-300x149.png" alt="openshift" /></a>
4. Sauvegarder votre application locale pour être sûr de ne rien casser
5. Effectuer un git clone de l'adresse de votre application (copier depuis Source Code dans l'interface web d'openshift

```
cd votre_repertoire_de_travail
git clone ssh://votre_id@app-namespace.rhcloud.com

```

6. Supprimer tout le contenu du répertoire que vous avez cloné, excepté le répertoire .git

```
cd /votre_repertoire_de_travail/app
rm -Rf votre_repertoire_de_travail/app
```

7. Copier l'intégralité de votre application sails js dans le répertoire

```
cp -Rp /votre_app_sauvegardée/* /votre_repertoire_de_travail/app/
```

8. Pousser les informations sur openshift avec git

```
cd /votre_repertoire_de_travail/app/
# modifier le fichier config/models.js, passer l'attribut migrate à 'safe', 'alter' ou 'drop' selon ce que vous voulez

# renseigner bien votre fichier package.json qui devra comprendre toutes les dépendances de votre application 
# c'est une étape indispensable car le processus appliquera les dépendances lors du git push grâce à package.json

git add *
git commit -m "date_du_jour premier push"
git push --set-upstream origin master
#par la suite un simple git push suffira pour pousser les modifications (ici on établit la relation origin master) 
```

9. Se connecter en ssh sur votre VM (voir remote access dans l'interface d'administration openshift)
10. Ajouter ou modifier le fichier config/local.js pour ajouter le port web correct et ne plus utiliser le port 1337 par défaut

```
cd $OPENSHIFT_REPO_DIR
vi config/local.js

module.exports = {
port: process.env.OPENSHIFT_NODEJS_PORT || 8080,
host: process.env.OPENSHIFT_NODEJS_IP
}
```

11. Arrêter et redémarrer votre application

```
killall node
node app.js
```


Et voilà !
