---
layout: post
title: Plugin wordpress add donater BTCPay server
date: 2022-10-05 12:00:00
author: Virtual Thom
---
J'ai écrit un plugin wordpress pour callback un webhook BTCPay Server.  
Suite à une invoice "Settled", en définissant un montant minimum, ça ajoute automatiquement les donateurs, ou on peut les gérer à la main aussi. Si on fournit un nom de donateur avec @ pour twitter, et qu'on a renseigné une api twitter dans les Settings du plugin, ça va chercher automatiquement l'image du profile.  

C'est ici :  
 * [{{ site.baseurl | prepend: site.url }}/vthom-don-btcpay-wordpress/]({{ site.baseurl | prepend: site.url }}/vthom-don-btcpay-wordpress/)
 * [https://github.com/Virtual-thom/vthom-don-btcpay-wordpress](https://github.com/Virtual-thom/vthom-don-btcpay-wordpress)