---
layout: post
title: Bug queue_wnt de base Absyss
date: 2023-11-30 12:00:00
author: Virtual Thom
---
v7.1.1b5  
petit binz avec la queue_wnt de base de chez Absyss. J'ai des doubles quotes qui ne vont pas.  
Coup du sort, j'ai un compère porscheboxster77 qui a eu le même problème 2 jours avant moi.  
Ca fait des trucs du genre :  
```
Arguments: """TEST ESPACE"" "
ESPACE""=="" was unexpected at this time.
```

C'est pas grand chose, c'est leur loop args qui merdouille. On peut remplacer :  
```
:argloop
shift
if "%0"=="" goto argend
set arg=%arg% %0
goto argloop
:argend

call "%TOM_SCRIPT%" %arg%


en :
call "%TOM_SCRIPT%" %*
```

c'est assez drôle d'ailleurs, car ils fournissent une nouvelle queue à ma connaissance `submit_queue_wnt_space.bat` qui fait appel à une nouvelle variable TOM_ que je ne connaissais pas :  
```
rem :argloop
rem shift
rem if "%0"=="" goto argend
rem set arg=%arg% %0
rem goto argloop
rem :argend

rem call "%TOM_SCRIPT%" %arg%
call "%TOM_SCRIPT%" %TOM_SCRIPT_ARGS%
```

Comme quoi, on ne devait pas être les seuls ^^  
