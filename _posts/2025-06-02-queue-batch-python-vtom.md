---
layout: post
slug: queue batch python vtom
title: Une (vraie) queue_python VTOM
---
ancien post ici : [Ecrire sa queue_batch](/archives/ecrire-sa-queue-batch-vtom-cygwin-php-perl/)

## Dis, c'est quoi une queue batch VTOM ?
Quand j'ai commencé VTOM (18 ans, aïe, ça fait mal), la queue batch était un concept un peu abstrait (bon en même temps, tout était un peu abstrait à l'époque).  

`Le nom de la Queue batch est associé à un fichier de commandes encapsulant le script applicatif sur l’Agent cible et à une configuration.` Tous les  mots dans cette phrase sont importants.  

"C'est pas faux."   

C'est un script qui englobe et qui lance ce qu'on a dans le champ "script" de notre job VTOM.  
Pas forcément un script d'ailleurs, ça peut être une ligne de commande, ou tout autre mot clé qu'on aura défini pour "servir" dans notre queue.  
Et cela, avec les paramètres, sur l'agent (ça a beau être une unité de soumission maintenant, in fine, c'est sur un agent), et un utilisateur qu'on aura défini sur notre job VTOM.  

Et pour faire simple, il y a 3 grandes étapes dans une queue : 
 * charger des variables d'environnement de l'agent (vtom_init.xxx)
    * facultatif

 * afficher des infos : surtout des variables d'environnement qui sont passées par le serveur VTOM (+ infos var env de l'agent)
    * facultatif, on fait ce qu'on veut en fait MAIS fortement conseillé d'utiliser les variables officielles à minima du tom_submit.aff (si on veut utiliser les alarmes vtom et logs joints par exemple, besoin du tom_job_id etc)

 * lancer ce qu'on a dans TOM_SCRIPT
    * comme déjà dit, pas forcément, on fait ce qu'on veut de nos variables d'environnements, mais à la pelle, on lance TOM_SCRIPT avec ses arguments %*, $*, sys.argv, etc.

 * renvoyer au serveur le résultat de l'exécution via `tsend`
    * obligatoire même si l'agent est en DMZ vtom.ini [BDAEMON] connectToServer=0 (auquel cas, c'est le serveur qui viendra check le `$TOM_HOME/abm/spool`)

Autres étapes qui peuvent être utiles pour les jobs VTOM :
 * gestlog : la gestion des logs via la configuration du job vtom
 * mode d'exécution TEST : pour ne pas éxécuter réellement notre script ou faire une chose différente
 * l'exécution des ressources génériques : redirect vers tom_submit.rcgen

## pourquoi une "vraie" queue python
Dans 99% des cas : 
 * une queue unix, même si c'est pour lancer du perl, du python, ou autre, c'est une queue `shell` qui lance du perl, python ou autre
 * une queue windows, même si c'est pour lancer du powershell, perl, du python, ou autre, c'est une queue `bat` qui lance du powershell, perl, python ou autre

On est d'accord que si vous voulez lancer du python, pas besoin de faire tout ce qui suit.  
Changez juste :  `call "%TOM_SCRIPT%" %*`  en  `python "%TOM_SCRIPT%" %*`

Une "vraie" queue python est écrite en python et pas en shell ou bat.  
Pourquoi ? parce que ! c'est dimanche, et il pleut.  
[Ecrire sa queue_batch](/archives/ecrire-sa-queue-batch-vtom-cygwin-php-perl/) est l'article le plus lu de mon blog. Du coup, petite mise à jour.   

Mais plus sérieusement, pour prouver que ça n'est "que" du script, et que vous pouvez faire (presque) ce que vous voulez dans votre queue batch.  

## mise en place sur linux
je vais faire exprès de nommer différemment les choses pour que vous compreniez le mécanisme (mais en prod, il vaut mieux nommer tout pareil pour plus de clarté) :

`$TOM_HOME/abm/config/queues`  
queue_peuimporte, c'est le dossier et vraiment, peu importe le nom
```
cp -r queue_batch queue_peuimporte
```

`$TOM_HOME/abm/config/queues/queue_peuimporte/queue.conf`  
```
queue_pythonlavraie
30
-1
/usr/bin/python3
20
```

queue_pythonlavraie : le VRAI nom de la queue à mettre dans VTOM  
30                  : nb jobs max en simultané  
-1                  : nb max de jobs en attente (-1 illimité)  
/usr/bin/python3    : ce que le bdaemon fork vraiment suivi de param1 param2 etc.  
20                  : priorité  


