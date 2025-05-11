---
layout: post
title: Script shell dd generator
date: 2014-10-16 11:49
author: Virtual Thom
comments: true
categories: [dd, iso, Script, script, shell, shell, test performance]
---
# La commande dd en shell, à quoi ça sert ?
Je vois deux principaux intérêts à la commande dd unix.
1. Copie bloc à bloc d'un support (CD, DVD, Clé, Disques, etc.)
2. Test de performance d'écriture entre la source et la destination de la copie.

<p>edit 2015)</p>
<p>je viens de découvrir qu'on pouvait créer un fichier plein de zéro (avec dd par exemple), le formater, et le monter comme si c'était un filesystem ! ça me parait fou mais ça semble fonctionner. Très pratique quand il n'y a pas de VG ou plus de place pour créer des lv, ou pas de fs disponible. 

Ca permet surtout de cloisonner l'espace disque si, par exemple, on ne veut pas qu'un répertoire impacte le fs complet.
<a href="http://souptonuts.sourceforge.net/quota_tutorial.html" title="Linux quota tutorial">Magnifique tutorial de quota pour linux</a>
<pre>
Next, create a 20M file (disk image) in a suitable location. What I did below is create the file disk-quota.ext3 in the directory /usr/disk-img.

   # mkdir -p /usr/disk-img
   # dd if=/dev/zero of=/usr/disk-img/disk-quota.ext3 count=40960
The dd command above created a 20MB file because, by default, dd uses a block size of 512 bytes. That makes this size: 40960*512=20971520. For kicks, we'll confirm this size.

   # ls -lh /usr/disk-img/disk-quota.ext3
   -rw-r--r--  1 root root 20M Jul 19 14:34 /usr/disk-img/disk-quota.ext3
Next, format this as an ext3 filesystem.

   # /sbin/mkfs -t ext3 -q /usr/disk-img/disk-quota.ext3 -F
The "-t" gives it the type. You're not limited to ext3. In fact, you could use ext2 or other filesystems installed on your system. The "-q" is for the device, and "-F" is to force the creation without warning us that this is a file and not a block device.
</pre>
</p>

<a title="Lien Wikipédia dd (Unix)" href="http://fr.wikipedia.org/wiki/Dd_%28Unix%29">Lien Wikipédia dd (Unix).</a>

Toujours est-il que les paramètres de la commande ne sont pas forcément triviales. C'est pourquoi j'ai fait un petit script shell avec un menu.

# Script
<a href="{{ site.baseurl | prepend: site.url }}/wp-content/uploads/dd_generator.sh.txt">dd_generator.sh</a>

