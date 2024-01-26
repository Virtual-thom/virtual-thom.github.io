---
layout: post
title: Wordpress API Tablepress retour JSON table
date: 2019-01-08 00:00:00
author: Virtual Thom
categories: [wordpress, api, php, tablepress]
---

But du jeu, récupérer la data d'un tableau créé avec TablePress (retour JSON et appel ajax)

!! Attention !! Vous devez savoir ce que vous faites quand on modifie un plugin et les hooks, on peut potentiellement ne plus avoir accès à son site wp.

<!--more-->

## Ajout dans plugins/tablepress/tablepress.php
```php
// Add API Route to ajax request on ShortCode table Id
function getTableJSON( $data ) {
  $table = TablePress::$model_table->load( $data['id'], true, true );
  return $table;
}
add_action( 'rest_api_init', function () {
  register_rest_route( 'tablepress/api/v1', '/table/(?P<id>\d+)', array(
    'methods' => 'GET',
    'callback' => 'getTableJSON',
  ) );
} );
```



## côté client ou requête

Ex curl en php 

```php
ini_set('max_execution_time', 300);
error_reporting(E_ALL);
ini_set("display_errors", 1);
ini_set('memory_limit', '512M');

# return content as json
header('Content-Type: application/json');

$HOST="monserveurWordpress";
$PORT="8080";

if(isset($_REQUEST["id"])){
  $Id=$_REQUEST["id"];
}else{
  http_response_code(400);
  echo json_encode(array("err" => "La clé id n'a pas été trouvée")) ;
  die() ;
}

function safe_json_encode($value, $options = 0, $depth = 512){
  $encoded = json_encode($value, $options, $depth);
  switch (json_last_error()) {
      case JSON_ERROR_NONE:
          return $encoded;
      case JSON_ERROR_DEPTH:
          return 'Maximum stack depth exceeded'; // or trigger_error() or throw new Exception()
      case JSON_ERROR_STATE_MISMATCH:
          return 'Underflow or the modes mismatch'; // or trigger_error() or throw new Exception()
      case JSON_ERROR_CTRL_CHAR:
          return 'Unexpected control character found';
      case JSON_ERROR_SYNTAX:
          return 'Syntax error, malformed JSON'; // or trigger_error() or throw new Exception()
      case JSON_ERROR_UTF8:
          $clean = utf8ize($value);
          return safe_json_encode($clean, $options, $depth);
      default:
          return 'Unknown error'; // or trigger_error() or throw new Exception()

  }
}

function utf8ize($mixed) {
  if (is_array($mixed)) {
      foreach ($mixed as $key => $value) {
          $mixed[$key] = utf8ize($value);
      }
  } else if (is_string ($mixed)) {
      return utf8_encode($mixed);
  }
  return $mixed;
}

// récupérer l'ip et les deux noms
$ch = curl_init() ;
curl_setopt($ch, CURLOPT_URL, $HOST.":".$PORT. "/wp-json/tablepress/api/v1/table/".$Id) ;
curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); 
curl_setopt($ch, CURLOPT_USERPWD, "user:mdp");
$result=json_decode(curl_exec ($ch));
$status_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);   //get status code

if($status_code != "200"){
    http_response_code(400);
    echo json_encode(
        array(
            "err" => "réponse KO",
            "data" => $result
            )
    ) ;
    die() ;
}

echo safe_json_encode($result) ;

curl_close ($ch);
?>
```

Références :

Excellentissime plugin Wordpress pour gestion et affichage de Tables / Tableaux dans Wordpress.
[Tablepress](https://github.com/TobiasBg/TablePress)

Excellentissime plugin pour une authentification Basic sur l'API wordpress.
[WP-API Basic-Auth](https://github.com/WP-API/Basic-Auth)

Très bonne doc officielle sur la REST API Wordpress et l'ajout des endpoints : [Add Endpoints REST API Wordpress](https://developer.wordpress.org/rest-api/extending-the-rest-api/adding-custom-endpoints/)
