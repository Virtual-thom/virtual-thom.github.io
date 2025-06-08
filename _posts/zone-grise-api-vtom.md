---
layout: post
slug: Zone grise API VTOM
title: Zone grise API VTOM
---
Je m'étais juré de ne pas faire ça ... ne jamais dire (jamais) fontaine je ne boirai pas de ton eau.  

Vous connaissez sans doute les API officielles VTOM ?  
`https://votreserveurvtom:30002/swagger-ui` (ou port vtapiserver)  
[https://docs.absyss.com/vtom/721g/fr/Visual_TOM_Guide_Administrateur/?h=api#api-rest-securisees](https://docs.absyss.com/vtom/721g/fr/Visual_TOM_Guide_Administrateur/?h=api#api-rest-securisees)  
[/archives/api-rest-vtom-v6/](/archives/api-rest-vtom-v6/)  

En vérité, ce ne sont "que" les Visual TOM Public Domain API. 
C'est déjà énorme, on peut presque tout faire. Mais comme d'hab, j'ai des besoins louches.  

Bienvenue en zone grise : les API internes.  

Comme quasi tous les sites, F12 > network permet de voir ce qui se passe sous le capot. Le client web léger VTOM n'est pas différent.  
[!VTOM client leger F12 network](/assets/img/vtom_client_leger_F12_network.png)  

Mon but : parser tous les scripts de jobs VTOM pour vérifier un pattern (peu importe pourquoi).  
Avant, on pouvait faire ça avec le vthttpd mais il n'existe plus.  

```powershell
# Désactiver la vérification SSL (uniquement pour dev local avec certificat auto-signé)
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

# Corps de la requête, connexion avec un user mdp
$body = @{
    grant_type     = "password"
    username       = "TOM"
    password       = "TOMTOMTOM"
    tokenLifetime  = 3600
    tokenRefresh   = $true
} | ConvertTo-Json

# En-têtes HTTP
$headers = @{
    "content-type"       = "application/json"
}

# Appel de l'API
$account = Invoke-RestMethod -Uri "https://localhost:30002/vtom/public/auth/1.0/authorize" `
                             -Method Post `
                             -Headers $headers `
                             -Body $body `
                             -SkipCertificateCheck
# Corps JSON
# en fait c'est assez marrant, on n'a besoin que de l'env pour son path script par défaut (au cas où ça serait un path relatif dans le champ script)
# et le host / user, finalement le jobId n'a pas d'importance
# je pense que le mieux pour faire ça en masse, c'est de récupérer ces infos avec une requête SQL
# il faudra faire un UNIQ sur le nom du script / host probablement et récupérer l'envId et path
$body = @{
    envId     = "ENVac120004382ccdc8683d751a00000001"
    hostId     = "1"
    path       = "/opt/absyss/visual-tom/scripts/"
    script     = "#/var/lib/absyss/visual-tom/scripts/bonjour.py"
    userName   = "vtom"
} | ConvertTo-Json

# En-têtes
$headers = @{
    "content-type"       = "application/json"
    "x-api-key"          = $account.access_token
} 

# Requête POST
$response = Invoke-RestMethod -Uri "https://localhost:30002/vtom/private/jobs-monitoring/1.0/script" `
                              -Method Post `
                              -Headers $headers `
                              -Body $body `
                              -SkipCertificateCheck

# Affichage de la réponse
$response

# voilà j'ai bien le contenu de mon script bonjour.py
scriptContent     charSet    lastChange
-------------     -------    ----------
print("bonjour")… ISO-8859-1 @{date=2025/06/07 13:25:11}
```
