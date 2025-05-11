---
layout: post
title: Relance auto et Alarme VTOM
date: 2022-02-21 12:00:00
author: Virtual Thom
categories: [vtom,alarme]
---
Changement de comportement entre v5.8 et v6.5.1l sur les relances automatiques de job et les alarmes.  

![Documentation VTOM - alarmes]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/relance_auto_alarme.png)  

On utilise les alarmes pour créer des tickets incidents en rajoutant une ligne txt spécifique dans un fichier spécifique scruté par notre superviseur.  

L'ancien mode où l'alarme ne se déclenchait que sur le dernier RETRY en cas d'erreur me convenait mieux car on ne créait de ticket incident que dans ces cas-là. Les premières exécutions EN_ERREUR n'étaient pas remontées et c'était très bien (dans mon cas).  
J'ai bien pensé à mettre le déclenchement alarme si statut est en erreur depuis 5 sec par ex mais ça poserait deux soucis :  
 * si job finit à J+1 par ex (le statut en erreur ne resterait pas assez lgt avant la bascule de la date)
 * si le job a une tempo entre deux relances supérieure


J’ai remarqué que les relances auto étaient EN_DIFFICULTE dans le vtlist jobs_last_exec.  

Palliatif / bricollage à définir dans le corps du script de l'alarme :  
```cmd
FOR /F "tokens=* USEBACKQ" %%g IN (`powershell.exe -NoProfile -NoLogo -Command "( (vtlist jobs_last_exec -v -f {VT_JOB_FULLNAME}) -split '\s+')[3]"`) DO (
  IF "%%g" == "EN_ERREUR" (
    rem Do stuff here me echo in log file
    echo vtom: Error_Job_{VT_JOB_FULLNAME} - %date% %time:~0,5%[Inst]TECH[Inst] [Detail]  [Detail] [Sev]2[Sev] >> D:\VTOM\vtom_err.log
  )
)

```

