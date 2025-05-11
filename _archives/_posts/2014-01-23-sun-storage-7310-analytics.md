---
layout: post
title: Sun Storage 7310 Analytics
date: 2014-01-23 12:58
author: Virtual Thom
comments: true
categories: [SAN, Stockage, SUN, SUN Storage ZFS 7310]
---
Les Analytics permettent de monitorer en temps réel certaines statistiques.
Attention c'est assez gourmand. De préférence, les analytics sont à lancer pour une période donnée.

Pour cela, le mieux est de créer un "Worksheet" et d'ajouter les statistiques souhaitées.

<!--more-->

Prenons un exemple d'utilisation de la baie, des disques et des LUNs, depuis l'interface d'administration web :
<ol class="breadcrumb">
	<li>Analytics</li>
	<li>OPEN WORKSHEETS</li>
	<li class="active">Add statistic</li>
</ol>
<pre>   Disk: I/O operations per second broken down by latency
   Disk: Disks broken down by percent utilization
   Protocol: iSCSI operations per second broken down by type of operation
   Protocol: iSCSI operations per second broken down by size
   Protocol: iSCSI operations per second broken down by offset
   Protocol: iSCSI operations per second broken down by latency
   Protocol: iSCSI operations per second broken down by LUN
   Protocol: iSCSI bytes per second broken down by LUN
   Protocol: iSCSI operations per second broken down by client
</pre>
Ces statistiques remplissent des logs correspondent aux DATASETS. Lorsqu'une statistique est active, le DATASET se remplit (log sur disque et In core).

<span class="alert alert-warning" style="padding: 5px;">Attention !</span> Le fait de supprimer une worksheet ne suspend pas les statistiques de tourner et les datasets se remplissent.

Pour suspendre les DATASETS, ma méthode préférée passe par le mode commande en ssh sur la baie. C'est beaucoup plus rapide que de suspendre dans les DATASETS un par un.
En putty, se connecter sur la baie.
<ol class="breadcrumb">
	<li>analytics</li>
	<li>datasets</li>
	<li class="active">suspend</li>
</ol>
Si la hotline demande ces analytics, il faut suspendre les statistiques du worksheet et générer un support bundle. Depuis l'interface d'administration web :
<ol class="breadcrumb">
	<li>Analytics</li>
	<li>SAVED WORKSHEETS</li>
	<li class="active">Send a support bundle that includes this worksheet</li>
</ol>
Dans le cas où vous n'auriez pas d'accès vers l'extérieur pour joindre un support bundle par mail, il faut télécharger le support bundle (notez bien le nom du bundle que vous aura été fourni)
<ol class="breadcrumb">
	<li>Maintenance</li>
	<li>SYSTEM</li>
	<li class="active">Support Bundles</li>
</ol>
Et cliquer sur l’icône de téléchargement.
