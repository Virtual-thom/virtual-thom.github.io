---
layout: post
title: Envoyer un e-mail via telnet smtp port 25 en ligne de commande
date: 2012-09-20 17:34
author: Virtual Thom
comments: true
categories: [Cmd, commande, email, ligne de commande, mail, mèl, port 25, Script, script, smtp, smtp, telnet]
---
Vous voulez tester vos e-mails et/ou le serveur smtp (port 25 en général) 

<pre>
telnet @IP 25
MAIL From: <sender@gmail.fr>
RCPT To: <receiver@gmail.fr>
DATA
Subject: test catalogue
From: <sender@gmail.fr> "Mr Sender"
To: <receiver@gmail.fr> "Mr Receiver"
Test pour mail catalogue
[touche entrée]
.
[touche entrée]
</pre>
