---
layout: post
title: Mise en forme des logs d'exécution VTOM - insérer de la data XML dans un fichier XSL directement
date: 2012-09-15 15:24
author: Virtual Thom
comments: true
categories: [Cmd, compte rendu, log d'exécution, Ordonnancement, Script, shell, Visual TOM, Visual TOM, VTOM, VTOM, xml, XML, xsl, XSL, xslt, XSLT]
---
A la demande de certains clients, j'ai écrit un script qui récupère les logs d'exécutions des jobs et les mets en forme en page web xml.
Le principe est simple. Insérer de la data XML dans un fichier de feuille de style XSLT et transformer les data directement. On peut dire aussi que la feuille de transformation XSL est embarquée dans le fichier data XML. 

Vous pouvez télécharger le résultat XML : 
<a target='_blank' href="{{ site.baseurl | prepend: site.url }}/wp-content/uploads/exemple_log.xml" title="exemple_log.xml">exemple_log.xml</a>

Les besoins des clients nous obligent parfois à effectuer un peu de "développement" perso. Voici ma recette pour récupérer et ordonner les logs d'exécution. Dans l'ordre d'affichage, JOBS EN COURS, JOBS EN ERREUR, JOBS TERMINES.
La sortie finale en xml a l'avantage d'être visible sur la plupart des navigateurs web et intègre directement la mise en forme sans autre fichier (transformation xsl directement).

Je vous propose de regarder dans un premier temps le résultat final. Dans un deuxième temps, je vous montrerai mon script en shell qui génère ce fichier xml.

```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<?xml-stylesheet href="#stylesheet" type="text/xsl"?>

<!DOCTYPE xsl:stylesheet [
<!ATTLIST xsl:stylesheet
id	ID	#REQUIRED>
]>

<!-- balises de transformation xsl -->
<xsl:stylesheet version="2.0" id="stylesheet"  xmlns:data="localhost" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>

<!-- définition du template principal avec le rendu html -->
<xsl:template match="/">
<html>
<head>
<title>Rapport log d execution job VTOM</title>
<style type="text/css">
h1 a {
	background-color : #339933 ;
	border : 1pt solid black ;
	margin : 0 0 0 10pt ; 
	padding : 2pt ;
}
h2 a {
	background-color : #33FF66 ;
	border : 1pt solid black ;
	margin : 0 0 0 20pt ;
	padding : 2pt ;
}
div.in{	
	border: inset 5pt green;
}
div.pair{
	border: outset 5pt green; 
    border-collapse: separate;
    border-spacing: 5pt ;
	margin : 0 0 10pt 0 ;
	background-color: #33FF66 ;
}
div.impair{
	border: outset 5pt green; 
    border-collapse: separate;
    border-spacing: 5pt ;
	margin : 0 0 10pt 0 ;
	background-color: #339933 ;
}
div.erreur1{
	border: outset 5pt red; 
    border-collapse: separate;
    border-spacing: 5pt ;
	margin : 0 0 10pt 0 ;
	background-color: brown ;
}
div.erreur2{
	border: outset 5pt red; 
    border-collapse: separate;
    border-spacing: 5pt ;
	margin : 0 0 10pt 0 ;
	background-color: coral ;
}
div.encours1{
	border: outset 5pt aqua; 
    border-collapse: separate;
    border-spacing: 5pt ;
	margin : 0 0 10pt 0 ;
	background-color: blue ;
}
div.encours2{
	border: outset 5pt aqua; 
    border-collapse: separate;
    border-spacing: 5pt ;
	margin : 0 0 10pt 0 ;
	background-color: aqua ;
}
div.logok{
	border : 1pt solid black ;
	margin : 5pt ; 
	padding : 10pt ;
}
div.logok a{
	font : 12pt ;
	color : lawngreen ;
	text-decoration : underline ;
	background-color : darkgreen ;
	padding : 5 pt ;
}
div.logko {
	border : 1pt solid black ;
	margin : 5pt ; 
	padding : 10pt ;
}
div.logko a{
	text-decoration : underline ;
	color : red ;
	background-color : yellow ;
	padding : 5 pt ;
}
</style>
</head>
<body>
<!-- appel des templates qui vont chercher dans les datas (les logs) --> 
<xsl:apply-templates select="/xsl:stylesheet/data:data" />
</body>
</html>
</xsl:template>


<xsl:template match="/xsl:stylesheet/data:data">
<!--
    Ce premier appel de template va définir le layout de l état de l enregistrement
    1 row = un log d exécution
-->

<xsl:if test="count(row) = 0"> 
<a>Aucun traitement</a> 
</xsl:if>

<!-- JOBS EN COURS
     j ai défini dans mon script
     que les jobs en cours ont un exit 321321
-->
<xsl:for-each select="row[exit = 321321]">
<!-- le modulo est juste là pour faire une couleur un peu différente 
     si plusieurs enregistrements de même type sont à la suite -->
<xsl:choose>
<xsl:when test="position() mod 2 = 0" >
<div class="encours1">
<div class="in">
<!-- appel du template pour le contenu du log -->
<xsl:call-template name="rapport" />
</div>
</div>
</xsl:when>
<xsl:otherwise>
<div class="encours2">
<div class="in">
<!-- appel du template pour le contenu du log -->
<xsl:call-template name="rapport" />
</div>
</div>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each> <!-- fin des row EN COURS -->


<!-- JOB EN ERREUR -->
<xsl:for-each select="row[exit != 0 and exit != 321321]">

<xsl:choose>
<xsl:when test="position() mod 2 = 0" >
<div class="erreur1">
<div class="in">
<xsl:call-template name="rapport" />
</div>
</div>
</xsl:when>
<xsl:otherwise>
<div class="erreur2">
<div class="in">
<xsl:call-template name="rapport" />
</div>
</div>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each> <!-- fin des row EN ERREUR -->

<!-- JOB TERMINES -->
<xsl:for-each select="row[exit = 0]">

<xsl:choose>
<xsl:when test="position() mod 2 = 0" >
<div class="pair">
<div class="in">
<xsl:call-template name="rapport" />
</div>
</div>
</xsl:when>
<xsl:otherwise>
<div class="impair">
<div class="in">
<xsl:call-template name="rapport" />
</div>
</div>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each> <!-- fin des row TERMINES -->

</xsl:template> <!-- fin du template des datas -->

<!-- appel du template pour le contenu du log -->
<xsl:template name="rapport">
<h1><a>Application : <xsl:value-of select="app" /></a></h1>
<h2><a>Traitement : <xsl:value-of select="job" /></a></h2>
<div class="logok">
<a>Log d execution : sortie standard : </a><br />
&lt;pre&gt;
<xsl:value-of select="logok" />
&lt;/pre&gt;
</div>
<div class="logko">
<a>Log d execution : sortie en erreur : </a><br />
&lt;pre&gt;
<xsl:value-of select="logko" />
&lt;/pre&gt;
</div>
</xsl:template> <!-- fin du template rapport -->

<!-- les datas, les logs d'exécutions 
     1 row = 1 enregistrement
     1 enregistrement = nom de l'application et job, le n°exit
                        les logs d'exécution
-->
<data:data>
	<row>
		<app>
		 APPLICATION_1
		</app>
		<job>
		 TRAITEMENT_1
		</job>
		<exit>
		0
		</exit>
		<logok>
_______________________________________________________________________
Contexte Visual TOM du traitement
 
Machine             : machine-la01
Utilisateur         : root
Script              : /path/monscript.sh
Shell               : /bin/ksh
Serveur Visual TOM  : serveur-vtom
 
Traitement          : TRAITEMENT_1
Application         : APPLICATION_1
Environnement       : ENVIRONNEMENT_A
Job ID              : 3348
Nombre de relances  : 0
Label de reprise    : 0
Mode Execution      : NORMAL
Date d'exploitation : DATE_PROD
Valeur de la date   : 31/08/2012
_______________________________________________________________________
vendredi 31/08/2012 - 04:29:58
 Debut de l'execution du script ...
_______________________________________________________________________
  
  LUKE aime LEIA sortie standard
_______________________________________________________________________
vendredi 31/08/2012 - 04:30:59
Fin de l'execution du script.
 
--&gt; Exit [0] donc acquitement
		</logok>
		<logko>
		</logko>
	</row>
	<row>
		<app>
		 APPLICATION_1
		</app>
		<job>
		 TRAITEMENT_2
		</job>
		<exit>
		123
		</exit>
		<logok>
_______________________________________________________________________
Contexte Visual TOM du traitement
 
Machine             : machine-la01
Utilisateur         : root
Script              : /path/monscript.sh
Shell               : /bin/ksh
Serveur Visual TOM  : serveur-vtom
 
Traitement          : TRAITEMENT_2
Application         : APPLICATION_1
Environnement       : ENVIRONNEMENT_A
Job ID              : 3349
Nombre de relances  : 0
Label de reprise    : 0
Mode Execution      : NORMAL
Date d'exploitation : DATE_PROD
Valeur de la date   : 31/08/2012
_______________________________________________________________________
vendredi 31/08/2012 - 04:29:58
 Debut de l'execution du script ...
_______________________________________________________________________
  
  LUKE aime LEIA sortie standard
_______________________________________________________________________
vendredi 31/08/2012 - 04:30:59
Fin de l'execution du script.
 
--&gt; Exit [123] donc acquitement
		</logok>
		<logko>
		JE SUIS TON PERE sortie erreur
		</logko>
	</row>
	<row>
		<app>
		 APPLICATION_1
		</app>
		<job>
		 TRAITEMENT_3
		</job>
		<exit>
		321321
		</exit>
		<logok>
_______________________________________________________________________
Contexte Visual TOM du traitement
 
Machine             : machine-la01
Utilisateur         : root
Script              : /path/monscript.sh
Shell               : /bin/ksh
Serveur Visual TOM  : serveur-vtom
 
Traitement          : TRAITEMENT_3
Application         : APPLICATION_1
Environnement       : ENVIRONNEMENT_A
Job ID              : 3350
Nombre de relances  : 0
Label de reprise    : 0
Mode Execution      : NORMAL
Date d'exploitation : DATE_PROD
Valeur de la date   : 31/08/2012
_______________________________________________________________________
vendredi 31/08/2012 - 04:29:58
 Debut de l'execution du script ...
_______________________________________________________________________
  
  LUKE aime ...
		</logok>
		<logko>
		</logko>
	</row>
</data:data> <!-- fin des datas -->
</xsl:stylesheet> <!-- fin du fichier xml -->
```

Pour aller plus loin dans l'explication du XML, c'est en réalité un xml qui fait appel à une feuille de style XSL, non pas extérieure mais dans le XML, grâce à son ID.

De plus la feuille de style xsl:stylesheet intègre directement les données. Il suffit de définir le namespace dans la déclaration du xsl:stylesheet.

Appel de la feuille de style xsl:stylesheet dans le fichier xml : 

```
<?xml-stylesheet href="#stylesheet" type="text/xsl"?>
```

vers le href #stylesheet => id=stylesheet

```
<xsl:stylesheet version="2.0" id="stylesheet"  xmlns:data="localhost" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
```

Déclaration normale pour les balises de transformation xsl

```
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
```

Déclaration de ma balise perso.
Cela va permettre de faire mes balises du type <data:data> où je vais stocker mes données.

Les templates vont matcher à partir de cette arborescence.

```
xmlns:data="localhost"
```

Passons maintenant au script shell exécuté sur chaque machine dont vous voulez récupérer les logs.

Voici le script <a target='_blank' href="{{ site.baseurl | prepend: site.url }}/wp-content/uploads/generexml.sh_.txt" title="generexml.sh">generexml.sh</a>

Je me base sur la structure du nom des logs d'exécution VTOM. Il y aura surement quelques adaptations à effectuer chez vous.

Attention, je ne test pas la volumétrie des logs.

```bash
#!/bin/sh
#
#       AUTEUR : Virtual Thom
#       VERSION : 1.0
#       DATE : 20/05/2011
#
# set -n   # Decommenter pour debug syntax sans execution
#       NOTE: Ne pas oublier de recommenter !
# set -x   # Decommenter pour debug
#
##########################################################
#       SCRIPT
##########################################################
usage(){
	# exemple d'usage
	script=${0##*/} ;
	#script=${script%.*} ;
	echo "" ;
	echo "${script} - permet de recuperer des logs d'execution et de les mettre en forme" ;
	echo ""
	echo "Usage :" ;
	echo "    ${script} machine environnement tempsenseconde" ;
	echo "1er parametre  : nom de la machine" ;
	echo "2eme parametre : filtre pour la recuperation des logs, peut etre l'environnement par exemple" ;
	echo "3eme parametre : temps en secondes depuis l'execution du script jusqu'au temps de recuperation"  ;
	echo "" ;
	exit 123 ;
}
if test "$1" = "--help" -o "$1" = "-help" -o "$1" = "-h" -o -z "$1"
then
	usage	
fi
machine=${1} #Par defaut machine
environnement=${2:-PROD} #Par defaut PROD
retour_tps=${3:-86400}	#Par defaut 86400 s soit 24h

LOGS_REP=${TOM_LOG_DIR:-/opt/vtom/logs/}
LOGS_SCRIPTS=/opt/vtom/scripts/
INFILE=/opt/vtom/scripts/infile
OUTFILE=/opt/vtom/scripts/outfile
XML=/opt/vtom/scripts/${machine}_${environnement}.xml
thisday=`date +%s`	#date du jour en timestamp
dayminusday=`expr $thisday - ${retour_tps}`	#calcul date du jour - 24h (en s) en timestamp

> $OUTFILE
ls ${LOGS_REP} | grep "${environnement}.*.o" | sort > $INFILE	#liste des logs
#chargement de l entete xml xsl
entete='<?xml version="1.0" encoding="ISO-8859-1"?>\n
<?xml-stylesheet href="#stylesheet" type="text/xsl"?>\n
\n
<!DOCTYPE xsl:stylesheet [\n
<!ATTLIST xsl:stylesheetn
id	ID	#REQUIRED>\n
]>\n
\n
<!-- balises de transformation xsl -->\n
<xsl:stylesheet version="2.0" id="stylesheet"  xmlns:data="localhost" \n
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">\n
<xsl:output method="html" indent="yes"/>\n
\n
<!-- définition du template principal avec le rendu html -->\n
<xsl:template match="/">\n
<html>\n
<head>\n
<title>Rapport log d execution job VTOM</title>\n
<style type="text/css">\n
h1 a {\n
	background-color : #339933 ;\n
	border : 1pt solid black ;\n
	margin : 0 0 0 10pt ; \n
	padding : 2pt ;\n
}\n
h2 a {\n
	background-color : #33FF66 ;\n
	border : 1pt solid black ;\n
	margin : 0 0 0 20pt ;\n
	padding : 2pt ;\n
}\n
div.in{	\n
	border: inset 5pt green;\n
}\n
div.pair{\n
	border: outset 5pt green; \n
    border-collapse: separate;\n
    border-spacing: 5pt ;\n
	margin : 0 0 10pt 0 ;\n
	background-color: #33FF66 ;\n
}\n
div.impair{\n
	border: outset 5pt green; \n
    border-collapse: separate;\n
    border-spacing: 5pt ;\n
	margin : 0 0 10pt 0 ;\n
	background-color: #339933 ;\n
}\n
div.erreur1{\n
	border: outset 5pt red; \n
    border-collapse: separate;\n
    border-spacing: 5pt ;\n
	margin : 0 0 10pt 0 ;\n
	background-color: brown ;\n
}\n
div.erreur2{\n
	border: outset 5pt red; \n
    border-collapse: separate;\n
    border-spacing: 5pt ;\n
	margin : 0 0 10pt 0 ;\n
	background-color: coral ;\n
}\n
div.encours1{\n
	border: outset 5pt aqua; \n
    border-collapse: separate;\n
    border-spacing: 5pt ;\n
	margin : 0 0 10pt 0 ;\n
	background-color: blue ;\n
}\n
div.encours2{\n
	border: outset 5pt aqua; \n
    border-collapse: separate;\n
    border-spacing: 5pt ;\n
	margin : 0 0 10pt 0 ;\n
	background-color: aqua ;\n
}\n
div.logok{\n
	border : 1pt solid black ;\n
	margin : 5pt ; \n
	padding : 10pt ;\n
}\n
div.logok a{\n
	font : 12pt ;\n
	color : lawngreen ;\n
	text-decoration : underline ;\n
	background-color : darkgreen ;\n
	padding : 5 pt ;\n
}\n
div.logko {\n
	border : 1pt solid black ;\n
	margin : 5pt ; \n
	padding : 10pt ;\n
}\n
div.logko a{\n
	text-decoration : underline ;\n
	color : red ;\n
	background-color : yellow ;\n
	padding : 5 pt ;\n
}\n
</style>\n
</head>\n
<body>\n
<!-- appel des templates qui vont chercher dans les datas (les logs) --> \n
<xsl:apply-templates select="/xsl:stylesheet/data:data" />\n
</body>\n
</html>\n
</xsl:template>\n
\n
\n
<xsl:template match="/xsl:stylesheet/data:data">\n
<!--\n
    Ce premier appel de template va définir le layout de l état de l enregistrement
    1 row = un log d exécutionn
-->\n
\n
<xsl:if test="count(row) = 0"> \n
<a>Aucun traitement</a> \n
</xsl:if>\n
\n
<!-- JOBS EN COURSn
     j ai défini dans mon scriptn
     que les jobs en cours ont un exit 321321n
-->\n
<xsl:for-each select="row[exit = 321321]">\n
<!-- le modulo est juste là pour faire une couleur un peu différente \n
     si plusieurs enregistrements de même type sont à la suite -->\n
<xsl:choose>\n
<xsl:when test="position() mod 2 = 0" >\n
<div class="encours1">\n
<div class="in">\n
<!-- appel du template pour le contenu du log -->\n
<xsl:call-template name="rapport" />\n
</div>\n
</div>\n
</xsl:when>\n
<xsl:otherwise>\n
<div class="encours2">\n
<div class="in">\n
<!-- appel du template pour le contenu du log -->\n
<xsl:call-template name="rapport" />\n
</div>\n
</div>\n
</xsl:otherwise>\n
</xsl:choose>\n
</xsl:for-each> <!-- fin des row EN COURS -->\n
\n
\n
<!-- JOB EN ERREUR -->\n
<xsl:for-each select="row[exit != 0 and exit != 321321]">\n
\n
<xsl:choose>\n
<xsl:when test="position() mod 2 = 0" >\n
<div class="erreur1">\n
<div class="in">\n
<xsl:call-template name="rapport" />\n
</div>\n
</div>\n
</xsl:when>\n
<xsl:otherwise>\n
<div class="erreur2">\n
<div class="in">\n
<xsl:call-template name="rapport" />\n
</div>\n
</div>\n
</xsl:otherwise>\n
</xsl:choose>\n
</xsl:for-each> <!-- fin des row EN ERREUR -->\n
\n
<!-- JOB TERMINES -->\n
<xsl:for-each select="row[exit = 0]">\n
\n
<xsl:choose>\n
<xsl:when test="position() mod 2 = 0" >\n
<div class="pair">\n
<div class="in">\n
<xsl:call-template name="rapport" />\n
</div>\n
</div>\n
</xsl:when>\n
<xsl:otherwise>\n
<div class="impair">\n
<div class="in">\n
<xsl:call-template name="rapport" />\n
</div>\n
</div>\n
</xsl:otherwise>\n
</xsl:choose>\n
</xsl:for-each> <!-- fin des row TERMINES -->\n
\n
</xsl:template> <!-- fin du template des datas -->\n
\n
<!-- appel du template pour le contenu du log -->\n
<xsl:template name="rapport">\n
<h1><a>Application : <xsl:value-of select="app" /></a></h1>\n
<h2><a>Traitement : <xsl:value-of select="job" /></a></h2>\n
<div class="logok">\n
<a>Log d execution : sortie standard : </a><br />\n
&lt;pre&gt;\n
<xsl:value-of select="logok" />\n
&lt;/pre&gt;\n
</div>\n
<div class="logko">\n
<a>Log d execution : sortie en erreur : </a><br />\n
&lt;pre&gt;\n
<xsl:value-of select="logko" />\n
&lt;/pre&gt;\n
</div>\n
</xsl:template> <!-- fin du template rapport -->\n
'
echo -e $entete > $XML

echo "<data:data>" >> $XML	#arbre xslt : /stylesheet/data:data/row

for LIGNE in $(cat $INFILE)
do	
	nom_exec=${LIGNE%.*}
	nom_traitement=${LIGNE%.*}	#recuperation nom du fichier sans extension chaine la plus courte a droite du . suivi de n caracteres
	nom_traitement=`echo $nom_traitement | sed 's/_[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]$//'` #suppression de la date et heure exemple de sed
	date_exec=`echo $LIGNE | awk -F "_" '{print $NF}' | awk -F "." '{print $1}' | awk -F "-" '{print $1}'`	#je laisse un exemple avec awk -F est le delemiter $NF le dernier argument
	heure_exec=${nom_exec##*-}	#chaine la plus longue a gauche de - suivi de n caracteres
	heure_exec=`echo $heure_exec | sed 's/^[0-9][0-9]/&:/' | sed 's/[0-9][0-9]$/:&/'`	#trick pour rajouter : entre heures et minutes avec sed
	date_traitement=`date --date="$date_exec $heure_exec" +"%d/%m/%y %H:%M:%S"` #interpretation de la date par --date et remise en format classique
	date_exec=`date --date="$date_exec $heure_exec" +%s`	#timestamp pour tester avec le timestamp minimum requis
	
	if test "$date_exec" > "$dayminusday" -a $LIGNE != ""
	then
		echo "	<row>" >> $XML
		echo "		<app>" >> $XML
		app=`head -n 20 "$LOGS_REP$LIGNE" | grep "Application" | awk -F ":" '{print $2}'`	#head comme tail mais en partant du debut recuperation du nom application dans les logs
		echo "		$app" >> $XML
		echo "		</app>" >> $XML
					
		echo "		<job>" >> $XML
		job=`head -n 20 "$LOGS_REP$LIGNE" | grep "Traitement" | awk -F ":" '{print $2}'`	#recuperation du nom traitement dans les logs
		echo "		$job" >> $XML
		echo "		</job>" >> $XML
						
		echo "		<exit>" >> $XML
		num_exit=`tail -n 5 "$LOGS_REP$LIGNE" | grep "Exit" | awk -F "[" '{print $2}' | awk -F "]" '{print $1}'`	#recuperation du numero exit dans les logs
		if test "${num_exit}" != ""
		then
			echo "		$num_exit" >> $XML
		else
			echo "		321321" >> $XML
		fi
		echo "		</exit>" >> $XML
		
		echo "		<logok>" >> $XML
		#cat ${LOGS_REP}$LIGNE    |  sed  's#<#&lt;#g' | sed 's#>#&gt;#g' | sed 's#&#&amp;#g' >> $XML	#sed remplace les < et les > par les notations xml pour ces caracteres speciaux
		cat ${LOGS_REP}$LIGNE  | sed 's#&#&amp;#g'  |  sed  's#<#&lt;#g' | sed 's#>#&gt;#g'  >> $XML
		echo "		</logok>" >> $XML
		logko=`echo $LIGNE | sed 's/.o$/.e/'`	#exemple de sed j aurai pu mettre ${nom_exec}.e
		echo "		<logko>" >> $XML
		cat ${LOGS_REP}$logko  | sed 's#&#&amp;#g'  |  sed  's#<#&lt;#g' | sed 's#>#&gt;#g'  >> $XML
		echo "		</logko>" >> $XML
		echo "	</row>" >> $XML
		
	fi
done

echo "</data:data>" >> $XML
echo "</xsl:stylesheet>" >> $XML	#arbre xslt : /stylesheet/data:data/row

rm -f $INFILE	#nettoyage fichiers temp
rm -f $OUTFILE
```