```bash
#!/bin/sh
#
#	SCRIPT	: dd_generator
#	AUTEUR 	: Virtual Thom
#	DATE	: 02.10.13
# set -x # debug
# set -n # verif syntax sans exec
#
##################################
#	VARIABLES
##################################
datenow=$(date +"%d-%m-%y_%H.%M.%S")
ibs='1024' # nombre d'octet lu d'un coup du if
count='10000' # nombre de segments ibs lu (si 0 il va au bout du fichier)
unit='Mo'
unit_base=1024
unit_mo=`expr ${unit_base} \* ${unit_base}`
unit_go=`expr ${unit_mo} \* ${unit_base}`
unit_to=`expr ${unit_go} \* ${unit_base}`
fonc_calc_unit(){
case ${unit} in
	"octets")
	unit_calc=1
	;;
	"Ko")
	unit_calc=${unit_base}
	;;
	"Go")
	unit_calc=${unit_go}
	;;
	"To")
	unit_calc=${unit_to}
	;;
	"Mo" | *)
	unit_calc=${unit_mo}
	;;
esac 
}
fonc_calc_unit
#total_size='expr ${ibs} \* ${count} \/ ${unit_calc}' # par defaut en Mo, doit être évaluer
total_size="echo 'scale=2;${ibs} * ${count} / ${unit_calc}' | bc" # par defaut en Mo, doit être évaluer
total_size_msg='echo "Taille Totale (en $unit) :"'
of_path='echo "${PWD}/dd_`eval ${total_size}`${unit}_${datenow}.bin"' # par defaut fichier écrit dans le répertoire courant
if_path='/dev/zero' # par defaut fichier lu constitué de vide 
msg_retour="Tapez retour99 ou laissez vide pour ne pas changer la valeur"

##################################
#	FONCTIONS
##################################
date_heure(){
        date_heure_var=`date +"%d/%m/%Y - %H:%M:%S : "`
        echo "${date_heure_var}$1"
}
date_simple(){
        date_heure_var=`date +"%d%m%Y_%H%M%S"`
        echo "${date_heure_var}"
}
fonc_sortie(){
        numero_exit=$1
        message_exit=$2
        date_heure "${message_exit}"
        date_heure "Fin du script. Exit : ${numero_exit}"
        exit ${numero_exit}
}
fonc_pause(){
   echo -e "\nAppuyez sur Entrer pour continuer...\c"
   read
}
fonc_trap_exit(){
	echo ""
	fonc_sortie "123" "Script interrompu"
}
trap 'fonc_trap_exit' 2
fonc_menu_principal(){
	clear

	#TITRE 
	echo -e "\n\t################\n\t# DD GENERATOR #\n\t################\n"
	echo -e "\n\tdd of=`eval ${of_path}` if=${if_path} ibs=${ibs} count=${count}\n"
	PS3="Selectionner une option et appuyer sur Entrer :"

	select options in "Unite par defaut : $unit" "Fichier lu : $if_path" "Fichier ecrit : `eval $of_path`" "Taille segment de lecture (octet) : $ibs" "Nombre de Segment : $count" "`eval $total_size_msg` `eval \"$total_size\"`" "Creer le fichier" "Quitter"
	do
	case ${options}	 in 
		"Unite par defaut : $unit")
			menu_unit
		;;
		"Fichier lu : $if_path")
			clear
			echo -e "Veuillez entrer le chemin complet du fichier à lire : \n\t(${msg_retour})"
			read read_if_path
			fonc_test_retour "${read_if_path}" &&  if_path=${read_if_path}
			fonc_menu_principal
		;;
		"Fichier ecrit : `eval $of_path`")
			clear
			echo -e "Veuillez entrer le chemin complet du fichier à créer : \n\t(${msg_retour})"
			read read_of_path
			fonc_test_retour "${read_of_path}"
			if test $? -eq 0
			then
				of_path_tmp=${read_of_path}
				of_path='echo ${of_path_tmp}'
			fi
			fonc_menu_principal
		;;
		"Taille segment de lecture (octet) : $ibs")
			clear
			echo -e "Veuillez entrer la taille du segment lu : \n\t(${msg_retour})"
			read read_ibs 
			fonc_test_retour "${read_ibs}" && ibs=${read_ibs}
			fonc_menu_principal
		;;
		"Nombre de Segment : $count")
			clear
			echo -e "Veuillez entrer le nombre de segment : \n\t(${msg_retour})\n\t(tapez 0 pour copier le fichier if en totalite)"
			read read_count 
			fonc_test_retour "${read_count}" && count=${read_count}
			fonc_menu_principal
		;;
		"`eval $total_size_msg` `eval \"$total_size\"`")
			clear
			echo -e "Veuillez entrer `eval $total_size_msg` `eval \"$total_size\"` : \n\t(${msg_retour})\n\t(tapez 0 pour copier le fichier if en totalite)"
			read read_total_size 
			fonc_test_retour "${read_total_size}" && fonc_calc_count	
			fonc_menu_principal
		;;
		"Creer le fichier")
			fonc_dd_generator
			fonc_sortie $?  
		;;
		"Quitter")
			fonc_sortie 0
		;;
		
	esac
	echo ""
	REPLY=
	clear
	echo -e "\n\n\tDD GENERATOR\n\n"
	done
	clear
}
fonc_dd_generator(){
    if test $count -eq 0 
	then 	
		echo "dd of=`eval ${of_path}` if=${if_path} ibs=${ibs}"
		dd of=`eval ${of_path}` if=${if_path} ibs=${ibs} && 
		echo "Le fichier `eval ${of_path}` a été créé" 
	else
		echo "dd of=`eval ${of_path}` if=${if_path} ibs=${ibs} count=${count}" 
		dd of=`eval ${of_path}` if=${if_path} ibs=${ibs} count=${count}&& 
		echo "Le fichier `eval ${of_path}` a été créé" 
	fi
}
fonc_test_retour(){
	if test "$1" == "retour99" -o -z "$1" 
	then
		return 250
	else
		return 0
	fi
}
menu_unit(){
	clear

        #TITRE
        echo -e "\n\n\tUnite actuelle : $unit\n\n"
        PS3="Selectionner une option et appuyer sur Entrer :"

        select options in "octets" "Ko" "Mo" "Go" "To" "Retour"
	do
		case ${options} in 
			"octets")
				unit='octets'
				fonc_calc_unit
				fonc_menu_principal
			;;
			"Ko")
				unit='Ko'
				fonc_calc_unit
				fonc_menu_principal
			;;
			"Mo")
				unit='Mo'
				fonc_calc_unit
				fonc_menu_principal
			;;
			"Go")
				unit='Go'
				fonc_calc_unit
				fonc_menu_principal
			;;
			"To")
				unit='To'
				fonc_calc_unit
				fonc_menu_principal
			;;
			"Retour")
				fonc_menu_principal
				break
			;;
		esac
        echo ""
        REPLY=
        clear
        echo -e "\n\n\tUnit actuelle : $unit\n\n"
        done
        clear

}
fonc_calc_count(){
	count=`expr ${read_total_size} \* ${unit_calc} \/ ${ibs}`
}

