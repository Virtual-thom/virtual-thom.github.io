---
layout: post
title: Exemple de Merge avec Pandas Python
date: 2017-10-10 12:00:00
author: Virtual Thom
categories: [python, csv, pandas, merge]
---
Note à moi même :

```
Merge method	SQL Join Name	Description
left	LEFT OUTER JOIN	Use keys from left frame only
right	RIGHT OUTER JOIN	Use keys from right frame only
outer	FULL OUTER JOIN	Use union of keys from both frames
inner	INNER JOIN	Use intersection of keys from both frames
```
Image docker : docker run -v D:\MonDossier\csvpandas:/mnt/workspace -t -i  fastgenomics/pandas bash

```python
import pandas as pd

csvDEV = pd.read_csv('/mnt/workspace/lastexecvtom_dev.csv',delimiter=r";",usecols=["ENV","APP","JOB","HOST","MODEAPP","MODEJOB"])
csvAllProd = pd.read_csv('/mnt/workspace/lastexecvtom_allprod.csv',delimiter=r";",usecols=["ENV","APP","JOB","HOST","MODEAPP","MODEJOB","DEBUT","FIN","STATUT","DOMAINE"])
csvIP = pd.read_csv('/mnt/workspace/ip.csv',delimiter=r";",usecols=["DOMAINE","HOST","HOSTNAME","IP"])
csvIP = csvIP.drop_duplicates()

merge1 = pd.merge(csvDEV,csvAllProd,how='outer', on=["ENV","APP","JOB","HOST"],indicator=True)

merge2 = pd.merge(merge1,csvIP,how='left', on=["HOST","DOMAINE"])

merge2.sort_values(by=['ENV','APP','JOB']).to_csv('/mnt/workspace/merged.csv',sep=";")
```
