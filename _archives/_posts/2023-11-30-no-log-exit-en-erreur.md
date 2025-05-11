---
layout: post
title: No log, exit en erreur, saut de ligne dans param
date: 2023-11-30 12:00:00
author: Virtual Thom
---
v7.1.1b5  
Petit bug mais plutôt sain en fait. Disons que je n'avais pas le cas avant mais ça me semble normal que ça plante.  
Saut de ligne dans Param du job vtom == plantage du script, pas de log, et retour chelou dans vtom avec le bon tsend.  
Ca sent le vieux copié / collé depuis excel dans le param du job.  
Pour les repérer, `vtexport -x` et chercher la pattern regex `^]]></Parameter>$`

Editer le job en question et supprimer à la mano l'espace à la fin, ça règle le problème.  

```
# là on voit bien les sauts de lignes sur param 2, 3, 4, 5, 6, 7
            <Job name="put_luke_contacts" retained="0" family="leia" comment="Depot du fichiers en provenance du cyberespac" information=" " frequency="D" onDemand="0" isAsked="0" cycleEnabled="0" cycle="00:00:00" minStart="04:10:00" maxStart="23:10:00" mode="E" hostsGroup="starship" queue="queue_sh" user="skyw" retcode="-1" status="W" statusTime="29-11-2023 09:55:12" substatus="0" appInErr="1" descOnErr="0" blockDate="0" restartType="M" restartCount="0" restartMax="1" restartDelay="00:00:00" restartLabel="0" timeBegin="1701251193" timeEnd="1701251195" ipid="0" mepType="E">
              <Script><![CDATA[#/usr/local/spool/SCRIPTS/transfert_ftp.sh]]></Script>
              <Parameters>
                <Parameter><![CDATA[--client "anakin"]]></Parameter>
                <Parameter><![CDATA[--ip 1.1.1.1
]]></Parameter>
                <Parameter><![CDATA[--action put
]]></Parameter>
                <Parameter><![CDATA[--rep-source "/usr/local/spool/leia/EM"
]]></Parameter>
                <Parameter><![CDATA[--rep-cible /ImportAuto/
]]></Parameter>
                <Parameter><![CDATA[--on-error stop
]]></Parameter>
                <Parameter><![CDATA[--file-name csv
]]></Parameter>
                <Parameter><![CDATA[--delete]]></Parameter>
                <Parameter><![CDATA[--function sftp]]></Parameter>
                <Parameter><![CDATA[--ftp-mode --ftp-pasv]]></Parameter>
              </Parameters>
              <Node objectType="job" x="270" y="260" z="0"/>
            </Job>
```
