---
layout: post
title: Javascript fonction unique (distinct) sur un tableau d'objet
date: 2016-10-25 22:10:04
author: Virtual Thom
categories: [javascript]
---
## Mon besoin en Javascript 
J'ai un tableau d'objets, et je veux récupérer un tableau de valeurs uniques d'objets ayant le même attribut.

## Fonction

```javascript
let _distinctUniqueValuesInArray = (arr, prop) => arr.map(obj => obj[prop]).filter((v, i, a) => a.indexOf(v) == i)
```

## Exemple

```javascript
var monArray = [
{"VTENVNAME":"ENV1","VTDOMAINE":"MONDOMAINE25","NB_JOBS_NON_STATS":"15"},
{"VTENVNAME":"ENV2","VTDOMAINE":"MONDOMAINE15","NB_JOBS_NON_STATS":"58"},
{"VTENVNAME":"ENV2","VTDOMAINE":"MONDOMAINE35","NB_JOBS_NON_STATS":"18"},
{"VTENVNAME":"ENV2","VTDOMAINE":"MONDOMAINE25","NB_JOBS_NON_STATS":"50"},
{"VTENVNAME":"ENV5","VTDOMAINE":"MONDOMAINE36","NB_JOBS_NON_STATS":"2"},
{"VTENVNAME":"ENV5","VTDOMAINE":"MONDOMAINE26","NB_JOBS_NON_STATS":"10"},
{"VTENVNAME":"ENV7","VTDOMAINE":"MONDOMAINE26","NB_JOBS_NON_STATS":"81"},
{"VTENVNAME":"ENV7","VTDOMAINE":"MONDOMAINE36","NB_JOBS_NON_STATS":"47"},
{"VTENVNAME":"ENV7","VTDOMAINE":"MONDOMAINE16","NB_JOBS_NON_STATS":"71"},
{"VTENVNAME":"ENV8","VTDOMAINE":"MONDOMAINE25","NB_JOBS_NON_STATS":"45"},
{"VTENVNAME":"ENV8","VTDOMAINE":"MONDOMAINE15","NB_JOBS_NON_STATS":"31"},
{"VTENVNAME":"ENV8","VTDOMAINE":"MONDOMAINE35","NB_JOBS_NON_STATS":"62"},
{"VTENVNAME":"ENV13","VTDOMAINE":"MONDOMAINE36","NB_JOBS_NON_STATS":"2"},
{"VTENVNAME":"ENV13","VTDOMAINE":"MONDOMAINE16","NB_JOBS_NON_STATS":"2"},
{"VTENVNAME":"ENV13","VTDOMAINE":"MONDOMAINE26","NB_JOBS_NON_STATS":"2"},
{"VTENVNAME":"ENV14","VTDOMAINE":"MONDOMAINE16","NB_JOBS_NON_STATS":"56"},
{"VTENVNAME":"ENV14","VTDOMAINE":"MONDOMAINE36","NB_JOBS_NON_STATS":"29"},
{"VTENVNAME":"ENV14","VTDOMAINE":"MONDOMAINE26","NB_JOBS_NON_STATS":"77"},
{"VTENVNAME":"ENV15","VTDOMAINE":"MONDOMAINE26","NB_JOBS_NON_STATS":"164"},
{"VTENVNAME":"ENV15","VTDOMAINE":"MONDOMAINE36","NB_JOBS_NON_STATS":"90"},
{"VTENVNAME":"ENV15","VTDOMAINE":"MONDOMAINE16","NB_JOBS_NON_STATS":"139"},
{"VTENVNAME":"ENV16","VTDOMAINE":"MONDOMAINE16","NB_JOBS_NON_STATS":"113"},
{"VTENVNAME":"ENV16","VTDOMAINE":"MONDOMAINE36","NB_JOBS_NON_STATS":"123"},
{"VTENVNAME":"ENV16","VTDOMAINE":"MONDOMAINE26","NB_JOBS_NON_STATS":"410"}
]
_distinctUniqueValuesInArray(monArray,"VTDOMAINE")
```

```
["MONDOMAINE25", "MONDOMAINE15", "MONDOMAINE35", "MONDOMAINE36", "MONDOMAINE26", "MONDOMAINE16"]
```

```
_distinctUniqueValuesInArray(monArray,"VTENVNAME")
```

```
["ENV1", "ENV2", "ENV5", "ENV7", "ENV8", "ENV13", "ENV14", "ENV15", "ENV16"]
```

## Pour aller plus loin

