---
layout: post
title: Redécouverte LUN sans redémarrer HP-UX
date: 2014-07-26 19:03
author: Virtual Thom
comments: true
categories: [HP-UX, SAN]
---
<pre lang="bash"> 
iosan -FnC
insf -e
powermt config
powermt save
powermt display dev=all
</pre>