##################################
#	SCRIPT
##################################
fonc_menu_principal
# end of script
```

# Résultat du script dd_generator.sh

```
################
# DD GENERATOR #
################
dd of=/SCRIPTS/dd_9.76Mo_15-10-14_09.53.09.bin if=/dev/zero ibs=1024 count=10000
1) Unite par defaut : Mo
2) Fichier lu : /dev/zero
3) Fichier ecrit : /SCRIPTS/dd_9.76Mo_15-10-14_09.53.09.bin
4) Taille segment de lecture (octet) : 1024
5) Nombre de Segment : 10000
6) Taille Totale (en Mo) : 9.76
7) Creer le fichier

8) Quitter
Selectionner une option et appuyer sur Entrer :7

dd of=/SCRIPTS/dd_9.76Mo_15-10-14_09.53.09.bin if=/dev/zero ibs=1024 count=10000
10000+0 enregistrements lus
20000+0 enregistrements écrits
10240000 octets (10 MB) copiés, 0,05625 seconde, 182 MB/s
Le fichier /SCRIPTS/dd_9.76Mo_15-10-14_09.53.09.bin a été créé
15/10/2014 - 09:53:33 :
15/10/2014 - 09:53:33 : Fin du script. Exit : 0

#ls -lisa /SCRIPTS/dd_9.76Mo_15-10-14_09.53.09.bin
23592966 10016 -rw-r--r-- 1 root root 10240000 oct 15 09:53 /SCRIPTS/dd_9.76Mo_15-10-14_09.53.09.bin
#ls -lisah /SCRIPTS/dd_9.76Mo_15-10-14_09.53.09.bin
23592966 9,8M -rw-r--r-- 1 root root 9,8M oct 15 09:53 /SCRIPTS/dd_9.76Mo_15-10-14_09.53.09.bin
```
