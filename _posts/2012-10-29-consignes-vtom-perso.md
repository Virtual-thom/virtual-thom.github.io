---
layout: post
title: Consignes VTOM perso
date: 2012-10-29 21:00
author: Virtual Thom
categories: [consignes, Ordonnancement, PHP, php, Script, Visual TOM, Visual TOM, VTOM, VTOM]
---
Je suis sûr que vous avez vos Dossiers d'Exploitation ou vos consignes en cas d'abort bien rangé sur votre site de production ou de gestion électronique de document. Et vous aimeriez bien faire un clique droit sur votre application ou traitement, puis Consignes pour avoir la page ou le document en rapport avec ces derniers.

Créez votre consigne dans VTOM et donner lui le nom que vous voulez (consigne_monsite par exemple)

Donnez lui la page php qui va traiter votre requête et les noms d'environnement, application et traitement en paramètres comme ceci : http://votresite/vtom.php?{VT\_ENVIRONMENT\_NAME}.{VT\_APPLICATION\_NAME}.{VT\_JOB\_NAME}
Vous appliquerez cette consigne sur tous les traitements ou applications que vous souhaitez. Il suffit de la rajouter dans la définition.

Petit exemple de ma page vtom.php

```
<?php

$repBase = 'f:/DE/DE/' ; // répertoire de base des Dossiers d'Exploitation
$isFilePresent = $env = $app = $job = false ;

$EnvAppJobTab = split('\.',$_SERVER['QUERY_STRING']); // QUERY_STRING = retour du clique droit sur un élément dans VTOM
if($EnvAppJobTab[0])
	$env = $EnvAppJobTab[0] ;
if($EnvAppJobTab[1])
	$app = $EnvAppJobTab[1] ;
if($EnvAppJobTab[2])
	$job = $EnvAppJobTab[2] ;

if($env){
	if($handle = opendir($repBase . $env )){
		while( false !== ( $entry = readdir($handle) ) ){
			if( $entry != "." && $entry != ".." ){
				if($job){
					$pattern = "/$job/" ;
				}elseif($app){
					$pattern = "/$app/" ;
				}else{
					echo "l'application ou le job doivent être renseigné" ;
					die ;
				}
				if( preg_match($pattern,$entry) ){
					$filename = split('\.',$entry) ;
					$extension = array_pop($filename);
					$media = false ;
					switch($extension){
						case "doc":
						case "pdf":
							$media = "application/".$extension;
							break;
						case "html":
						case "htm" :
							$media = "text/html" ;
							break;
						default:
							echo "Ce format n'est pris en compte" ;
							die ;
					}
					$isFilePresent = true ;
					header("Content-type: ${media}");
					if(${media} != "text/html"){
						header("Content-Disposition: attachment; filename=\"${repBase}${env}/${entry}\"");
					}
					readfile("${repBase}${env}/${entry}") ;
				}
			}
		}
	}else{
		echo "Ne peut pas ouvrir ".$repBase . $env  ;
	}
}else{
	echo "Manque nom d'environnement" ;
}
if(!$isFilePresent){
	echo "Fichier non present pour $env $app $job dans $repBase" ;
}
```