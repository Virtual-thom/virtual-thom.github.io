---
layout: post
title: Corrélation entre les jobs VTOM et les policy netbackup
date: 2015-09-13 12:30
author: Virtual Thom
categories: [unix, shell, bash, netbackup, policy, schedule, host, VTOM]
---

### But :

Vérifier qu'on a bien autant de jobs VTOM que de couple Netbackup POLICY / SCHEDULE / HOSTS


### Méthode :

Je n'ai pas trouvé comment faire un dump des policies (stratégies de sauvegardes Netbackup) en XML ou autre format facilement exploitable.
Il y a bien le `bppllist` mais la sortie à l'écran n'est pas très pratique à retraiter.

Il semblerait que les données du référentiel Netbackup se retrouvent dans des fichiers plats / nom de dossiers.

J'ai pu retrouver toutes les policies dans `/usr/openv/netbackup/db/class` par exemple. On peut y récupérer les schedules, les hosts, etc.

### Pré-requis

On veut un fichier généré par un script VTOM avec les objets suivants : 
```
env;app;job;script;host;[parameter|[parameter|]..]
```

Cf. [vthttpd -dump]({{ site.baseurl | prepend: site.url }}/vthttpd-dump-requete-sql)
ou  [tlist amélioré]({{ site.baseurl | prepend: site.url }}/vtom-tlist-ameliore-affichage-script-parametres-et-autres-champs)

```bash
    
		export FIC_ALL_JOBS=/var/tmp/all_jobs_tlist.txt
		fn_Controle_Presence_Fichier ${FIC_ALL_JOBS}
		test ${vRC_CODE} -ne 0 && break
		
		fn_WriteLog " "
		fn_WriteLog "INFO -- Correlation entre les jobs VTOM et les couples de policies / schedule / hosts"
		
		# Répertoire des class netbackup (policies)
		export NB_DB=/usr/openv/netbackup/db/class
		
		POLICIES_EXCLUSION="VTOM_xxx VTOM_yyyy"
		# On boucle sur tous les jobs de ${DOMAINE} avec le script Script_netbackup.sh qui correspond au lancement des sauvegardes NB
		while read POLICY ; do
			for POLICY_EXCLUSION in $(echo "${POLICIES_EXCLUSION}")
			do 
				if test "${POLICY}" == "${POLICY_EXCLUSION}";then
					fn_WriteLog "INFO -- Cette police ${POLICY} a ete exclus du check"
					continue 2
				fi
			done
			fn_WriteLog " "
			# les SCHED_TYPE doivent être :
			#	0 (automatique INCR) ou 1 (automatique FULL), 4 (cumulative INCR)
			# NE PAS ETRE : 2 c'est application (et ça n'est pas à intégrer dans VTOM)
			NB_SCHEDULE_EXCLUSION='| grep -v "EXCEPT"'
			NB_SCHEDULE='ls -1 '${NB_DB}'/'${POLICY}'/schedule/*/info '${NB_SCHEDULE_EXCLUSION}'| while read info ; do SCHED_TYPE=`grep "SCHED_TYPE" $info | sed "s/SCHED_TYPE[    ]*//"` ; if test $SCHED_TYPE -eq 0 -o $SCHED_TYPE -eq 1 -o $SCHED_TYPE -eq 4; then echo $info ; fi ; done'
			
			NB_CLIENTS_EXCLUSION=''
			NB_CLIENTS="cat ${NB_DB}/${POLICY}/clients "${NB_CLIENTS_EXCLUSION}"| grep -v \"^#\""
			
			# on multiplie le nombre de schedule par le nombre de clients par policy
			NB_JOBS_ATTENDUS=`expr $(eval "${NB_SCHEDULE} | wc -l") \* $(eval "${NB_CLIENTS} | wc -l")`
			
			NB_JOBS_VTOM=`grep ";${POLICY}|" ${FIC_ALL_JOBS} | grep "${DOMAINE}ADMBK001" | wc -l`
			
			fn_WriteLog "INFO -- Policy : ${POLICY}"
			fn_WriteLog "INFO -- Nombre de jobs attendus : ${NB_JOBS_ATTENDUS}"
			fn_WriteLog "INFO -- Nombre de jobs VTOM : ${NB_JOBS_VTOM}"
			if test ${NB_JOBS_ATTENDUS} -ne ${NB_JOBS_VTOM}; then
				fn_WriteLog "ERROR -- Les jobs VTOM ne correspondent pas au jobs attendus par rapport a netbackup"
				fn_WriteLog "INFO -- Jobs dans VTOM avec cette policy : "
				grep ";${POLICY}|" ${FIC_ALL_JOBS} | grep "${DOMAINE}ADMBK001"
				fn_WriteLog "INFO -- Schedules Netbackup : "
				eval 'ls -1 '${NB_DB}'/'${POLICY}'/schedule/*/info '${NB_SCHEDULE_EXCLUSION}
				fn_WriteLog "INFO -- clients Netbackup : "
				eval "cat ${NB_DB}/${POLICY}/clients "${NB_CLIENTS_EXCLUSION}"| grep -v \"^#\""
				vRC_CODE=20
				continue
			fi

			fn_WriteLog "OK -- match ok"
		
		done < <(cat ${FIC_ALL_JOBS} | grep "${DOMAINE}ADMBK001" | grep "Script_netbackup.sh"| cut -d";" -f6 | awk -F"|" '{print $1}' | sort | uniq)
		# Mes jobs netbackup ont ce script "Script_netbackup.sh" et la machine d'exécution est ${DOMAINE}ADMBK001
```

Les fonctions préfixées fn_ ne sont pas définies ici mais sont assez explicites. 
