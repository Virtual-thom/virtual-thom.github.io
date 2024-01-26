---
layout: post
title: Toutes les options du tengine
date: 2016-02-20 22:44
author: Virtual Thom
categories: [ordonnancement, vtom, astuce, vtom.ini, tengine]
---
Une astuce de Fred, simple mais efficace, pour connaitre toutes les options possibles (du vtom.ini) de votre tengine (moteur VTOM) quand on n'a pas la documentation sous la main.

```
strings $TOM_BIN/tengine 
```

Faites un grep sur le "= [" par exemple

```
$ strings $TOM_BIN/tengine | grep "= \["
GNSP                        = [%s]
useTz                       = [%d]
AcceptOrItems               = [%s]
AcceptAlphaStep             = [%s]
AdresseIP                   = [%s]
FQDNHostName                = [%s]
DateSystResetAll            = [%s]
AppCheckDateValue           = [%s]
JobCheckDateValue           = [%s]
JobBlockDateSyst            = [%s]
ManualRecovery              = [%s]
stats                       = [%s]
delaiWait                   = [%ds]
deplan_obj                  = [%s]
force_stats                 = [%s]
relanceAppCycliqueEnErreur  = [%s]
relanceJobCycliqueEnErreur  = [%s]
resnopla                    = [%s]
statusFailExist             = [%s]
statusFailSubmit            = [%s]
statusPileOne               = [%s]
statusPileAll               = [%s]
modeExecApp                 = [%s]
tagScript                   = [%s]
timeBexist                  = [%ds]
timeoutResGen               = [%ds]
nbJoursRattrapage           = [%d]
DelayHostVtSecure           = [%ds]
secureEngineTimeout         = [%ds]
blacklistCmd                = [%s]
useLinkBeforeEndTime        = [%d]
JobCheckAppConstraints      = [%d]
TRACE_FILE                  = [%s]
TRACE_FILE_COUNT            = [%d]
TRACE_FILE_SIZE             = [%dKo]
TRACE_LEVEL                 = [%d]
TRACE_SOURCE                = [%s]
TRACE_STDOUT                = [%s]
NbRetryDServerUnavailable           = [%d]
TimetoWaitRetryDServerUnavailable   = [%d]
appDisplayHeader            = [%s]
envDisplayHeader            = [%s]
tellClose                   = [%s]
tellDate                    = [%s]
tellFormat                  = [%s]
tellStatus                  = [%s]
- data..... array of %d %s = [
Next Cron     = [ %s (%d) ]
Next Cron     = [ none ]
```
