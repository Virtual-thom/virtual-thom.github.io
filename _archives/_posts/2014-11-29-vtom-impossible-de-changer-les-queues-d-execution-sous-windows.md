---
layout: post
title: Impossible de changer les Queues d'exécution sous Windows
date: 2014-11-29 18:39
author: Virtual Thom
comments: true
categories: [queue, queue_execution, VTOM, VTOM, Windows, windows]
---
Alors celle-là, si on ne la sait pas, on ne peut pas l'inventer. 
Ca vous est peut-être déjà arrivé ? Vous voulez changer les queues d'exécution sur un client Windows et rien n'y fait. Vous modifiez le %systemroot%\vtom.ini en rajoutant votre queue /queue\_maqueue:nbMaxExecSimultanées, vous relancez le client et queue_maqueue n'est toujours pas prise en charge par le client VTOM.


Pour rappel, installation d'une queue sous <a href="/ecrire-sa-queue-batch-vtom-cygwin-php-perl/#install_windows" title="Ecrire sa queue batch VTOM (cygwin, php, perl, sap)">Windows</a>.
Une fois que ces éléments sont bien modifiés, je vous invite d'ailleurs à redémarrer votre client VTOM et à faire un %ABM_BIN%\bstat pour bien vérifier quelles sont les queues d'exécution prises en compte sur votre client.

<h2>La solution :</h2>
En fait, c'est tout bête. Selon votre configuration Windows, si vous avez mis un utilisateur particulier de connexion dans votre service AbsyssBatchManager (disons LukeSkywalker), il faut aller dans %userprofile%\Windows\vtom.ini (en gros dans C:\Users\LukeSkywalker\Windows\vtom.ini).

Merci à Fred :)
