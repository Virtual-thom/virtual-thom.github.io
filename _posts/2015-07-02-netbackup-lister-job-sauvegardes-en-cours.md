---
layout: post
title: Lister les sauvegardes Netbackup en cours 
date: 2015-07-01 21:19
author: Virtual Thom
comments: true
categories: [netbackup,jobs, sauvegardes, en cours, shell, commande netbackup, awk, bpdbjobs]
---
Si le champ de la colonne n°3 de la commande netbackup `bpdbjobs -report -most_columns` est inférieur à 3, c'est qu'il y a des sauvegardes en cours, ou en préparation.

```bash
	bpdbjobs -report -most_columns | awk -F"," '{ if( $3 < 3 ){ print } }' 
```

Rien à voir avec les sauvegardes en cours, mais voici une autre commande netbackup que j'utilise beaucoup pour lister les policies (stratégies de sauvegarde)  et les clients : 

```bash
bppllist 

# Détails d'une policie
bppllist MAPOLICIE -U 

# Lister des policies en filtrant avec un client
bppllist -byclient MONCLIENT

# Lister les clients 
bpplclients

```