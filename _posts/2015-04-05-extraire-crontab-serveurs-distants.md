---
layout: post
title: Extraction des crontabs de tous les utilisateurs en local ou à distance
date: 2015-04-05 10:58
author: Virtual Thom
comments: true
categories: [crontab, crontab -l, sh, script, extraire crontab à distance, tâches planifiees, schtasks /query]
---

Le principe est d'exécuter  `crontab -l -u user` (linux) ou `crontab -l user` (solaris) pour tous les utilisateurs et pour tous les serveurs distants passés en paramètre dans un fichier.

Voici comment récupérer facilement la liste de vos clients :

```bash
vtmachine | awk  -F"|" '$7 ~ /Win/ {print $3}' | sed 's/^[ \t]*\|[ \t]*$//g' > /var/tmp/liste_client_windows.txt
vtmachine | awk  -F"|" '$7 ~ /Sol|Lin/ {print $3}' | sed 's/^[ \t]*\|[ \t]*$//g' > /var/tmp/liste_client_unix.txt
```


Script shell à télécharger : [Extract_Crontab.sh](https://virtual-thom.github.io/scripts/Extract_Crontab.sh)

```bash
# Script qui pousse un sous-script permettant d'afficher la crontab de tous les utilisateurs
# et l'exécute sur des serveurs distants 
# ou en local si aucun paramètre
# A lancer en root

# Le premier paramètre doit être le chemin complet d'un fichier listant des serveurs linux ou Solaris
# Le serveur sur lequel est exécuté le script doit pouvoir communiquer en ssh avec les serveurs distants
FIC_LISTE_SERVEURS=$1

# On set le code retour à 0
CR=0

# Sous-script à exécuter sur les serveurs distants
FIC_SUBSCRIPT=/var/tmp/`basename $0`_${RANDOM}_`date +"%d%m%Y"`.sh

# fichier de sortie des crontabs -l des utilisateurs 
# format hostname;user;ligne crontab (commentaires et lignes vides non prises en compte)
FIC_SORTIE_EXT_CRONTAB=/var/tmp/`basename $0`_${RANDOM}_`date +"%d%m%Y"`.csv
> ${FIC_SORTIE_EXT_CRONTAB}

# Ecriture du sous-script
# si le crontab -l -u user ne fonctionne pas sur votre machine distante, on peut imaginer créer
# une couche d'abstraction pour la commande crontab selon l'OS
echo "awk -F\":\" '\$NF !~ /(nologin|sync|shutdown|halt|false)/ {print \$1}' /etc/passwd | while read user ;do \
export user; \
FIC_TEMP=/var/tmp/\${RANDOM}_crontab-l; \
crontab -l -u \${user} > \$FIC_TEMP 2> /dev/null ; \
if test \$? -ne 0 ; then \
 crontab -l \${user} > \$FIC_TEMP 2> /dev/null ; \
 if test \$? -ne 0 ; then \
  rm -f \$FIC_TEMP; \
  continue ; \
 fi ; \
fi ; \
while read line ; do \
 if test -z \"\$line\" ; then \
  continue ; \
 fi ; \
 echo \"\$line\" | grep \"^#\" > /dev/null 2>&1 ;\
 if test \$? -eq 0 ; then \
  continue ; \
 fi ; \
 printf \"%s;%s;%s;\\\n\" \"\`uname -n\`\" \"\${user}\" \"\${line}\" ; \
done < \${FIC_TEMP}; \
rm -f \$FIC_TEMP; 
done" > ${FIC_SUBSCRIPT}


# Si la liste des serveurs distants est vide, on exécute le sous-script en local
if test -z "${FIC_LISTE_SERVEURS}";then
  chmod +x ${FIC_SUBSCRIPT}
  ${FIC_SUBSCRIPT} >>  ${FIC_SORTIE_EXT_CRONTAB}
else
  NB_SERVEURS=`cat ${FIC_LISTE_SERVEURS} | wc -l`
  BOUCLE_COURRANTE=0

  
  while read SERVEUR_DISTANT
  do 
    BOUCLE_COURRANTE=`expr ${BOUCLE_COURRANTE} + 1`
    echo "INFO -- ${SERVEUR_DISTANT} : ${BOUCLE_COURRANTE}/${NB_SERVEURS}"
    
    # on continue dans la boucle si le ping ne fonctionne pas
    ping -c 1 ${SERVEUR_DISTANT} > /dev/null  2>&1
    if [ $? -ne 0 ];then
      echo "ERROR -- PING serveur ${SERVEUR_DISTANT}"
      CR=10
      continue
    fi
    
    # ssh -n dans une boucle while sinon on sort de la boucle à la première occurence
    # on continue si le ssh/scp ne fonctionne pas
    scp ${FIC_SUBSCRIPT}  ${SERVEUR_DISTANT}:/var/tmp/ > /dev/null
    ssh -n ${SERVEUR_DISTANT} "chmod 777 /var/tmp/`basename ${FIC_SUBSCRIPT}`"
    if [ $? -ne 0 ];then
      echo "ERROR -- SSH serveur ${SERVEUR_DISTANT}"
      CR=11
      continue
    fi

    ssh -n ${SERVEUR_DISTANT} "/var/tmp/`basename ${FIC_SUBSCRIPT}`" >> ${FIC_SORTIE_EXT_CRONTAB}

  done < ${FIC_LISTE_SERVEURS}
fi

exit $CR
```

Pour déployer facilement un script depuis le serveur VTOM vers tous les clients, on peut aussi utiliser le `vtcopy`

```
vtmachine | grep -i running | awk -F"|" 'BEGIN{printf "tremote /machine="}{gsub(/[ 	]/, "", $2); printf "%s,",$2;}END{printf " vtcopy -i monfic_source -o mon_rep_dest\n"}'
```

Version tâches planifiées Windows (filtre des tâches microsoft) schtasks /query : 

```batch
@echo off
set USER=administrateur
set PASSWD=motdepasse
for /F %i in (c:\temp\liste_client_windows.txt) do (
schtasks /Query /FO CSV /V /S %i /U %USER% /P %PASSWD% | findstr /V "\Microsoft" | findstr /V '"HostName","TaskName","Next Run Time","Status","Logon Mode","Last Run Time","Last Result","Author","Task To Run","Start In","Comment"' 
) >> c:\temp\taches_planifiees_windows.csv
@echo on
```
