---
layout: post
title: Checkboot Powershell
date: 2018-02-13 20:14
author: Virtual Thom
categories: [ps1, reboot, checkboot, powershell]
---

```powershell
write-host "Pour infomation, veuillez trouver ci-après les derniers reboots"
get-eventlog system | where-object {$_.eventid -eq 6005} | select-object TimeWritten,Message -first 10

$CR=0

$currentLoop = 0
$maxLoop = 10
$sleepLoop = 30
$lastRebootBool = $False
$tempMaxMin = 30
while($currentLoop -lt $maxLoop){
    try{
        $lastebootuptimeDate = Get-WmiObject win32_operatingsystem | ForEach-Object{$_.ConverttoDateTime($_.lastbootuptime)}
    }catch{
        throw "Erreur commande"
        exit 123
    }
    if(($lastebootuptimeDate) -gt ((get-date).addMinutes(-$tempMaxMin))){
        write-host "Le dernier démarrage date de moins de $tempMaxMin minutes"
        $lastRebootBool = $True
        break
    }
    write-host "[INFO]Last reboot $lastebootuptimeDate date de + de $tempMaxMin min. Loop n°$currentLoop MaxLoop $maxLoop toutes les $sleepLoop sec"
    start-sleep -Seconds $sleepLoop
    $currentLoop++
}

if(!$lastRebootBool){
    write-host "Le dernier démarrage date de plus de $tempMaxMin minutes"
    $CR=10
}
write-host "Le dernier démarrage date du : "$lastebootuptimeDate.ToString('dd-MM-yyy HH:mm')
write-host "Exit -> [$CR]"
exit $CR
```

Et en VBS pour les non-powershellien (vieux serveurs)

```vbs
strComputer = "." ' Local computer
lapsTimeInSec = (60 * 30) ' Temps en secondes, le reboot ne doit pas etre plus vieux que lapsTimeInSec

SET objWMIDateTime = CREATEOBJECT("WbemScripting.SWbemDateTime")
SET objWMI = GETOBJECT("winmgmts:\\" & strComputer & "\root\cimv2")
SET colOS = objWMI.InstancesOf("Win32_OperatingSystem")
FOR EACH objOS in colOS
	objWMIDateTime.Value = objOS.LastBootUpTime
	Wscript.Echo "Last Boot Up Time: " & objWMIDateTime.GetVarDate & vbcrlf & _
		"System Up Time: " &  TimeSpan(objWMIDateTime.GetVarDate,NOW) & _
		" (hh:mm:ss)"
  exitCode = TimeSpanMoreThan(objWMIDateTime.GetVarDate,NOW,lapsTimeInSec)
  IF (exitCode <> 0) THEN
    Wscript.Echo "Le dernier reboot date de plus de " & lapsTimeInSec & " sec : Exit " & exitCode 
  END IF
  WScript.Quit(exitCode)
NEXT

FUNCTION TimeSpan(dt1, dt2) 
	' Function to display the difference between
	' 2 dates in hh:mm:ss format
	IF (ISDATE(dt1) AND ISDATE(dt2)) = FALSE THEN 
		TimeSpan = "00:00:00" 
		EXIT FUNCTION 
  END IF 
 
  seconds = ABS(DATEDIFF("S", dt1, dt2)) 
  minutes = seconds \ 60 
  hours = minutes \ 60 
  minutes = minutes MOD 60 
  seconds = seconds MOD 60 

  IF LEN(hours) = 1 THEN hours = "0" & hours 

  TimeSpan = hours & ":" & _ 
      RIGHT("00" & minutes, 2) & ":" & _ 
      RIGHT("00" & seconds, 2) 
END FUNCTION

FUNCTION TimeSpanMoreThan(dt1, dt2,spanLaps) 
	' Function exit wrong if time between dt1 and dt1 is more than spanLaps (in sec)
	IF (ISDATE(dt1) AND ISDATE(dt2)) = FALSE THEN  
		EXIT FUNCTION 
  END IF
 
  seconds = ABS(DATEDIFF("S", dt1, dt2)) 
  IF (seconds > spanLaps) THEN
    TimeSpanMoreThan = 12
  ELSE
    TimeSpanMoreThan = 0
  END IF
END FUNCTION 
```
