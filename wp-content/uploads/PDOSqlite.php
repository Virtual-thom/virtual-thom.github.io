<?php

/*
extension=php_pdo.dll
[...]
extension=php_pdo_sqlite.dll
*/

class sqliteDb
{
  private $_pdo ;

  public function __construct($fileDb)
  {
    try{
      $this->_pdo = new PDO('sqlite:'.realpath($fileDb));
      $this->_pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
      $this->_pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_WARNING); // ERRMODE_WARNING | ERRMODE_EXCEPTION | ERRMODE_SILENT
    } catch(Exception $e) {
        echo "Impossible d'accéder à la base de données SQLite : " .$fileDb ;
        echo $e->getMessage();
        die();
    }
  }

  public function query($sql, $bindings){
    try{
    $stmt = $this->_pdo->prepare($sql);
    $stmt->execute($bindings);
    
    return  $stmt->fetchAll(PDO::FETCH_NUM);
    }
    catch (PDOException $e) {
      print $e->getMessage();
      return false;
    }
  }

}
?>