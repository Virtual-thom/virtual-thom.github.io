---
layout: post
title: Service agent vtom dans /etc/init.d/ et chkconfig
date: 2014-07-28 17:13
author: Virtual Thom
comments: true
categories: [/etc/init.d, agent, Linux, Script, service, shell, Visual TOM, VTOM]
---
L'installation agent VTOM sur linux ne fournit pas de service dans /etc/init.d/ pour vérifier le statut, stopper ou démarrer l'agent. 
VTOM fournit en revanche les scripts permettant d'administrer l'agent (stop et start). 
Ce script agent_vtom (à copier coller dans /etc/init.d/agent_vtom en 755) permet de s'intégrer dans le chkconfig.

[agent_vtom](/scripts/agent_vtom)

```bash
#!/bin/ksh
#
# chkconfig: 345 90 20
# description: Agent VTOM.
#========================================================

USER_VTOM=vtom
if [ "$USER_VTOM" = "`whoami`" ]; then
  SUBMIT=""
elif [ "root" = "`whoami`" ]; then
  SUBMIT="su - $USER_VTOM -c "
else
  echo "Ce script doit etre lance en tant que root ou $USER_VTOM => sortie"
  exit 2
fi
TOM_HOME=${TOM_HOME:-/opt/vtom}
RETVAL=0

prog="Agent VTOM"

start(){
	status
        if test $RETVAL -eq 0; then
		echo "$prog déjà démarré"
		exit 0
	fi	

        echo -n "Démarrage $prog: "

        if test -z "$SUBMIT"; then
                        eval "${TOM_HOME}/admin/start_client &"
        else
                        $SUBMIT "${TOM_HOME}/admin/start_client &"
        fi

        limite=5
        cpt=0

        while test $cpt -lt $limite
        do
		status
                if test $RETVAL -eq 1; then
                        cpt=`expr $cpt + 1`
                else
                	echo -e "\nAgent VTOM \033[0;32mDEMARRé\E[0m\n"
			exit 0
                fi
                sleep 2
        done

	status
        if test $RETVAL -eq 1; then
                echo "Problème lors du démarrage $prog"
		exit 123
        fi
}

stop_vtom(){
	status
        if test $RETVAL -eq 1; then
		echo "$prog déjà arrêté"
		exit 0
	fi	
	
        echo -n "Arrêt $prog: "

        if test -z "$SUBMIT" ; then
                        eval "${TOM_HOME}/admin/stop_client &"
        else 
                        $SUBMIT "${TOM_HOME}/admin/stop_client &"
        fi

        limite=5
        cpt=0

        while test $cpt -lt $limite
        do
                status
                if test $RETVAL -eq 0; then
                        cpt=`expr $cpt + 1`
                else
                	echo -e "\nAgent VTOM \033[0;31mARRETé\E[0m\n"
			exit 0
                fi
                sleep 2
        done
	
	status
        if test $RETVAL -eq 0; then
                echo "Problème lors de l'arrêt $prog"
		exit 124
        fi

        }

status(){
        ps -ef|grep bdaemon|grep -v grep 1> /dev/null 2>&1
        if [ $? != 0 ] ; then
		echo -e "\n$prog : \033[0;31mOFF\E[0m\n"
		RETVAL=1
        else
                echo -e "\n$prog : \033[0;32mON\E[0m\n"
                RETVAL=0
        fi
}

restart(){
    stop_vtom
    start
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop_vtom
        ;;
    status)
        status
        ;;
    restart)
        restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart}"
        RETVAL=1
esac

exit $RETVAL
```

```bash
chkconfig --add agent_vtom
chkconfig agent_vtom on
```
Tapez `chkconfig --list` pour vérifier la prise en compte.

