---
layout: post
title: Ajouter / Importer un fichier XML dans wordpress (mime type)
date: 2013-08-17 14:30
author: Virtual Thom
comments: true
categories: [PHP, Wordpress]
---
<p>
Par défaut, wordpress n'autorise pas l'importation et l'ajout de média XML (entre autres). Je me fais un petit reminder dans cet article pour ne pas oublier qu'on peut rajouter simplement des mimes types grâce à un filtre dans functions.php.
Rajouter ces lignes :
</p>
<pre lang="bash">
function custom_upload_mimes( $mimes_par_defaut ) {
	$mimes_par_defaut['xml'] = 'text/xml';
	return $mimes_par_defaut;
}
add_filter( 'mime_types', 'custom_upload_mimes' );
</pre>
