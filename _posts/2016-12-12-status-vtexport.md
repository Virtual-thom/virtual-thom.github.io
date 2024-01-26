---
layout: post
title: Statuts dans le vtexport
date: 2016-12-12 20:45
author: Virtual Thom
categories: [vtom, status, vtexport]
---
Code couleur des statuts dans VTOM.  

        R = ENCOURS       #05FAFA
        X = ENDIFFICULTE  #FFC800
        W = AVENIR        #FAFF14
        F = TERMINE       #14FF14
        E = ENERREUR      #FA0000
        D = DEPLANIFIE    #C3C3C3
        U = NONPLANIFIE   #FAFAFA

```json
{
  "R" : {"rvb":"5,250,250","nom":"ENCOURS"},
  "X" : {"rvb":"255,200,0","nom":"ENDIFFICULTE"},
  "W" : {"rvb":"250,255,20","nom":"AVENIR"},
  "F" : {"rvb":"20,255,20","nom":"TERMINE"},
  "E" : {"rvb":"250,0,0","nom":"ENERREUR"},
  "D" : {"rvb":"195,195,195","nom":"DEPLANIFIE"},
  "U" : {"rvb":"250,250,250","nom":"NONPLANIFIE"}
}
```

Et la column vtstatus dans la table vt_stats_job : (index de 0 à 6)

```
let Status = ["", "AVENIR ", "ENCOURS", "TERMINE", "ENERREUR", "DEPLANIFIE", "NONPLANIFIE"]
# mode d'exécution
let VTOMModeExec = ["", "Exéc", "Simu", "Test", "Stop", "Job"]
```
