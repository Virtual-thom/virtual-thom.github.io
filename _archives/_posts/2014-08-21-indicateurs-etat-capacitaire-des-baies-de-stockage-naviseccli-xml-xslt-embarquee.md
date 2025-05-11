---
layout: post
title: Indicateurs état capacitaire des baies de stockage (Naviseccli, XML et XSLT embarquée)
date: 2014-08-21 22:57
author: Virtual Thom
comments: true
categories: [HTML, naviseccli, SAN, Script, shell, Stockage, VTOM, xml, XML, xsl, XSL, xslt, XSLT]
---
## But :

Donner à la direction informatique une visualisation globale des indicateurs de l'état capacitaire (espace utilisé, disponible et total) des baies de stockage. L'outil doit fournir une aide décisionnelle qui permettra, par exemple, la commande de nouveaux disques, la prise en compte de nouveaux systèmes d'informations en étant sûr de pouvoir l'héberger.

Voici un <a href="{{ site.baseurl | prepend: site.url }}/wp-content/uploads/etat-capacitaire.xml">rendu du fichier XML</a> basique. 

Les explications, ça n'est pas votre tasse de thé ? On en vient directement au fait <a href="#demo-script" title="La démonstration par l'exemple">ici</a>.

## Comment ?

### Les besoins :
<ul>
<li>Une visualisation d'ensemble des KPI (indicateurs clefs de performances) : l'état capacitaire de toutes les baies de  stockage (espace utilisé, disponible et total). Si possible en pourcentage, en Giga Octet et en camembert.</li>
<li>Une mise à jour régulière des données, sur demande ou temps réel selon les besoins. J'estime qu'une mise à jour quotidienne, et à la demande suffisent aux besoins.</li>
<li>Un accès web.</li>
<li>Un compte rendu journalier par e-mail.</li>
<li>Un état imprimable. (Je pense que je vais améliorer cet aspect)</li>
</ul>

### Les méthodes :
<ul>
<li>Pour les requêtes aux baies de stockage EMC, j'utilise : naviseccli. Le programme permet de récupérer toutes les informations qu'on souhaite.</li>
<li>
Afin de produire un seul document, qui va servir à la fois, pour une page web, à la fois, pour le compte-rendu journalier par e-mail, j'utilise le format XML. Le fichier XML ne fait rien en lui-même. Il n'est donc pas exploitable sans la transformation XSL pour un rendu HTML.
<ul>
<li>Pour stocker les données, j'utilise le format XML.</li>
<li>Pour mettre en forme, j'utilise le langage de transformation XSLT avec un rendu HTML5.</li>  
<li>Pour la mise à jour des données, j'utilise l'ordonnanceur VTOM. Il lance le script de mise à jour 3 fois par jour, et dispose d'un traitement à la demande au besoin. Une fois par jour, le matin, VTOM envoie le fichier XML par e-mail.</li>
</ul>
</li>
</ul>

Dans ce genre de cas, il faut éviter les tableaux excels car, ils ne sont pas mis à jour automatiquement (on peut presque dire, jamais à jour par conséquent).
De même, il est quasiment exclus de donner un accès direct au logiciel d'administration, à notre DSI.

Pourquoi, me diriez-vous ? Navisphere, par exemple, dispose de toutes les informations, même sous forme graphique. 
A cela, je répondrais : trop compliqué, trop de cliques à effectuer, trop de chargement, pas de visualisation d'ensemble. La direction a autre chose à faire que de naviguer dans les menus complexes que nous, administrateurs chevronnés, connaissons par coeur.

## naviseccli

Je vous conseille d'authentifier votre utilisateur afin d'effectuer des requêtes sans mot de passe.

```
naviseccli -h IParray -AddUserSecurity -user username -password mypass -scope 0
```

Toutes mes baies EMC sont configurées en Storage Pool. J'effectue une requête pour obtenir l'espace utilisable total utilisateur, l'espace disponible et le nom. J'en déduirai l'espace utilisé. 

