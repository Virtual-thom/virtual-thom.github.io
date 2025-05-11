---
layout: post
title: Accéder à la base de données VTOM PostgreSQL
date: 2014-07-25 17:01
author: Virtual Thom
comments: true
categories: [node js, Ordonnancement, PHP, php, postgres, SQL, statistiques vtom, VTOM, VTOM PostgreSQL]
---
Vous savez sans doute que VTOM tend à basculer sa base de données en full PostgreSQL (maybe en version 6 ?). Quelques données y sont déjà, statistiques, historique, calendriers etc.

Pour l'instant, la base de données est "ouverte" et je vais vous montrer une manière de procéder pour accéder aux tables avec PHP. Vous pouvez tout aussi bien vous connecter à la base avec un utilitaire SQL du genre <a title="SQuirreL SQL client" href="http://squirrel-sql.sourceforge.net/">SQuirreL SQL client</a>.
<p>
ou encore avec le binaire psql de l'installation VTOM.
vtom@f8eeaf8b30a0:/mnt/User/temp$ ~/sgbd/bin/psql -d vtom -p 30009
</p>

**Attention ! Ne faites pas n'importe quoi sur votre base de Prod. Ce genre de manipulation n'est pas soutenu par Absyss.**

**Si vous avez des besoins, faites des demandes d'évolution à Absyss.**

Personnellement, je ne joue que sur mes serveurs de tests.

```
<?php
/*
  * à activer dans php.ini
  * extension=php_pdo.dll
  * extension=php_pdo_pgsql.dll
  *
*/
$host = 'localhost' ;
$user = 'vtom' ;
$db   = 'vtom' ;
$pass = 'vtom' ;
$port = '30009' ;
$dsn  = "pgsql:host=$host;dbname=$db;port=$port";
 
try {
                $dbh = new PDO( $dsn, $user, $pass );
} catch (PDOException $e) {
                die ( 'Erreur ! : ' . $e->getMessage() );
}
 
/*
  * list all tables
 
$sql = "SELECT table_schema,table_name
FROM information_schema.tables
ORDER BY table_schema,table_name;" ;
 
  * list all db
 
$sql = "SELECT datname FROM pg_database
WHERE datistemplate = false;" ;
 
*/

// exemple pour lister la table des stats (attention c'est gourmand en l'état, il faut bien sûr faire une requête plus spécifique) 
$sql = "select * from vt_stats_job ;" ;
 
$sth = $dbh->query( $sql ) ;
while ( $row = $sth->fetch(PDO::FETCH_ASSOC) ){
        print_r($row);
}
 
// close connection
if( $dbh ){
                $dbh = NULL ;
}
```

Mise à jour. C'est encore plus fun avec Node JS, lister les statistiques VTOM par exemple :

```

var pg = require('pg');
//var conString = "postgres://username:password@localhost/database";
var conString = "postgres://vtom:vtom@localhost:30009/vtom";

var client = new pg.Client(conString);

var query = 'SELECT * FROM vt_stats_job;' ;
// var query = 'SELECT * FROM vt_histo;' ;
// var query = 'SELECT * FROM pg_stat_all_tables;' ; // lister toutes les tables

client.connect(function(err) {
 if(err) {
  return console.error('could not connect to postgres', err);
 }
 client.query(query, function(err, result) {
  if(err) {
   client.end();
   return console.error('error running query', err);
  }
  //console.log(result.rows);
  result.rows.forEach(function(row){
   // console.log(row.relname); //pg_stat_all_tables
   console.log(row);
  });
  client.end();
 });
});
```
