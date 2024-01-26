---
layout: post
title: Parcel bundler - Dev Web
date: 2018-02-26 20:14
author: Virtual Thom
categories: [parcel, parcel-bundler, developpement, web, js, javascript, es6]
---
Après quelques projets web montés avec webpack, je suis tombé sur `parcel-bundler` grace à Grafikart.

C'est tellement plus simple ! Webpack est beaucoup trop compliqué à configurer. On passe plus de temps à peaufiner la conf qu'à écrire l'application.

En gros `parcel-bundler` et vous êtes good to go pour dev en ECMAScript 6  et autres fioritures intéressantes dont on rafole en tant que dev web (build une distribution de prod minifié, un seul fichier css, js, etc.)

Si besoin de convertir en ES5 pour plus de compatibilité navigateur,il suffira d'installer le module babel. Voir les liens utiles. Grafikart montre ça très bien `npm install -D babel-preset-env` et rajout du fichier `.babelrc`.

Si vous installez parcel localement `npm install -D parcel-bundler`, et que vous voulez l'exécuter en ligne de commande, le binaire `parcel` est sous `node_modules/.bin/parcel`

(dans la clé "scripts" du package.json pas besoin de mettre le full path, npm "sait" qu'il faut aller chercher dans ./node_modules/.bin/)

# Petit exemple

`package.json`
```
{
  "name": "top100exportoracle",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "build": "parcel build --public-url ./ index.html",
    "dev": "parcel index.html",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "babel-cli": "^6.26.0",
    "babel-preset-env": "^1.6.1",
    "bootstrap": "^4.0.0",
    "node-sass": "^4.7.2",
    "parcel-bundler": "^1.6.2"
  }
}
```

`index.html`
```
...
<link rel="stylesheet" href="./src/styles/index.scss">
...
<img src="./src/images/logo.png">
...
<script src="./src/js/index.js"></script>
```

`src/index.js` (on se fiche du code, c'est juste pour montrer qu'on peut utiliser du code en ES6, importer des modules, des js, css, utiliser les classes,  etc.)
```javascript
class Stats{
    constructor() {
        this.rows = new Array()
        
        this.orderby = ""

        this.vue = "lastexec"
        
        this.filters = {
            'vtenvname': [],
            'appsjobsstopdem': "",
            'vtbegin-to': "",
            'vtbegin-from': ""
        }
        ...
        ...
}
import { getURLAPI } from './confidentials'
var urlAPI = getURLAPI()

let allStats = new Stats()
allStats.setTrHead()
// mise à jour du table header
let trTh = document.createElement("tr")
allStats.trHead.forEach((th, i) => {
    trTh.innerHTML += "<th data-col='"+allStats.trHeadLastExecDataset[i]+"'>" + th + "</th>"
})
...
```

`index.scss`
```
@import "custom_bootstrap"; 
#maincontainer {
    min-height: 800px;
    border-radius: 0 0 10px 10px;
    color: $purple;
}

#switchform,thead th {
    cursor: pointer;
}
```

`custom_bootstrap.scss` 
```
// on peut surdéfinir bootstrap ici
// violet chez nous
$purple: #691F75 !default;

@import "./../../node_modules/bootstrap/scss/bootstrap";
```


```
    mon package.json ou à la main
    "build": "./node_modules/.bin/parcel build --public-url ./ index.html",
    "dev": "./node_modules/.bin/parcel index.html",
    
npm run build
npm run dev
```

THAT SIMPLE ! 

# Liens utiles

[site officiel Parcel avec la documentation](https://parceljs.org)

[Excellente vidéo de Grafikart sur Parcel](https://www.grafikart.fr/tutoriels/javascript/parcel-bundler-985)

[Encore une vidéo de Grafikart afin d'appréhender les nouveautés ES6](https://www.grafikart.fr/formations/debuter-javascript/ecmascript-2015)

[Compatibilité et support des features par navigateur](https://caniuse.com/)