$TOM_HOME/admin/tom_submit.python3 `python3` doit être le même filename que dans queue.conf  (4ème ligne, basename/filname)  
Comme c'est un peu perturbant, vous pouvez mettre un lien symbolique. Exemple :  
```
queue_pythonlavraie
30                 
-1                 
/opt/absyss/visual-tom/abm/bin/pythonlavraie
20 

# et faire un lien symbolique vers le binaire à exécuter :  
ln -s /usr/bin/python3 /opt/absyss/visual-tom/abm/bin/pythonlavraie

# auquel cas le fichier queue devra être nommé $TOM_HOME/admin/tom_submit.pythonlavraie
```

Je laisse exprès `/usr/bin/python3` pour que vous compreniez comment VTOM appelle ses queues.  

Ca va sans dire mais en le disant, c'est toujours mieux. Of course, il faut python d'installé : `sudo apt update && sudo apt install python3`  
[$TOM_HOME/admin/tom_submit.python3](/scripts/tom_submit.python3)
```python
#!/usr/bin/python3
import os
import re
import sys
import subprocess
from datetime import datetime

python_executable = sys.executable or 'python3'  # Fallback si sys.executable est vide

env_vars = {}

# Définit une valeur par défaut si TOM_ADMIN n'est pas dans les variables d'environnement
if "TOM_ADMIN" not in os.environ:
    os.environ["TOM_ADMIN"] = "/opt/absyss/visual-tom/admin"

script_path = os.path.expandvars("$TOM_ADMIN/vtom_init.ksh")

# on charge les variables d'environnements du vtom_init.ksh
with open(script_path) as f:
    for line in f:
        line = line.strip()

        # Ignore les commentaires et les lignes vides
        if not line or line.startswith('#'):
            continue

        # Matche les affectations simples comme VAR=val ; export VAR (c'est juste un exemple, à adapter selon votre vtom_init.ksh)
        match = re.match(r'^([A-Z0-9_]+)=([^;]*);\s*export\s+.*$', line)
        if match:
            key, value = match.groups()
            # Nettoyage des quotes éventuelles
            value = value.strip('"').strip("'")
            env_vars[key] = value

# on affiche les variables d'environnement TOM_ comme le tom_submit.aff
print("_______________________________________________________________________")
print("Visual TOM context of the job")
print(" ")
print(f"IPID : {os.environ.get('job_id', '')}")
# Filtrer les variables qui commencent par "TOM_"
tom_vars = {key: value for key, value in os.environ.items() if key.startswith("TOM_")}
# Trouver la longueur maximale des clés
max_key_len = max(len(key) for key in tom_vars)
for key, value in os.environ.items():
    if key.startswith("TOM_"):
        print(f"{key:<{max_key_len}}: {value}")

# Si vide on quitte
if not os.environ.get('TOM_JOB_ID','') :
    print(" ")
    print("--> Job not submitted by a Visual TOM engine")
    print(" ")
    sys.exit(0)

# ----------------------------------------------------- #
# 		    TOM SUBMITTER - PYTHON                      #
# ----------------------------------------------------- #


def tsend(status_type: str, return_code: int, message: str):
    abm_bin = os.environ.get("ABM_BIN")
    if not abm_bin:
        print("[WARN] ABM_BIN not set, skipping tsend")
        return
    tsend_path = os.path.join(abm_bin, "tsend")
    if os.path.isfile(tsend_path):
        exCmd = subprocess.run(
            [tsend_path, f"-s{status_type}", f"-r{return_code}", f"-m{message}"],
            check=True
        )
    else:
        print(f"[WARN] tsend not found at: {tsend_path}")
        return 123

    return exCmd.returncode

def print_banner(message: str):
    print("_______________________________________________________________________")
    print(datetime.now().strftime("%A %d/%m/%Y - %H:%M:%S"))
    print(message)
    print("_______________________________________________________________________")
    print()

def run_tom_script(tom_script: str, args: list) -> int:
    if not tom_script:
        print("[ERROR] TOM_SCRIPT is empty.")
        return 1

    if os.path.isfile(tom_script):
        # Cas : tom_script est un chemin vers un fichier Python
        cmd = [python_executable, tom_script] + args[1:]  
        print(cmd) 
    else:
        # Cas : code inline exécuter dans une sous-commande
        cmd = [python_executable, "-c", tom_script] + args[1:]
        print(cmd) 

    sys.stdout.flush()
    sys.stderr.flush()
    exCmd = subprocess.run(cmd)
    
    sys.stdout.flush()
    sys.stderr.flush()
    
    return exCmd.returncode

print_banner("Begin of the script...")

if os.environ.get('TOM_JOB_EXEC','') == "TEST":
    print("Job in TEST mode")
    print("[tsend] Job finished (TEST mode)")
    tsend("T", 0, "Job finished (TEST mode)")
    sys.exit(0)

stat_fin_job = run_tom_script(os.environ.get('TOM_SCRIPT',''), sys.argv)

print_banner("End of the script.")

if stat_fin_job == 0:
    print(f"--> Exit [{stat_fin_job}] then acknowledgment")
    print(f"[tsend] Job finished ({stat_fin_job})")
    tsend("T", stat_fin_job, f"Job finished ({stat_fin_job})")
else:
    print(f"--> Exit [{stat_fin_job}] then no acknowledgment")
    print(f"[tsend] Job in error ({stat_fin_job})")
    tsend("E", stat_fin_job, f"Job in error ({stat_fin_job})")

sys.exit(stat_fin_job)
```


