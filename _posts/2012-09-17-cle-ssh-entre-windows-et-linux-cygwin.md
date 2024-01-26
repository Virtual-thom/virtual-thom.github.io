---
layout: post
title: Mise en place clé ssh entre windows et unix/linux avec Cygwin
date: 2012-09-17 18:51
author: Virtual Thom
comments: true
categories: [clé ssh, cygwin, cygwin, Linux, linux, OS, sans mot de passe, scp, serveur sshd, shell, ssh, sshd, sshd, unix, windows]
---
Pour mettre en place des clés ssh entre windows et linux, j'utilise Cygwin.
Les clés ssh permettent notamment de copier, via scp, ou de se connecter, sans besoin de mettre de mot de passe (très utile dans les scripts).
Tout dépend dans quel sens vous voulez effectuer les connexions, mais globalement, si vous voulez faire du scp ou du ssh de linux vers votre windows, il vous faut un serveur sshd sur votre Windows. (Dans l'autre sens c'est moins compliqué)

Pour l'installation de Cygwin et la mise en place d'un serveur sshd sur Windows, j'ai suivi le très bon tutoriel de CommentCaMarche.
Lien vers la page : <a href="http://www.commentcamarche.net/faq/2132-reseaux-installation-d-un-serveur-ssh-sous-windows" title="reseaux-installation-d-un-serveur-ssh-sous-windows" target="_blank">Installation d'un serveur ssh sous Windows</a>
Comme c'est expliqué dans ce tutoriel, la sécurité semble ne pas être de mise. Mais cela reste bien pratique pour des environnements qui ne sont pas en production.

Vérifiez aussi que votre port 22 est bien ouvert (pare-feu)
J'ai rencontré quelques difficultés au niveau des droits de sécurité sous Windows (surtout pour lancer le service sshd). 
Exécutez en tant qu'Administrateur votre console Cygwin pour lancer ssh-host-config -y.
Une fois installé, vérifiez à ce que vos fichiers /etc/ssh* ne soient pas trop permissif. L'idéal semble être 600. 
Si vous avez des problèmes lors du lancement du service CYGWIN sshd, regardez le log /var/log/sshd.log. Il donne de bonnes pistes.

Mise en place des clés ssh : 
<ol>
<li>Créez le même utilisateur des deux côtés
<pre lang="bash">
useradd nomuser
</pre>
</li>
<li>Générez des clés ssh des deux côtés (rsa dans mon exemple)
<pre lang="bash">
ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/nomuser/.ssh/id_rsa): (appuyez sur entrée)
Enter passphrase (empty for no passphrase): (laissez vide sinon il faudra taper cette passphrase lors du ssh)
Enter same passphrase again:
Your identification has been saved in /home/nomuser/.ssh/id_rsa
Your public key has been saved in /home/nomuser/.ssh/id_rsa.pub
</pre>
Et modifiez les permissions des fichiers du répertoire /home/nomuser/.ssh/
<pre lang="bash">
chmod 600 /home/nomuser/.ssh/*
(attention si comme moi vous avez eu des problèmes, le groupe ne voulait pas être modifié. Il faut le passer de Aucun à Administrateurs.)
(chown -R :Administrateurs /home/nomuser/.ssh/*)
</pre>
Sinon vous aurez ce genre de message : 
<pre>
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions 0660 for '/home/nomuser/.ssh/id_rsa' are too open.
</pre>
</li>
<li>Connectez-vous au moins une fois en ssh pour que les hosts se "connaissent"
Cela va renseigner le fichier known_hosts
<code>ssh nommachine
The authenticity of host 'nommachine (10.0.0.1)' can't be established.
RSA key fingerprint is xx:xx:xx:xxx:xx:xx:xx:xx:xx.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'nommachine,10.0.0.1' (RSA) to the list of known hosts.</code>
</li>
<li>Rajoutez dans le fichier authorized_keys le contenu de id_rsa.pub de la machine qui veut se connecter en ssh.
Copiez le comme vous voulez mais voici une petite astuce qui évite d'avoir des retours chariots impromptus  :
<code>cat ~/.ssh/id_rsa.pub | ssh nommachine "cat >> ~/.ssh/authorized_keys"</code>
</li>
</ol>