```
naviseccli -h $iparray storagepool -list -userCap -availableCap > ${tmpfile}_$iparray

Contenu du fichier :
Pool Name:  Pool Bronze
Pool ID:  1
User Capacity (Blocks):  21107025920
User Capacity (GBs):  10064.614
Available Capacity (Blocks):  21107025920
Available Capacity (GBs):  10064.614
 
Pool Name:  Pool Gold 1
Pool ID:  2
User Capacity (Blocks):  29173164800
User Capacity (GBs):  13910.849
Available Capacity (Blocks):  11354673920
Available Capacity (GBs):  5414.330
 
...
...

```

Petit problème, l'espace du Storage Pool NAS est utilisé à 100%, ou peu s'en faut. L'information n'est pas fausse en soit. En effet, le datamover prend bien tout l'espace du Storage Pool pour constituer son propre pool de stockage, afin de créer les filesystems.
Pour pallier à ce problème, j'utilise des requêtes directement sur la control station du NAS.

```
# il m'a fallu positionner les variables d'environnement afin d'exécuter les commandes
ssh nasadmin@$ipnas '. .bash_profile ; nas_pool -size "Pool NAS"' > pool_nas_size_$ipnas
</pre>
Toujours pour éviter de mettre les mots de passe, j'effectue la mise en place de clés ssh entre mon serveur et la control station.
<pre lang="bash">
# connexion en ssh sur la control station en nasadmin
# ssh nasadmin@ipcontrolstation
# aller dans le répertoire /home/nasadmin/.ssh ou le créer s'il n'existe pas avec ssh-keygen
test -d ~/.ssh || ssh-keygen
cd ~/.ssh
# éditer le fichier authorized_keys pour ajouter la clé de votre serveur
# attention le fichier authorized_keys doit avoir les droits 600
vi authorized_keys
# coller la clé ~/.ssh/id_rsa.pub de votre serveur distant (si c'est une clé rsa) dans le fichier authorized_keys
# sauvegarder
```

## Comment traiter les informations de naviseccli et du NAS ?
J'ai toutes mes informations. Maintenant, je les traite avec un script shell et les mets en forme en XML.
Le fichier XML aura la feuille de style XSLT embarquée, avec un rendu HTML.
 
