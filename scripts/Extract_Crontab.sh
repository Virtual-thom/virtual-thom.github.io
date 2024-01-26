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
