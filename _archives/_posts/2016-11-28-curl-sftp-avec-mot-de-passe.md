---
layout: post
title: Curl sftp avec mot de passe
date: 2016-11-28 20:45
author: Virtual Thom
categories: [curl, shell, sftp, ftp, script, sftp avec mot de passe]
---
Je ne sais pas s'il existe une raison justifiant le fait de faire du sftp non sécurisé (mot de passe en clair, sans certificat SSL) mais des fois, il ne faut pas trop chercher à comprendre.

Donc sachez que si on vous dit, "plus de FTP, il faut faire du SFTP" et qu'on vous dit, "ah non, impossible de mettre en place des clés privées, publiques", vous pouvez scripter du sftp avec curl avec le user / mot de passe !

## Lister, afficher, récupérer

```
# la racine de connexion du user
curl -k -u user:mdp sftp://host

# un répertoire en particulier (ne pas oublier le dernier /)
curl -k -u user:mdp sftp://host/MyDir/

# affiche le contenu du fichier à l'écran
curl -k -u user:mdp sftp://host/monFichier

# récupérer un fichier 
curl -k -u user:mdp sftp://host/monFichier -o /monRep/monFichier
```

## les options intéressantes

```
-v                  | mode verbose, pratique pour debug
-u user:mdp         | pour l'authentification
sftp://@IP:port     | protocole peut être sftp, ftp, http par exemple
-Q "CMD dir/file"   | exécution de la commande sur le fichier (on part de la racine de connexion user)
-k ou --insecure    | (SSL) This option explicitly allows curl to perform "insecure" SSL connections and transfers
                    | problème résolu de "curl: (51) SSL peer certificate or SSH remote key was not OK"
-o dir/file         | redirige la sortie dans le fichier dir/file
```

## Quelques commandes FTP

```
# delete
curl -u user:mdp ftp://host -Q 'DELE MyDir/FileTodelete'
# rename
curl -u user:mdp ftp://host -Q 'RNFR MyDir/FileToRename' -Q 'RNTO MyDir/FileRenamed'
```

## Quelques commandes SFTP

```
# delete
curl -k -u user:mdp sftp://host -Q 'rm MyDir/FileTodelete'

# rename
curl -k -u user:mdp sftp://host -Q 'rename MyDir/FileToRename MyDir/FileRenamed'

# on peut cumuler la commande + le listage (attention, par défaut, la commande est effectuée avant)
# supprimer le rep' /var/tmp/MyDir et lister le contenu de /var/tmp/
curl -k -u user:mdp sftp://host/var/tmp/ -Q 'rmdir /var/tmp/MyDir'

man curl
 -Q, --quote <command>
  (FTP/SFTP)  Send  an arbitrary command to the remote FTP or SFTP server. Quote commands are sent BEFORE the transfer takes place (just
  after the initial PWD command in an FTP transfer, to be exact). To make commands take place after a successful transfer,  prefix  them
  with  a  dash '-'.  To make commands be sent after curl has changed the working directory, just before the transfer command(s), prefix
  the command with a '+' (this is only supported for FTP). You may specify any number of commands. If the server returns failure for one
  of  the  commands,  the  entire  operation will be aborted. You must send syntactically correct FTP commands as RFC 959 defines to FTP
  servers, or one of the commands listed below to SFTP servers.  This option can be used multiple times. When speaking to an FTP server,
  prefix the command with an asterisk (*) to make curl continue even if the command fails as by default curl will stop at first failure.

  SFTP  is  a binary protocol. Unlike for FTP, curl interprets SFTP quote commands itself before sending them to the server.  File names
  may be quoted shell-style to embed spaces or special characters.  Following is the list of all supported SFTP quote commands:

  chgrp group file
         The chgrp command sets the group ID of the file named by the file operand to the group ID specified by the group  operand.  The
         group operand is a decimal integer group ID.
  chmod mode file
         The chmod command modifies the file mode bits of the specified file. The mode operand is an octal integer mode number.
  chown user file
         The  chown  command sets the owner of the file named by the file operand to the user ID specified by the user operand. The user
         operand is a decimal integer user ID.
  ln source_file target_file
         The ln and symlink commands create a symbolic link at the target_file location pointing to the source_file location.

  mkdir directory_name
         The mkdir command creates the directory named by the directory_name operand.
  pwd    The pwd command returns the absolute pathname of the current working directory.
  rename source target
         The rename command renames the file or directory named by the source operand to the destination path named by the target  oper‐
         and.
  rm file
         The rm command removes the file specified by the file operand.
  rmdir directory
         The rmdir command removes the directory entry specified by the directory operand, provided it is empty.
  symlink source_file target_file
         See ln.

```

## Bug rencontré sur AIX

 * OpenSSL version mismatch. Built against 1000105f, you have 100000bf

Merci JM F. pour celle-là ;)

`export LIBPATH=:/usr/lib:$LIBPATH`

 * curl: (51) SSL peer certificate or SSH remote key was not OK

`-k ou --insecure`

## sinon curl c'est aussi ...

Sympa pour les API avec un retour JSON par exemple : [voir mon article sur le WebAccess]({{ site.url }}/api-vtom-web-access/)

et pour plein d'autres fonctionnalités sympa (comme récupérer les entêtes d'une requête HTML)
[client URL](https://fr.wikipedia.org/wiki/CURL)
