<?php
ini_set('max_execution_time', 300);
error_reporting(E_ALL);
ini_set("display_errors", 1);
ini_set('memory_limit', '512M');

# return content as json
header('Content-Type: application/json');

# Class de connexion sqlite
require_once('../PDOSqlite.php');

$sqliteDb = new sqliteDb("../vtomd.db") ;
//foreach($sqliteDb->query("SELECT * FROM JOBS WHERE Script like :script",array("script" => '%cmd')) as $row){
$sql = "
select j.JOB_SID, e.NAME, a.NAME, j.NAME, j.COMMENT, j.FAMILY, j.SCRIPT, h.NAME, u.NAME, q.NAME, d.NAME, GROUP_CONCAT(p.VALUE,'|')
from jobs j
left join applications a on j.APP_SID = a.APP_SID
left join environments e on a.ENV_SID = e.ENV_SID
left join hosts h on j.HOST_SID = h.HOST_SID or (ifnull(j.HOST_SID,'') = '' and ( a.HOST_SID = h.HOST_SID or (ifnull(a.HOST_SID,'') = '' and e.HOST_SID = h.HOST_SID) ) )
left join users u on j.USER_SID = u.USER_SID or (ifnull(j.USER_SID,'') = '' and ( a.USER_SID = u.USER_SID or (ifnull(a.USER_SID,'') = '' and e.USER_SID = u.USER_SID) ) )
left join queues q on j.QUEUE_SID = q.QUEUE_SID or (ifnull(j.QUEUE_SID,'') = '' and ( a.QUEUE_SID = q.QUEUE_SID or (ifnull(a.QUEUE_SID,'') = '' and e.QUEUE_SID = q.QUEUE_SID) ) )
left join dates d on j.DATE_SID = d.DATE_SID or (ifnull(j.DATE_SID,'') = '' and ( a.DATE_SID = d.DATE_SID or (ifnull(a.DATE_SID,'') = '' and e.DATE_SID = d.DATE_SID) ) )
left join job_parameters p on j.JOB_SID = p.JOB_SID
where j.script like :script and e.name = :vtenvname
group by j.JOB_SID
" ;
$bindings = array(
  "script" => '%tina_backup%',
  "vtenvname" => 'IAM'
);
foreach($sqliteDb->query($sql, $bindings) as $row){
  echo json_encode($row);
} 

?>