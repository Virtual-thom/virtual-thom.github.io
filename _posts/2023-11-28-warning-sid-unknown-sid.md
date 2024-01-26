---
layout: post
title: WARNING SID UNKNOWN_SID vtexport
date: 2023-11-28 12:00:00
author: Virtual Thom
---
Si vous avez déjà eu ce genre de problème lors d'un vtexport filtré avec WARNING SID :

```
PS E:\temp> vtexport -x > e:\temp\vtexport.xml
vtexport elapsed time : 9s 147ms

PS E:\temp> vtexport -x -f * > e:\temp\vtexport.xml
WARNING SID 'DAT752' not found in map 'date'.
WARNING SID 'RES1b2d' not found in map 'ressource'.
WARNING SID 'DAT753' not found in map 'date'.
WARNING SID 'RES1b2b' not found in map 'ressource'.
Le controle d'integrite a detecte des anomalies, vtexport interrompu 
```

Rajoutez /forceExport à votre commande et faites une recherche de "UNKNOWN_SID" à l'intérieur de l'export pour voir les objets impactés.  
Avec un peu de chance, un simple "Définir et OK" sur l'objet résoudra le problème.  
Sinon copier / coller l'app ou le job en question vu dans l'export avec "UNKNOWN_SID" et supprimer l'ancien (bourrin mais ça fonctionne, attention à vos liens, mise en exploit, tout ça).

