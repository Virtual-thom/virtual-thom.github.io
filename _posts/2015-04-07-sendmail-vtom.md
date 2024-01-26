---
layout: post
title: sendmail pour vtom
date: 2015-04-07 12:00:00
author: Virtual Thom
categories: [vtom, sendmail]
---
```bash
#!/bin/ksh
#On prend les 3 premiers arguments pour sujet, sender, dest
SUJET="$1"
shift
SENDER="$1"
shift
DEST="$1"
shift

# $@ ==> tous les autres arguments constitueront le body du message mail
(
cat << EOF
From: $SENDER 
To: $DEST
Subject: $SUJET
Content-Type: text/html
EOF
echo "<html><h1>$SUJET</h1><body>" 
while test $# -gt 0
do
  echo $1"<br>" 
  shift
done
echo "</body></html>"
) | sendmail -oi -t
```
