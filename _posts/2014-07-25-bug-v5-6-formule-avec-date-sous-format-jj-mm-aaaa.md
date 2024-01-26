---
layout: post
title: Bug v5.6 - Formule avec date sous format jj-mm-aaaa
date: 2014-07-25 17:24
author: Virtual Thom
comments: true
categories: [Ordonnancement, PHP, Visual TOM, VTOM, XML]
---
Depuis la v5.6 (mais je crois que ça a été corrigé depuis), les formules dont les dates contiennent des tirets - ne sont pas prises en compte.
Et comme j'en avais une flopée, je me suis amusé à les lister plutôt que de les chercher. Je vais vous montrer comment en PHP et un vtexport en xml.
Pour résoudre le problème, il suffit de remplacer le tiret - par un slash /. 

<em><strong>Attention ! je ne le dirai jamais assez, ne jouez pas en Prod. Sur des bugs comme ça, ouvrez un ticket chez Absyss.</strong></em>


```
<?php
if(! file_exists('export.xml')){
	$cr = passthru ( 'vtexport -x > export.xml' ) ;
	if( $cr != 0) {
		echo "Erreur vtexport" ;
		die ;
	}
}
$xml = simplexml_load_file('export.xml');
$regex = "/^.*-.*$/";
 
foreach($xml->Environments->Environment as $env){
	$envname = $env['name'];
	foreach($env->Applications->Application as $application         ){
	   $appname = $application['name'];
	   foreach ( $application->Jobs->Job as $job ) {
		   if( preg_match ( $regex, utf8_decode( $job->Planning->Formula ) ) ){
			   echo $envname . " / " . $appname . " / " . $job['name'] ."\n" ;
			   echo utf8_decode( $job->Planning->Formula ) . "\n\n" ;
		   }
	   }
	}               
}
// penser à gérer votre export.xml après si besoin
```
