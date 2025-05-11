---
layout: post
title: les bizarreries de la semaine 
date: 2015-08-06 17:58
author: Virtual Thom
categories: [log VTOM, .i, ERRORLEVEL, batch, VTOM, echo]
---
Quelques bizarreries de le semaine :

* Script batch : Le echo ne modifie pas le errorlevel ! 
* Attention aux & dans les paramètres ou dans les ressources VTOM. Ca peut avoir comme résultat assez drôle de n'afficher aucun log VTOM tout en ayant un retour tsend
* Les fichiers avec extension .i dans le répertoire de logs VTOM est normal depuis la 5.7xx ! Il semblerait que ça serve aux alarmes.
* fichier log sur le client VTOM à 0 ko ou pas la fin de la log. Mais, le job se statue bien. Dans mon cas, c'est un bug, le tsend du client vers le serveur de backup VTOM était bloqué (impossible de communiquer avec le backup)


Quelques bouts de code de la semaine : 
* Script PERL : charger un fichier XML et récupérer des informations

```perl 
#!/usr/bin/perl
use XML::LibXML ;


# Load DOM du fichier XML
my $dom = XML::LibXML->new()->parse_file($ARGV[0]) ;
# Item à récupérer
my $item = $ARGV[1] ;


my $logVTOM =  $dom->findvalue('/runResponse/runReturn/item/name[contains(text(),\'flowResult\')]/../value') ;
my $flowResponse =  $dom->findvalue('/runResponse/runReturn/item/name[contains(text(),\'flowResponse\')]/../value') ;

# On clean le flowResult pour construire un résultat XML et on charge le DOM en mémoire
$logVTOM =~ s/.*(<VTOM_RESULT>.*)/$1/ ;
$logVTOM =~ s/(.*<\/VTOM_RESULT>).*/$1/ ;

my $domLogVTOM = XML::LibXML->load_xml(
	string => $logVTOM
) ;

print $domLogVTOM->findvalue('/VTOM_RESULT/VTOM_STDERR') if($item eq "VTOM_STDERR"); 
print $domLogVTOM->findvalue('/VTOM_RESULT/VTOM_STDOUT') if($item eq "VTOM_STDOUT"); 
print $domLogVTOM->findvalue('/VTOM_RESULT/VTOM_CR') if($item eq "VTOM_CR"); 
print $flowResponse if($item eq "flowResponse");
```

* Script VTOM : lister les machines Windows VTOM et y associer l'utilisateur Log On "AbsyssBatchManager"

```bash
vtmachine | grep -i Win | awk -F"|" '{print $2}' | sed 's/[   ]//g' | while read machine; do vtmachine -i $machine ; done > /var/tmp/vtmachine_windows_infotag.txt
egrep "(Logical Name|Username)" /var/tmp/vtmachine_windows_infotag.txt | awk -F"|" '{print $3}' | sed 's/[    ]//g' > /var/tmp/liste_machine_user_windows.txt
compteur=0; while read line ; do echo -en "$line" ; if test `expr $compteur % 2` -eq 1 ; then echo "" ; else echo -en ";" ; fi ; compteur=`expr $compteur + 1` ; done < /var/tmp/liste_machine_user_windows.txt
```

(Attention des fois le vtmachine /info ne donne pas de Username)

* lister les dates communes à plusieurs environnements (dangereux ! ne pas faire ça, sinon on ne sait pas quel moteur va faire basculer la date)

```shell
tlist env/date | sort -u -k"2,2" -k"1,1" | awk '{print $2}' | uniq -c | awk '$1 > 1'
      2 date_system
      2 prod_0_agp
      2 prod_0_jour
      2 prod_0_saveUn
```

* Petite astuce pour récupérer le dernier startup tomcat avec le log catalina.out

```
date --date="$(grep -B 1 "INFO: Server startup" catalina.out | grep -v "INFO: Server startup" | tail -n1 | awk '{$NF="";$(NF-1)="" ;print}')"

# Si on décortique, 
# on grep INFO: Server startup et la ligne d'avant, on affiche la ligne d'avant seulement sans les deux derniers champs (pour récupérer seulement l'heure de démarrage)
```


 * ouvrir les ports des firewalls pour les flux VTOM, c'est sympa mais des fois, iptables bloque aussi :

```
cp -p /etc/sysconfig/iptables /etc/sysconfig/iptables.$(date +%Y%m%d) 
#Editer le fichier /etc/sysconfig/iptables 
#Ajouter avant la ligne "-A INPUT -j REJECT --reject-with icmp-host-prohibited" les 2 lignes suivantes : 
-A INPUT -s x.x.x.x/32 -p tcp -m state --state NEW -m tcp --dport 30004 -j ACCEPT 

#Relancer le serice iptables : 
service iptables stop 
service iptables start
```
