---
layout: post
title: API Rest VTOM
date: 2021-09-21 12:00
author: Virtual Thom
categories: [api, REST, Visual TOM, VTOM]
---
A partir de la v6.4, Absyss met à disposition des APIs REST officielles, et soutenues.

Si vous connaissez les VITO (bande de veinards) et les groupes de travail des tables rondes, vous savez certainement que l'évolution du produit se dirigie vers une interface full web. Et qui dit interface web, dit API Rest en arrière plan.  
Et moi qui croyais que les API avaient été faites pour nos beaux yeux ! (bon si ça nous fait plaisir, ça ne mange pas de pain :))
  
Si vous suivez mon blog, vous devez connaître les API non officielles du web access. Déjà bien pratiques, elles n'avaient qu'un but à la base, faire fonctionner la partie Web Access proposée par Absyss.  
Nous dansions alors sur un seul pied quant à les utiliser en PROD, puisque non soutenues et non prévues pour ce que nous voulions en faire (bien souvent des outils perso web ou script pour requêter la base plutôt que d'utiliser les vtlist, vtstools ou autres).  
Et alors là, pour le coup, ils ont fait fort.   
Nouveau process dédié (Absyss API REST: vtapiserver), une documentation visuelle avec Swagger UI, des clés de sécurité avec des stratégies poussées (chaque clé n'a accès qu'à ce qu'on veut et a une portée bien définie - bon on peut tout mettre aussi)  

Le billet ne sera donc pas très poussé car toute la doc' est déjà sur le produit. Je vais juste vous montrer comment rajouter une clé et commencer à faire quelques requêtes.  
<!--more-->
 * Je passe l'installation, la configuration et le démarrage du nouveau process vtapiserver (voir la doc VTOM)
 * Si comme moi vous avez le bouton "Sécurité du serveur API" grisé, il faut rajouter l'option dans votre profil de compte VTOM (forcément nouvelle fonctionnalité)
 * Sur l'IHM dans Outils > Sécurité du Serveur API > Onglet Stratégies > + (de base tout est sélectionné)
![API VTOM IHM Outils Sécurité du serveur - Stratégies]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/API_VTOM_outils_securite_strategies.jpg)
 * Sur l'IHM dans Outils > Sécurité du Serveur API > Onglet Jetons > + et sélectionner une (des) stratégie(s)
![API VTOM IHM Outils Sécurité du serveur - Jetons]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/API_VTOM_outils_securite_jetons.jpg)
 * Le champ "clé" est votre jeton pour l'authentification dans les APIs
 * Partie Swagger UI : htts://localhost:30002/swagger-ui
 * Sélectionner une définition, un champ des API : domain (référentiel VTOM), monitoring (tout ce qui est status - de ce que j'ai vu pas de liste complète des status, dommage j'attendais ça, il faut requêter chaque item, mon petit doigt m'a dit que ça allait être intégré dans les futures versions, état des moteurs etc.), security
![API VTOM Swagger UI - Definition]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/API_VTOM_swagger-ui_definition.jpg) 
 * Rentrer la clé / le jeton pour s'authentifier (copier/coller la clé généré dans l'IHM VTOM)
![API VTOM Swagger UI - Authorization]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/API_VTOM_swagger-ui_authorization.jpg)
 * Requêter (curl, javascript fetch ou autre, postman, etc.), deux possibilités : 
   * Dans le header : ex `{'x-api-key': 'jeton'}`
   * En parameters / query : ex `?api_key=jeton`
![API VTOM Request - Headers]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/API_VTOM_request_authorization_headers.jpg)
![API VTOM Request - Parameters]({{ site.baseurl | prepend: site.url }}/wp-content/uploads/API_VTOM_request_authorization_parameters.jpg)

Amusez-vous bien !
