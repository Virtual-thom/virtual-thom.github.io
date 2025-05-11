---
layout: post
title: V6 VTOM Full PostgreSQL
date: 2017-07-11 21:10
author: Virtual Thom
categories: [postgresql, psql, VTOM, V6]
---
La V6 est entre mes mains !

C'est beau tout ce petit monde en full PostgreSQL.

En avant première :bowtie:, une p'tite requête psql qui va lister tous les jobs.

Je ne connaissais pas [coalesce()](https://www.postgresql.org/docs/8.1/static/functions-conditional.html#AEN12663), c'est plutôt pratique ! surtout avec les hierarchies par défaut de VTOM env>app>job.

On passe une liste d'éléments à la fonction, et elle retourne le premier élément non nul, ou `null` s'ils le sont tous.

Les collections et les clichés me semblent très prometteurs. Prémices du versioning ??? en tous cas, pas mal du tout. Il faut que je me penche dessus. Il manquerait d'après moi, la possibilité d'exporter nos clichés au format XML (mais je n'ai peut-être pas encore tout vu !)

```sql
--
-- sgbd/bin/psql -p <portsgbd> -d "vtom" -U "vtom"
/*
 Schema |                  Name                  |   Type   | Owner
--------+----------------------------------------+----------+-------
 public | vt_accounts                            | table    | vtom
 public | vt_alarm_properties                    | table    | vtom
 public | vt_alarms                              | table    | vtom
 public | vt_analyze_filter                      | table    | vtom
 public | vt_calendars                           | table    | vtom
 public | vt_col_collections                     | table    | vtom
 public | vt_col_snapshots                       | table    | vtom
 public | vt_core_applications                   | table    | vtom
 public | vt_core_calendars                      | table    | vtom
 public | vt_core_context_variables              | table    | vtom
 public | vt_core_contexts                       | table    | vtom
 public | vt_core_date_blocking_jobs             | table    | vtom
 public | vt_core_dates                          | table    | vtom
 public | vt_core_environments                   | table    | vtom
 public | vt_core_environments_used_calendars    | table    | vtom
 public | vt_core_environments_used_contexts     | table    | vtom
 public | vt_core_environments_used_dates        | table    | vtom
 public | vt_core_environments_used_hosts_groups | table    | vtom
 public | vt_core_environments_used_periods      | table    | vtom
 public | vt_core_environments_used_queues       | table    | vtom
 public | vt_core_environments_used_resources    | table    | vtom
 public | vt_core_environments_used_users        | table    | vtom
 public | vt_core_expected_resources             | table    | vtom
 public | vt_core_hosts                          | table    | vtom
 public | vt_core_hosts_groups                   | table    | vtom
 public | vt_core_hosts_groups_hosts             | table    | vtom
 public | vt_core_intervals                      | table    | vtom
 public | vt_core_job_occs                       | table    | vtom
 public | vt_core_job_parameters                 | table    | vtom
 public | vt_core_jobs                           | table    | vtom
 public | vt_core_links                          | table    | vtom
 public | vt_core_objects                        | table    | vtom
 public | vt_core_periods                        | table    | vtom
 public | vt_core_plannings                      | table    | vtom
 public | vt_core_queues                         | table    | vtom
 public | vt_core_resources                      | table    | vtom
 public | vt_core_resources_date                 | table    | vtom
 public | vt_core_resources_extern               | table    | vtom
 public | vt_core_resources_extern_parameters    | table    | vtom
 public | vt_core_resources_file                 | table    | vtom
 public | vt_core_resources_generic              | table    | vtom
 public | vt_core_resources_generic_parameters   | table    | vtom
 public | vt_core_resources_numeric              | table    | vtom
 public | vt_core_resources_stack                | table    | vtom
 public | vt_core_resources_text                 | table    | vtom
 public | vt_core_resources_weight               | table    | vtom
 public | vt_core_tokens                         | table    | vtom
 public | vt_core_users                          | table    | vtom
 public | vt_deployment_repositories             | table    | vtom
 public | vt_domain_counter                      | sequence | vtom
 public | vt_domains                             | table    | vtom
 public | vt_graph_default_properties            | table    | vtom
 public | vt_graph_links                         | table    | vtom
 public | vt_graph_nodes                         | table    | vtom
 public | vt_graph_object_properties             | table    | vtom
 public | vt_graph_pins                          | table    | vtom
 public | vt_graphs                              | table    | vtom
 public | vt_histo                               | table    | vtom
 public | vt_histo_counter                       | sequence | vtom
 public | vt_histo_date_count                    | table    | vtom
 public | vt_holidays                            | table    | vtom
 public | vt_holidays_groups                     | table    | vtom
 public | vt_holidays_groups_holidays            | table    | vtom
 public | vt_icons                               | table    | vtom
 public | vt_ihm_desktops                        | table    | vtom
 public | vt_ihm_desktops_dispositions           | table    | vtom
 public | vt_instructions                        | table    | vtom
 public | vt_job_application_server_properties   | table    | vtom
 public | vt_job_application_servers             | table    | vtom
 public | vt_jobs                                | table    | vtom
 public | vt_license_entries                     | table    | vtom
 public | vt_objects_alarms                      | table    | vtom
 public | vt_objects_instructions                | table    | vtom
 public | vt_profiles                            | table    | vtom
 public | vt_profiles_accounts                   | table    | vtom
 public | vt_profiles_rights                     | table    | vtom
 public | vt_properties                          | table    | vtom
 public | vt_resources                           | table    | vtom
 public | vt_rights                              | table    | vtom
 public | vt_stats_current                       | table    | vtom
 public | vt_stats_date_count                    | table    | vtom
 public | vt_stats_job                           | table    | vtom
 public | vt_stats_job_counter                   | sequence | vtom
 public | vt_stats_realtime                      | table    | vtom
 public | vt_tdf_lots                            | table    | vtom
 public | vt_tdf_lots_receive                    | table    | vtom
 public | vt_tdf_lots_receive_counter            | sequence | vtom
 public | vt_tdf_lots_send                       | table    | vtom
 public | vt_tdf_lots_send_counter               | sequence | vtom
 public | vt_tdf_lots_transfer                   | table    | vtom
 public | vt_tdf_rules                           | table    | vtom
 public | vt_tdf_rules_groups                    | table    | vtom
 public | vt_tdf_rules_groups_rules              | table    | vtom
 public | vt_tdf_sites                           | table    | vtom
 public | vt_views                               | table    | vtom
 public | vt_web_desktops                        | table    | vtom
 public | vt_web_desktops_dispositions           | table    | vtom

 vt_core_jobs
 vtenvsid|vtappsid|vtjobsid|vtid|vtname|vtcomment|vtexploited|vtpriorityenabled|vtpriority|vtfamily|vtscript|vtfrequency|vtondemand|vtcycleenabled|vtcycle|vtminstart|vtmaxstart|vtmaxlength|vtexecmode|vthostsgroupid|vtqueueid|vtuserid|vtappinerror|vtdesconerror|vtdescafter|vtblockdate|retrytype|vtretrymax|vtretryscript|vtlogprint|vtlogremove|vtlogcopy|vtalarmfatale|vtalarmsevere|vtalarminfo|vteventwait|vteventrunning|vteventfinished|vteventunscheduled|vteventerror|vteventdescheduled|vtmovementtime|vtjobtype|vtjobapplicationserversid|vtlogsretention|vtstatus|vtipid|vtistsend|vttsendflag|vtisretry|vtretrycount|vtretrystep|vtmessage|vttimebegin|vttimeend|vtisretained|vtisasked|vtlastrun|vtlaststop|vtlaststatus|vtforcestatus|vtexecutionstate|vtbegindate|vtenddate|vtrefjobsid
*/
--


select 	
		e.vtname as vtenvname,
		a.vtname as vtappname,
		j.vtname as vtjobname,
		j.vtscript,
		array_to_string(
			array(
				select vtposition || ':' || vtvalue -- est ce que le numero param est vraiment utile si order by vtposition
				from vt_core_job_parameters p
				where p.vtjobsid = j.vtjobsid
				order by vtposition
			),
			' ' -- separator entre les parametres
		) as vtparameters,
		h.vtname as vthostgroup, -- nom de l'unite de soumission, il faut faire une sous requete si on veut les hosts d'une u.s
		q.vtname as vtqueuename,
		u.vtname as vtusername,
		coalesce(j.vtcomment,a.vtcomment) as vtcomment,
		to_char((coalesce(j.vtminstart,a.vtminstart) || ' second')::interval, 'HH24:MI:SS') as vtminstart,
		case
			when (coalesce(j.vtmaxstart,a.vtmaxstart) = 86399) then	'Illimité'
			else to_char((coalesce(j.vtmaxstart,a.vtmaxstart) || ' second')::interval, 'HH24:MI:SS')
		end
			as vtmaxstart
from vt_core_jobs j
left join vt_core_environments e on e.vtsid = j.vtenvsid
left join vt_core_applications a on a.vtappsid = j.vtappsid
left join vt_core_queues q on q.vtid = coalesce(j.vtqueueid,a.vtqueueid,e.vtqueueid)
left join vt_core_users u on u.vtid = coalesce(j.vtuserid,a.vtuserid,e.vtuserid)
left join vt_core_hosts_groups h on coalesce(j.vthostsgroupid, a.vthostsgroupid, e.vthostgroupid) = h.vtid
-- filtres dans le where
--where 
	--e.vtname = 'supervision'
;
```


```
  vtenvname  | vtappname  |    vtjobname     |                   vtscript                   |                                       vtparameters                                        |   vthostnam
e   | vtqueuename | vtusername  |                                      vtcomment                                       | vtminstart | vtmaxstart
-------------+------------+------------------+----------------------------------------------+-------------------------------------------------------------------------------------------+------------
----+-------------+-------------+--------------------------------------------------------------------------------------+------------+------------
 supervision | appxxxxx   | jobxxxxx        | PATH_SERVICES_SHELL/scriptxxxxx.ksh             |                                                                                           | hostxxxxx
    | queue_ksh.9 | userxxx | reception de fichiers                                                                | 08:00:00   | 19:30:00
 supervision | appxxxxx   | jobxxxxx        | PATH_SERVICES_SHELL/scriptxxxxx.ksh          | 1:edi                                                                                     | hostxxxxx
    | queue_ksh.9 | userxxx | Mise a disposition des fichiers client publipostage                                  | 20:00:00   | 30:00:00hostxxxxx
 supervision | appxxxxx   | jobxxxxx        | PATH_ADMIN_SHELL/scriptxxxxx.sh                 |                                                                                           | hostxxxxx
    | queue_ksh.9 | userxxx | Transfert des fichiers client publipostage editique                                  | 10:00:00   | 30:00:00
 supervision | appxxxxx   | jobxxxxx        | PATH_SERVICES_SHELL/scriptxxxxx.ksh          | 1:rmp                                                                                     | hostxxxxx
    | queue_ksh.9 | userxxx | Mise a disposition des fichiers encarts RMP                                          | 20:00:00   | 30:00:00
 supervision | appxxxxx   | jobxxxxx        | PATH_ADMIN_SHELL/scriptxxxxx.sh                 |                                                                                           | hostxxxxx
    | queue_ksh.9 | userxxx | Transfert des fichiers client encarts RMP                                            | 10:00:00   | 30:00:00
 supervision | appxxxxx   | jobxxxxx        | PATH_SERVICES_SHELL/scriptxxxxx.ksh             |                                                                                           | hostxxxxx
    | queue_ksh.9 | pdtrf0      | épuration des fichiers de plus de x jours GOC,DEI.......                             | 07:00:00   | Illimité

```