```
bstat
queue_pythonlavraie                  0     30    0     -1
                 any              0     -1    0     -1
                 root             0     -1    0     -1
                 vtom             0     -1    0     -1
```

## Dans VTOM
queue vtom :  
![vtom_queue_pythonlavraie](/assets/img/vtom_queue_pythonlavraie.png "vtom_queue_pythonlavraie")  

Job 1 : ligne de commande python exemple : `print("bonjour")`  
![job1](/assets/img/job1.png "job1")  
![log_commande](/assets/img/log_commande.png "log_commande")  

Job 2 et son script : un script `bonjour.py`  
![job2](/assets/img/job2.png "job2")  
![job2_script](/assets/img/job2_script.png "job2_script")  
![log_script](/assets/img/log_script.png "log_script")  

Job 3 en script interne .py :  
![job3](/assets/img/job3.png "job3")  
![job3_script](/assets/img/job3_script.png "job3_script")  
![log_job3_script_interne](/assets/img/log_job3_script_interne.png "log_job3_script_interne")  

## Pour aller plus loin : Détails sur la mise en process 
Quand vous exécutez un job VTOM, le serveur ordonne à l'agent qui crée 3 fichiers dans `spool` :   
```
vtom@fe1641c13028:/opt/absyss/visual-tom/abm/spool$ ls
9  9.env  9.par

fichier 9
queue_name user IPID(ou job_id) PID uid gid TOM_JOB_ID TOM_SCRIPT queue_binaire

queue_pythonlavraie vtom 9 36937 1000 1000 2 print("bonjour") /usr/bin/python3

9.env 
les variables d'environnement envoyées par le serveur

TOM_JOB_ID=-2
TOM_JOB_RETRY=0
TOM_JOB_REMAIN_RETRY=1
TOM_JOB_MAX_RETRY=1
TOM_JOB_POINT=0
TOM_JOB_EXEC=NORMAL
TOM_REMOTE_SERVER=37c68610925d
TOM_ENVIRONMENT=Exploitation
TOM_APPLICATION=Application
TOM_JOB=Traitement_Python
TOM_DATE=date
TOM_DATE_VALUE=02/06/2025
TOM_USER=vtom
TOM_SCRIPT=print("bonjour")
TOM_FAMILY=
JOB_TYPE=AUTO
TOM_PERIODICITY=DAY
TOM_QUEUE=queue_pythonlavraie
TOM_HOST=agent
TOM_LOG_ACTION=
TOM_SCRIPT_ARGS=
TOM_RECOVERY_MODE=NO
TOM_LOGICAL_HOST=host
TOM_QUEUE_PRIORITY=5
TOM_PORT_tomDBd=30001
TOM_PORT_vtserver=30007
TOM_APP_COMMENT=
TOM_JOB_COMMENT=
TOM_ABMCONNECTTOSERVER=0

9.par
les paramètres du job (bon là je n'en ai point)
```

Ensuite, l'agent fork et exécute  
```
ps -eaf | grep vtom
-python3 /opt/absyss/visual-tom/admin/tom_submit.python3
```

(j'ai fait un agent DMZ connectToServer=0 pour être sûr)  
Une fois terminé, dans la queue, il y a un envoi de `tsend` qui créé un fichier .dmp :  
```
job_9.dmp
--- tsend ---
xid=-2
bid=9
env=Exploitation
app=Application
job=Traitement_Python
host=host
ret=0
mes=Job finished (0)
sta=TERMINE
end=02-06-125 12:28:24
```

 