[Array.prototype.map()](https://developer.mozilla.org/fr/docs/Web/JavaScript/Reference/Objets_globaux/Array/map)

Mon talbeau d'entrée étant constitué d'objets, et ne voulant qu'un tableau de valeurs pour une clé donnée, je créé un nouveau tableau avec map qui satisfait mes besoins.

`(arr, prop) => arr.map(obj => obj[prop])`

[Array.prototype.filter()](https://developer.mozilla.org/fr/docs/Web/JavaScript/Reference/Objets_globaux/Array/filter)
[Array.prototype.indexOf()](https://developer.mozilla.org/fr/docs/Web/JavaScript/Reference/Objets_globaux/Array/indexOf)

Comme map() retourne un tableau, je peux l'enchainer avec filter()

Je ne retourne que les élements qui vérifient ma condition. 

v (valeur), i (index), a (le tableau complet, ici monnouveautableau qui correspond à arr.map(obj => obj[prop]))

`monnouveautableau.filter((v, i, a) => a.indexOf(v) == i)`

En français : on boucle sur tous les élements de monnouveautableau et on retourne chaque élément dans un nouveau tableau si son index (i) correspond à l'index du premier élément (indexOf) de monnouveautableau qui a la valeur v.

Je ne sais pas si c'est français, mais j'me comprends !


# sort sur un tableau de tableaux sur plusieurs index
[https://stackoverflow.com/a/2784879](https://stackoverflow.com/a/2784879)

```js
Array.prototype.deepSortAlpha= function(){
    var itm, L=arguments.length, order=arguments;

    var alphaSort= function(a, b){
        a= a.toLowerCase();
        b= b.toLowerCase();
        if(a== b) return 0;
        return a> b? 1:-1;
    }
    if(!L) return this.sort(alphaSort);

    this.sort(function(a, b){
        var tem= 0,  indx=0;
        while(tem==0 && indx<L){
            itm=order[indx];
            tem= alphaSort(a[itm], b[itm]); 
            indx+=1;        
        }
        return tem;
    });
    return this;
}

monArr = [
  ["EVOLAN", "libéléEVOLAN2", "applEVOLAN", "jobEVOLAN", "domEVOLAN", "caisse1", "endEVOLAN", "YES"],
  ["ALIS", "libéléALIS2", "applALIS", "jobALIS", "domALIS", "caisse2", "endALIS", "YES"],
  ["ALIS", "libéléALIS", "applALIS", "jobALIS", "domALIS", "caisse2", "endALIS", "YES"],
  ["ALIS", "libéléALIS", "applALIS", "jobALIS", "domALIS", "caisse3", "endALIS", "NO"],
  ["EVOLAN", "libéléEVOLAN", "applEVOLAN", "jobEVOLAN", "domEVOLAN", "caisse1", "endEVOLAN", "YES"],
  ["IAM", "libéléIAM1", "applIAM", "jobIAM", "domIAM", "caisse1", "endIAM", "YES"],
  ["IAM", "libéléIAM", "applIAM", "jobIAM", "domIAM", "caisse1", "endIAM", "YES"],
  ["OUI", "libéléOUI", "applOUI", "jobOUI", "domOUI", "caisse1", "endOUI", "YES"],
  ["ALIS", "libéléALIS2", "applALIS", "jobALIS", "domALIS", "caisse2", "endALIS", "NO"],
  ["EVOLAN", "libéléEVOLAN3", "applEVOLAN", "jobEVOLAN", "domEVOLAN", "caisse1", "endEVOLAN", "YES"],
  ["ALIS", "libéléALIS", "applALIS", "jobALIS", "domALIS", "caisse1", "endALIS", "YES"],
  ["IAM", "libéléIAM3", "applIAM", "jobIAM", "domIAM", "caisse1", "endIAM", "NO"],
  ["IAM", "libéléIAM2", "applIAM", "jobIAM", "domIAM", "caisse1", "endIAM", "NO"],
  ["IAM", "libéléIAM", "applIAM", "jobIAM", "domIAM", "caisse2", "endIAM", "NO"]
]
monArr.deepSortAlpha(0,1,7)
(14) [Array(8), Array(8), Array(8), Array(8), Array(8), Array(8), Array(8), Array(8), Array(8), Array(8), Array(8), Array(8), Array(8), Array(8)]
0:(8) ["ALIS", "libéléALIS", "applALIS", "jobALIS", "domALIS", "caisse3", "endALIS", "NO"]
1:(8) ["ALIS", "libéléALIS", "applALIS", "jobALIS", "domALIS", "caisse2", "endALIS", "YES"]
2:(8) ["ALIS", "libéléALIS", "applALIS", "jobALIS", "domALIS", "caisse1", "endALIS", "YES"]
3:(8) ["ALIS", "libéléALIS2", "applALIS", "jobALIS", "domALIS", "caisse2", "endALIS", "NO"]
4:(8) ["ALIS", "libéléALIS2", "applALIS", "jobALIS", "domALIS", "caisse2", "endALIS", "YES"]
5:(8) ["EVOLAN", "libéléEVOLAN", "applEVOLAN", "jobEVOLAN", "domEVOLAN", "caisse1", "endEVOLAN", "YES"]
6:(8) ["EVOLAN", "libéléEVOLAN2", "applEVOLAN", "jobEVOLAN", "domEVOLAN", "caisse1", "endEVOLAN", "YES"]
7:(8) ["EVOLAN", "libéléEVOLAN3", "applEVOLAN", "jobEVOLAN", "domEVOLAN", "caisse1", "endEVOLAN", "YES"]
8:(8) ["IAM", "libéléIAM", "applIAM", "jobIAM", "domIAM", "caisse2", "endIAM", "NO"]
9:(8) ["IAM", "libéléIAM", "applIAM", "jobIAM", "domIAM", "caisse1", "endIAM", "YES"]
10:(8) ["IAM", "libéléIAM1", "applIAM", "jobIAM", "domIAM", "caisse1", "endIAM", "YES"]
11:(8) ["IAM", "libéléIAM2", "applIAM", "jobIAM", "domIAM", "caisse1", "endIAM", "NO"]
12:(8) ["IAM", "libéléIAM3", "applIAM", "jobIAM", "domIAM", "caisse1", "endIAM", "NO"]
13:(8) ["OUI", "libéléOUI", "applOUI", "jobOUI", "domOUI", "caisse1", "endOUI", "YES"]
```
