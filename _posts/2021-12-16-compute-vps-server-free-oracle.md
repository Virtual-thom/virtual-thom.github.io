---
layout: post
title: Serveur / VM Gratuit - compute free tier Oracle Cloud
date: 2021-12-16 12:00:00
author: Virtual Thom
categories: [hebergement web, compute, vps, server, cloud, gratuit]
---
Pour ceux qui cherchent du compute gratos mais correct, j'ai trouvé [par hasard](https://www.youtube.com/watch?v=g7sP33QtuxM&ab_channel=IdeaSpot) et testé la solution [free tier de chez Oracle Cloud](https://www.oracle.com/fr/cloud/free/#always-free).  
C'est vraiment bien, stable, puissant 4 Proc 24Go Mem, généreux 47Go Disk (mais à priori 2 volume block, au total 200Go). Seul bémol, c'est de l'arm64. M'enfin, couplé à une gestion DNS (chez moi [no-ip.com](https://www.noip.com/), dispose de sous-domaine gratos), c'est parfait pour héberger mon serveur de dev.  
J'ai testé aussi l'[aapnel](https://www.aapanel.com/reference.html) comme dans le [tuto](https://www.youtube.com/watch?v=g7sP33QtuxM&ab_channel=IdeaSpot). Pas mal, c'est pratique, ça évite pas mal de conf Apache et SSL Let's Encrypt (du moins c'est super simple par l'interface).  
Gros bémol aussi à l'heure où j'écris ces lignes : le package npm Parcel 2 ne fonctionne pas. Le build nécessite GLIBC 2.29 et l'OS oracle 8 linux ne dispoe que du GLIBC 2.28. Tester avec une image Ubuntu 20.04 ==> c'est ok :  

```
ubuntu@instance-xxxx:~/test$ npx parcel build index.html
✨ Built in 716ms
dist/index.html    7 B    258ms
```

J'ai aussi testé un serveur Express en nodeJS, ça fonctionne très bien.

Bon même si je n'y suis allé que pour le compute, le free tier propose aussi d'autres features gratuites à vie (bdd, APEX, etc) :  
![!Free Tier Oracle Cloud](/wp-content/uploads/free_tier_oracle_cloud.png)
