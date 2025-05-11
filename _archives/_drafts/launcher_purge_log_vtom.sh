#!/bin/bash
#######################################
# Description : Loop on vtmachine to purge log
# Depedencies : purge_log_vtom.ksh and jar (M.DODERO)
# Parameter : 1 . vtserver PORT (for vtmachine)
# Parameter : 2 . env/app/job (purge log job vtom)
# Parameter : 3 . host (host VTOM which is going to take the real IP of each host in vtmachine)
# Parameter : 4 . list of hosts to exclude of the purge (not mandatory) separate by a blank
#######################################
if test $# -lt 3;then
	echo "ERROR -- usage $0 <TOM_PORT_vtserver> <env/app/job> <host> [host_to_exclude[ hosts_to_exclude]...]"
	echo "# Parameter : 1 . vtserver PORT (for vtmachine)
# Parameter : 2 . env/app/job (purge log job vtom)
# Parameter : 3 . host (host VTOM which is going to take the real IP of each host in vtmachine)
# Parameter : 4 . list of hosts to exclude of the purge (not mandatory) separate by a blank"
	echo "Exit -> 123"
	exit 123
fi
# set TOM environment for vtmachine
export TOM_PORT_vtserver=$1

# settings variables
GLOBAL_USER_VTOM=${TOM_USER:-vtom}
GLOBAL_JAVA_MIN_VERSION=15
GLOBAL_LIST_SCRIPT_SOURCES=([0]="/tmp/${GLOBAL_USER_VTOM}/lib/*" [1]="/tmp/${GLOBAL_USER_VTOM}/shell/*")
GLOBAL_LIST_SCRIPT_REP_DEST=([0]="lib" [1]="shell")
GLOBAL_REP_SCRIPT_DEST_WIN="C:\\EXPLOITATION"
GLOBAL_REP_SCRIPT_DEST_LIN="/usr/vtom"
GLOBAL_SCRIPT_BASENAME="purge_log_vtom"
GLOBAL_SCRIPT_EXT_WIN=".cmd"
GLOBAL_SCRIPT_EXT_LIN=".ksh"
GLOBAL_SEPARATOR_LIN="/"
GLOBAL_SEPARATOR_WIN="\\"
GLOBAL_JOB_VTOM=$2
GLOBAL_JOB_VTOM_MACHINE=$3
GLOBAL_SERVER_NAME_VTOM=`uname -n`

shift 3
GLOBAL_LIST_HOSTS_TO_EXCLUDE=$@

echo "START -- "`date +"%D %T"`" $0 start"
# loop on vtmachine
while read this_line
do

# split this_line to variables
this_HOST=`echo $this_line | awk -F"|" '{sub(/^[ 	]+/,"",$3) ;sub(/[ 	]+$/,"",$3) ;print $3}'`
this_HOST_NAME=`echo $this_line | awk -F"|" '{sub(/^[ 	]+/,"",$2) ;sub(/[ 	]+$/,"",$2) ;print $2}'`
this_LAST_STATUS=`echo $this_line | awk -F"|" '{sub(/^[ 	]+/,"",$6) ;sub(/[ 	]+$/,"",$6) ;print $6}'`
this_OS=`echo $this_line | awk -F"|" '{sub(/^[ 	]+/,"",$7) ;sub(/[ 	]+$/,"",$7) ;print tolower($7)}'`

# Messages
vINFO="INFO -- $this_HOST_NAME : "
vWARNING="WARNING -- $this_HOST_NAME : "
vERROR="ERROR -- $this_HOST_NAME : "

# skip headers footers of vtmachine
if test "x${this_HOST}x" = "xx";then continue ; fi
if test "x${this_HOST}x" = "xLogical Namex";then continue ; fi
echo "$GLOBAL_LIST_HOSTS_TO_EXCLUDE" | grep $this_HOST_NAME > /dev/null
if test $? -eq 0;then echo $vINFO"$this_HOST_NAME is exclude of the purge" ; continue ; fi


# skip host not running
if test "$this_LAST_STATUS" != "Running";then
	echo $vWARNING"Last status of this host is not Running : $this_LAST_STATUS"
	continue
fi