<a href="{{ site.baseurl | prepend: site.url }}/wp-content/uploads/etat-capacitaire-en-tete-xml.txt" title="entete xml">Entête XML pour le script.</a> (J'utilise <a href="http://www.chartjs.org/" title="Chart.js">Chart.js</a> pour les camemberts en canvas)
<a href="{{ site.baseurl | prepend: site.url }}/wp-content/uploads/etat-capacitaire-shemc.sh.txt" title="script genere xml">Script qui génère le fichier XML.</a>

<a href="{{ site.baseurl | prepend: site.url }}/wp-content/uploads/etat-capacitaire.xml">Rendu fichier XML.</a>

```
#!/bin/bash
#	AUTEUR : SCH Virtual Thom
#	VERSION : 1.0
#	DATE : 10/08/2014
#
# set -n   # Decommenter pour debug syntax sans exéon
#	NOTE: Ne pas oublier de recommenter !
# set -x   # Decommenter pour debug
#
##########################################################
#	VARIABLES
##########################################################
OK=0
KOCRIT=1
KOWARN=2
CR=${OK}
date_du_jour=`date +"%d_%m_%Y"`
# Le nom des arrays doit pouvoir être résolu (/etc/hosts ou dns)  ou mettre l'adresse IP
iparrays="VNX5700 VNX5300 CX4-960"
tmpfile="${date_du_jour}_`uuidgen`_etat-capacitaire-shemc.xml"
ftp_ip=ftp.adresse.intradef.gouv.fr
ftp_user=xxxx
ftp_mdp=xxxx
rep_script='/SANSCRIPTS/etat-capacitaire'
# pour naviseccli
export PATH=$PATH:/opt/Navisphere/bin

##########################################################
#	FONCTIONS
##########################################################
date_heure(){
	date_heure_var=`date +"%d/%m/%Y - %H:%M:%S : "`
	echo "${date_heure_var}$1"
}
fonc_sortie(){
	numero_exit=$1
	message_exit=$2
	date_heure "${message_exit}"
	date_heure "Fin du script. Exit : ${numero_exit}"
	exit ${numero_exit}
}
usage(){
	# exemple d'usage
	script=${0##*/} ;
	#script=${script%.*} ;
	echo "" ;
	echo "Genere un fichier xml de l'etat capacitaire SHEM-C"
	echo "Usage :" ;
	echo " ${script}"
	echo "    Pas de parametre."
	echo ""
	exit ${KOWARN};
}
##########################################################
#	SCRIPT
##########################################################
date_heure 'Début du script'

cat ${rep_script}/etat-capacitaire-en-tete-xml.txt > ${rep_script}/$tmpfile

echo "<!-- cette partie est mise à jour par naviseccli -->
<data:data>" >> ${rep_script}/$tmpfile

# Requete sur les baies de stockage en naviseccli (les clés doivent être mise en place)
# naviseccli -h ipbaie -addusersecurity -scope 0 -password password -user userName
for iparray in $(echo $iparrays)
do
	# un seul naviseccli pour toues les storages d'une baie (ça fait moins de requêtes)
	naviseccli -h $iparray storagepool -list  -userCap -availableCap > ${rep_script}/${tmpfile}_$iparray

	# Le nom et les ip des array sont identiques ici mais on peut mettre autre chose
	# si le résultat contient des lignes, on traite
	if test $(cat  ${rep_script}/${tmpfile}_$iparray | wc -l) -gt 1
	then
		# si les baies sont aussi des têtes NAS, je récupère l'état du "Pool NAS" (il s'appelle comme ça chez moi)
		if test "$iparray" = "VNX5700"
		then
			namearray="VNX5700"
			# le nom du NAS doit pouvoir être résolu (/etc/hosts ou dns) ou mettre l'adresse IP
			ipnas="NAS5700"
			ssh nasadmin@$ipnas '. .bash_profile ; nas_pool -size "Pool NAS"' > ${rep_script}/pool_nas_size_$ipnas
		else
			if test "$iparray" = "VNX5300"
			then
				namearray="VNX5300"
				# le nom du NAS doit pouvoir être résolu (/etc/hosts ou dns) ou mettre l'adresse IP
				ipnas="NAS5300"
				ssh nasadmin@$ipnas '. .bash_profile ; nas_pool -size "Pool NAS"' > ${rep_script}/pool_nas_size_$ipnas
			else
				if test  "$iparray" = "CX4-960"
				then
					 	namearray="CX4-960"
				else
						# par défaut on met l'IP ou le nom dns en tant que nom de baie
						namearray=$iparray
				fi
			fi
		fi

		echo "<array name='$namearray'>" >> ${rep_script}/$tmpfile

		# line de la sortie naviseccli < ${rep_script}/${tmpfile}_$iparray
		# Ne pas oublier que l'entrée ssh dans un boucle while remplace l'entrée standard
		# solution ssh -n
		while read line
		do
			if test -n "$(echo $line | grep 'Pool Name')"
			then
				if test -n  "$(echo $line | grep 'NAS')"
				then
					NAS=1
				else
					NAS=0
				fi
				echo "<storagepool>" >> ${rep_script}/$tmpfile
				echo "<name>" >> ${rep_script}/$tmpfile
				# awk -F: '$1 ~ /Pool Name/ {print $2}' => délimiteur ":", 1er champ contient "Pool Name"
				# affiche le deuxième champs
				echo $line | awk -F: '$1 ~ /Pool Name/ {print $2}' | sed 's/^ //g' >> ${rep_script}/$tmpfile
				echo "</name>" >> ${rep_script}/$tmpfile
			# FIN name
			else
				if test -n  "$(echo $line | grep 'User Capacity (GBs)')"
				then
					echo "<usercap>" >> ${rep_script}/$tmpfile

					if test "$NAS" = "1"
					then
						usercap=`cat ${rep_script}/pool_nas_size_${ipnas} | awk -F"=" '$1 ~ /total_mb/ {print $2}' | sed 's/^ //g'`
						if test "$usercap" != "0"
						then
							usercap=`expr $usercap \/ 1024`
						else
							usercap=`cat ${rep_script}/pool_nas_size_${ipnas} | awk -F"=" '$1 ~ /potential_mb/ {print $2}' | sed 's/^ //g'`
							usercap=`expr $usercap \/ 1024`
						fi
						echo $usercap >> ${rep_script}/$tmpfile

					# si Pool différent du NAS
					else
						echo $line | awk -F: '$1 ~ /User Capacity \(GBs\)/ {print $2}' | sed 's/^ //g' >> ${rep_script}/$tmpfile
					fi

					echo "</usercap>" >> ${rep_script}/$tmpfile
				# FIN usercap
				else
					if test -n  "$(echo $line | grep 'Available Capacity (GBs)')"
					then
						echo "<availablecap>" >> ${rep_script}/$tmpfile

						if test "$NAS" = "1"
						then
							availablecap=`cat ${rep_script}/pool_nas_size_${ipnas} | awk -F"=" '$1 ~ /avail_mb/ {print $2}' | sed 's/^ //g'`
							if test "$availablecap" != "0"
							then
								availablecap=`expr $availablecap \/ 1024`
							else
								availablecap=`cat ${rep_script}/pool_nas_size_${ipnas} | awk -F"=" '$1 ~ /potential_mb/ {print $2}' | sed 's/^ //g'`
								availablecap=`expr $availablecap \/ 1024`
							fi
							echo $availablecap >> ${rep_script}/$tmpfile

						# si pas pool NAS
						else
							echo $line | awk -F: '$1 ~ /Available Capacity \(GBs\)/ {print $2}' | sed 's/^ //g' >> $tmpfile
						fi

						echo "</availablecap>" >> ${rep_script}/$tmpfile
					# FIN availablecap
					else
						# Je prends les lignes vides comme séparateur des pools
						if test -z "$line"
						then
							echo "</storagepool>" >> ${rep_script}/$tmpfile
						fi

					fi
				fi
			fi

		done < ${rep_script}/${tmpfile}_$iparray

		echo "</array>" >> ${rep_script}/$tmpfile
	fi
done


echo "</data:data> <!-- fin des datas -->
</xsl:stylesheet> <!-- fin du fichier xml -->" >> ${rep_script}/$tmpfile

date_heure "Transfert FTP"
# Transfert FTP sur le site de la SHEM
ftp -v -n -i > /dev/null << EOF
open ${ftp_ip}
user ${ftp_user} ${ftp_mdp}
binary
put ${rep_script}/$tmpfile index.xml
EOF

# TODO : prévoir d'envoyer un e-mail en compte rendu avec le xml attaché

# Nettoyage des fichiers temporaires
for iparray in $(echo $iparrays)
do
	rm -f ${rep_script}/${tmpfile}_$iparray
done
rm -f ${rep_script}/pool_nas_size*
rm -f ${rep_script}/$tmpfile
date_heure 'Fin du script'
```

Vous avez remarqué que je dis souvent que la feuille XSLT est embarquée dans le fichier XML. En réalité, c'est plutôt la data XML qui est embarquée dans la transformation XSLT. En fait, la feuille de transformation XSLT est un fichier XML en elle-même. Il suffit de lui insérer des datas et de définir un certain nombre de paramètres :

```xml
<?xml version="1.0" encoding="utf-8"?> <!-- Comme tout fichier XML -->
<?xml-stylesheet href="#stylesheet" type="text/xsl"?> <!-- D'habitude on met l'url du fichier XML à transformer ici -->
<!-- là, on fait référence à l'ID stylesheet, interne à ce fichier -->

<!--  Pour ça, il faut définir la structure du document DTD (Document Type Definition)  -->
<!DOCTYPE xsl:stylesheet [
<!ATTLIST xsl:stylesheet
id	ID	#REQUIRED>
]>
 
<!-- balises de transformation xsl -->
<xsl:stylesheet version="2.0" id="stylesheet"  xmlns:data="localhost" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- pour un rendu HTML -->
<xsl:output method="html" indent="yes" encoding="UTF-8" />

<!-- definition du template principal avec le rendu html -->
<xsl:template match="/">
<html>
<body>...
<!-- Les appels de template se feront <xsl:apply-templates select="/xsl:stylesheet/data:data/xxx" /> -->
</body>
</html>
</xsl:template>

<data:data>
<!-- c'est ici que j'insère de la data -->
</data:data> <!-- fin des datas -->

</xsl:stylesheet> <!-- fin du fichier xml -->
```

Petite aparté :
Il faut savoir que vous pouvez sortir les informations en XML avec naviseccli. C'est possible mais, le format est tellement peu pratique et peu lisible (car non-imbriqué) que je ne l'utilise pas. Si vous voulez absolument avoir une sortie en XML il faut rajouter -Xml à naviseccli. 

`naviseccli -Xml -h x.x.x.x storagepool -list  -userCap -availableCap`

```xml
<?xml version="1.0" encoding="utf-8" ?>
<CIM CIMVERSION="2.0" DTDVERSION="2.0"><MESSAGE ID="877" PROTOCOLVERSION="1.0"><SIMPLERSP><METHODRESPONSE NAME="ExecuteClientRequest"><RETURNVALUE TYPE="Navi_Error">
<VALUE.NAMEDINSTANCE>
<INSTANCENAME CLASSNAME="Navi_Error">
</INSTANCENAME>
<INSTANCE CLASSNAME="Navi_Error">
<PROPERTY NAME="errorCode" TYPE="uint32"><VALUE>0</VALUE>
</PROPERTY>
<PROPERTY NAME="success" TYPE="boolean"><VALUE>true</VALUE>
</PROPERTY>
<PROPERTY NAME="where" TYPE="string"><VALUE>ProvisionProvider</VALUE>
</PROPERTY>
<PROPERTY NAME="why" TYPE="string"><VALUE></VALUE>
</PROPERTY>
</INSTANCE>
</VALUE.NAMEDINSTANCE>
</RETURNVALUE><PARAMVALUE NAME="Pool Name" TYPE="string"><VALUE>Pool&#32;Bronze</VALUE>
</PARAMVALUE>
<PARAMVALUE NAME="Pool ID" TYPE="string"><VALUE>1</VALUE>
</PARAMVALUE>
<PARAMVALUE NAME="User Capacity (Blocks)" TYPE="string"><VALUE>21107025920</VALUE>
</PARAMVALUE>
<PARAMVALUE NAME="User Capacity (GBs)" TYPE="string"><VALUE>10064.614</VALUE>
</PARAMVALUE>
<PARAMVALUE NAME="Available Capacity (Blocks)" TYPE="string"><VALUE>21107025920</VALUE>
</PARAMVALUE>
<PARAMVALUE NAME="Available Capacity (GBs)" TYPE="string"><VALUE>10064.614</VALUE>
</PARAMVALUE>
<PARAMVALUE NAME="" TYPE="string"><VALUE>&#32;</VALUE>
</PARAMVALUE>
...
...
</METHODRESPONSE></SIMPLERSP></MESSAGE></CIM>
```
