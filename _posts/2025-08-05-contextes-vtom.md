---
layout: post
slug: contextes vtom
title: Contextes VTOM
---
Industrialiser, c'est un mix de pleins de chose, entres autres : 
 * réfléchir au projet dans sa globalité, aux flux, aux arborescences, aux différentes plateformes, aux unités de soumission,
 * variabiliser,
 * scripter,
 * oserais-je dire automatiser,
 * démultiplier au besoin, déployer.

En ce sens, la 7.3 annonce ce que j'attendais pour enfin utiliser les CONTEXTES VTOM car ils seront attachables aussi sur les agents.  
Pour moi, c'est indisenpsable afin de pouvoir variabiliser les ressources (ress fichier si possible, distante pour sûr et, générique au pire)  
C'est tout ce qu'il manquait, les contextes fonctionnent déjà très bien sur les Env, App, Job : params, champ script, et à l'intérieur du script (variables d'environnement)  

Pour mon prochain client, c'est décider, je mets en place des Contextes dès le début.
Et en tous cas, je testerai ça mi-septembre sur la prochaine release.  

## Contextes, variables VTOM
*Le Contexte est utilisé pour transmettre des variables d’environnement au traitement à exécuter.*  

[Lien Docs Contextes VTOM](https://docs.absyss.com/vtom/731a/fr/Visual_TOM_Guide_Utilisateur/?h=contextes#le-contexte)  
![Docs contextes VTOM](/assets/img/contextes_variables_vtom.png)

Avec cette phrase, on a presque tout dit. 
Mais pas que. Comme VTOM évalue tout - dans ce cas, via moteur et serveur - ça fonctionne aussi bien dans les paramètres de job vtom (modèle de transferts compris), que dans les ressources génériques, qu'à l'interieur même d'un script.  

Typiquement, pour une Business Unit en particulier sur le client que j'avais, ça aurait éviter pas mal de règles de transformations de télédiffusion.  
Ne serait-ce que pour ça, je pense que ça vaut le coup.  
A la marge, il reste les alias de télédif des objets vtom : les Unités de soumission, agents, dates, ress, et éventuellement si nommage différents entre les plateformes (c'est souvent le cas).  
Mais quasi plus de transformation avec les Contextes.  

Tel que je le vois, mais j'aimerais bien vos retours d'expérience ou de pensées là-dessus, ça pourrait s'articuler comme ça :  
 * nommage du contexte : &lt;ENV&gt;(ou BU, ou Type d'application, etc)_&lt;fonction&gt;
    * exemple : MABU_PLATEFORME
 * contenu du contexte, les variables :

```
Honnêtement, ça fait un peu redondant, mais je pense qu'il faut préfixer chaque variable par quelque chose de reconnaissable du contexte (mais pas son nom, on verra après plusieurs contextes peuvent avoir la même variable et c'est le plus proche de l'objet qui aura le dernier mot - many to one).  

C'est juste histoire de comprendre quand on voit une variable dans un champ à quoi elle correspond. Eventuellement, préfixer par CXT par exemple aussi pourquoi pas (toujours pareil, pour d'un coup d'oeil voir que c'est une variable de contexte).  

CXT_MABU_PLT_COURT_MAJ = PRD (DEV pour la dev, REC pour la rec, PRD, pour la prod, etc.)
CXT_MABU_PLT_COURT_MIN = prd

CXT_MABU_PLT_LONG_MAJ = PROD (ou PRODUCTION, bref)
CXT_MABU_PLT_LONG_MIN = prod

CXT_MABU_PLT_UNDER_MAJ = _PROD
CXT_MABU_PLT_UNDER_MIN = _prod

bref autant qu'on veut avec les subtilités qu'on souhaite.  
```

 * variabiliser par exemple les paths dans les chemins de scripts, paramètres, ressources fichiers (ou remplacer par des génériques avec tfile si ça ne fonctionne pas), etc. :
   * exemple : /monpath/${CXT_MABU_PLT_COURT_MIN}/fluxpartenaireduchmol/reception
     * ou %CXT_MABU_PLT_COURT_MIN% pour du Windaube cmd ou $env:CXT_MABU_PLT_COURT_MIN pour du Powershell
   * donnerait :
     * en dev     : /monpath/dev/fluxpartenaireduchmol/reception
     * en recette : /monpath/rec/fluxpartenaireduchmol/reception
     * en préprod : /monpath/ppr/fluxpartenaireduchmol/reception
     * en prod    : /monpath/prd/fluxpartenaireduchmol/reception

```
Un truc en passant, il faut arrêter de supprimer en prod le nom de la plateforme.
genre /monpath/fluxpartenaireduchmol/reception au lieu de /monpath/prd/fluxpartenaireduchmol/reception  
Il faut spécifiquement nommé prd (ou autre) quand on est prod. Sinon, c'est transformation quasi obligatoire, avec les slash (antislash) aussi à supprimer, une horreur.  
```

Petits plus, c'est dans la doc :  
*Les contextes associés à l’Environnement peuvent être ajoutés dans l’onglet « Contextes » de l’Environnement. Ainsi, ils sont automatiquement transmis à ses Applications et Traitements ; si une même variable existe dans 2 Contextes, c’est celle du dernier de la liste qui est prise en compte*  

*Les Ressources Texte, Numérique, Secret, Pile, Générique et Fichier sont utilisables pour définir les valeurs des variables, qu’elles soient utilisées en tant que Contexte ou directement en variable ; la valeur de la Ressource générique correspond à son script, la valeur de la Ressource Fichier correspond à sa valeur préfixée du nom de l'agent entre parenthèses.*

On peut même appliquer plusieurs contextes sur un même serveur VTOM avec plusieurs plateformes (env de dev, rec par exemple en local sur le même serveur).  
Auquel cas, on aurait par exemple : 
 * le contexte nommé `MABU_PLATEFORME_DEV` attaché à l'environnement VTOM MABUE_DEV avec les valeurs de dev,
 `CXT_MABU_PLT_COURT_MIN = dev`
 * le contexte nommé `MABU_PLATEFORME`     attaché à l'environnement VTOM MABUE_REC avec les valeurs de rec,
 `CXT_MABU_PLT_COURT_MIN = rec`
 * bien garder le nom de contexte sans le nom de la plateforme sur l'environnement qui va servir à la télédiffusion (comme ça en PPR et PRD, il gardera le nom propre sans besoin d'Alias contexte)

## Télédiffusion d'instances
Je pense aux contextes surtout pour variabiliser les noms de plateformes (environnements applicatifs) mais ça peut aussi être vraiment pratique pour les cas de démultiplications - voir mon post sur [la télédiffusion en instances](/telediffusion-instance-vtom-modele-demultiplication-couloir.html).  

Exemple : on démultiplie notre modèle vtom ZZ en plusieurs caisses de banques comme dans mon post.  
On aura toujours les alias pour les noms d'objets VTOM (agents, u.s., commentaires, noms ress, env, app, job, etc.), mais on simplifie et économise une TONNE de transformations. Mais vraiment.  

On variabilise notre modèle ZZ (si démult sur app on placera le contexte modèle sur l'app) avec un contexte qui aura un alias dans la télédiff par instance (yes on peut faire ça).
Donc chaque app démultipliée aura son contexte par caisse de banque, c'est pile poil ce qu'on veut.  
Et l'avantage, c'est qu'on met autant de variables qu'on veut dans chaque contexte.  

NB : si jamais un jour tu fais ça Thom, penses à faire un contrôle d'exploitation ou de post livraison pour vérifier que chaque variable de contexte (préfixée par exemple) est bien existante dans au moins un des contextes hiérarchiques d'objet jusqu'à l'env - j'me comprends, désolé je me parle à moi même, c'est la vieillesse.  