if test "x${this_OS}x" = "xx";then echo "WARNING -- OS field is empty in vtmachine" ; continue ; fi
case ${this_OS} in
	lin*|aix*|hp*)
	echo $vINFO"This OS ${this_OS} is Unix"
	GLOBAL_REP_SCRIPT_DEST=$GLOBAL_REP_SCRIPT_DEST_LIN
	GLOBAL_SCRIPT_EXT=$GLOBAL_SCRIPT_EXT_LIN
	GLOBAL_SEPARATOR=$GLOBAL_SEPARATOR_LIN
	GLOBAL_JOB_VTOM_QUEUE="queue_ksh"
	;;
	win*)
	echo $vINFO"This OS ${this_OS} is Windows"
	GLOBAL_REP_SCRIPT_DEST=$GLOBAL_REP_SCRIPT_DEST_WIN
	GLOBAL_SCRIPT_EXT=$GLOBAL_SCRIPT_EXT_WIN
	GLOBAL_SEPARATOR=$GLOBAL_SEPARATOR_WIN
	GLOBAL_JOB_VTOM_QUEUE="queue_wnt"
	;;
	*)
	echo $vWARNING"This OS ${this_OS} is not supported"
	continue
	;;
esac

GLOBAL_SCRIPT_DEST=${GLOBAL_REP_SCRIPT_DEST}${GLOBAL_SEPARATOR}"shell"${GLOBAL_SEPARATOR}${GLOBAL_SCRIPT_BASENAME}${GLOBAL_SCRIPT_EXT}

# START : copy source files (sources are 10ko weight so copy every times to make sure it's up to date)
index=0
while [ "$index" -lt "${#GLOBAL_LIST_SCRIPT_SOURCES[@]}" ]
do
	export TOM_REMOTE_SERVER=$this_HOST
	vtcopy -i ${GLOBAL_LIST_SCRIPT_SOURCES[$index]} -o ${GLOBAL_REP_SCRIPT_DEST}${GLOBAL_SEPARATOR}${GLOBAL_LIST_SCRIPT_REP_DEST[$index]} 1>&2
	this_CR=$?
	index=`expr $index + 1`
	if test $this_CR -ne 0;then
		echo $vERROR"Couldn't copy source files"
		# continue 2 lvls so we leave the current loop of vtmachine
		continue 2
	fi
done
# END : copy source files

# START : Update, and treset purge job VTOM
export TOM_REMOTE_SERVER=$GLOBAL_SERVER_NAME_VTOM
set -x
vtaddmach /machine $GLOBAL_JOB_VTOM_MACHINE /nom_reel $this_HOST
if test $? -ne 0;then
	set -
	echo $vERROR"Could't update host VTOM : $GLOBAL_JOB_VTOM_MACHINE"
	continue 
fi
vtaddjob /nom=$GLOBAL_JOB_VTOM /script=$GLOBAL_SCRIPT_DEST /queue=$GLOBAL_JOB_VTOM_QUEUE /machine=$GLOBAL_JOB_VTOM_MACHINE
if test $? -ne 0;then
	set -
	echo $vERROR"Couldn't update job VTOM : $GLOBAL_JOB_VTOM"
	continue 
fi
set -
tresetJob -e `echo $GLOBAL_JOB_VTOM | cut -f1 -d"/"` -a `echo $GLOBAL_JOB_VTOM | cut -f2 -d"/"` -j `echo $GLOBAL_JOB_VTOM | cut -f3 -d"/"`
if test $? -ne 0;then
	echo $vERROR"Couldn't tresetJob job : $GLOBAL_JOB_VTOM"
	continue 
fi
# END : Update purge job VTOM

# START : Wait job VTOM ending before start on another loop on vtmachine
# max wait 30 min (purge log can be long)
this_DATE_START_WAIT=`date +"%s"`
this_MAX_WAIT=$(expr $this_DATE_START_WAIT + 1800)
while test `date +"%s"` -lt $this_MAX_WAIT
do
this_RESULT_TLIST_LAST_EXEC=`tlist jobs_last_exec -f $GLOBAL_JOB_VTOM`
if test $? -ne 0;then
	echo $vERROR"Couldn't get the last status : $GLOBAL_JOB_VTOM"
	continue 2
fi

echo $this_RESULT_TLIST_LAST_EXEC | grep TERMINE
if test $? -eq 0;then
	echo $vINFO"$GLOBAL_JOB_VTOM is OK"
	break
fi
sleep 2
done
echo $vINFO"$GLOBAL_JOB_VTOM duration (sec) : "$(expr `date +"%s"` - $this_DATE_START_WAIT)
# END : Wait job VTOM ending before start on another loop vtmachine

done < <(vtmachine)

export TOM_REMOTE_SERVER=$GLOBAL_SERVER_NAME_VTOM
echo "END -- "`date +"%D %T"`" $0 end"
exit 0
