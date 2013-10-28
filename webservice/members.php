<?php

/*
Our "config.inc.php" file connects to database every time we include or require
it within a php script.  Since we want this script to add a new user to our db,
we will be talking with our database, and therefore,
let's require the connection to happen:

The query structure is complicated. Make documentation in wili

LIMIT 0, 100




*/
require("config.inc.php");


if($_GET) {
//initial query
$query = "

SELECT 
		ow_base_user.id, 
		ow_base_user.username,
		
		ow_base_user.password, 
		ow_base_user.email,
		ow_base_user.joinStamp, 
		ow_base_avatar.hash,
		ow_base_component_entity_setting.value,
			max(case when questionName = 'sex' then ow_base_question_data.intValue end) as sex,
			max(case when questionName = 'realname' then ow_base_question_data.textValue end) as realname,
			max(case when questionName = 'birthdate' then ow_base_question_data.dateValue end) as birthdate
		
FROM 
	ow_base_user  
LEFT JOIN
     ow_base_avatar 
ON 
	ow_base_user.id = ow_base_avatar.userId

LEFT JOIN
	ow_base_component_entity_setting
ON
	ow_base_user.id = ow_base_component_entity_setting.entityId
	
LEFT JOIN
     ow_base_question_data 
ON 
	ow_base_user.id = ow_base_question_data.userId 
AND
     questionName in ('sex', 'birthdate', 'realname')


WHERE NOT EXISTS ( 
        SELECT *
        FROM ow_base_user_suspend 
        WHERE ow_base_user_suspend.userId = ow_base_user.id 
    )
    
AND NOT EXISTS ( 
        SELECT *
        FROM ow_base_user_block 
        WHERE ow_base_user_block.userId = ow_base_user.id 
    )
    
AND ow_base_user.username LIKE :search

    	
GROUP BY ow_base_user.username



";

$query_params = array(
    	':search' => $_GET['search'].'%'
        
    );

//execute query
try {
    $stmt   = $db->prepare($query);
    $result = $stmt->execute($query_params);
}
catch (PDOException $ex) {
    $response["success"] = 0;
    $response["message"] = "Database Error!";
    die(json_encode($response));
}



$member_count = 0;
while ($row = $stmt->fetch()) {
	
  $member_count = $member_count +1;
  $rows[] = $row;
};

if ($rows) {
    $response["success"] = 1;
    $response["message"] = "Post Available!";
    $response["count"] = $member_count;
    $response["posts"]   = array();
    
    foreach ($rows as $row) {
        $post             = array();
		$post["id"]  = $row["id"];
        $post["username"] = $row["username"];
        $post["realname"]    = $row["realname"];
        $post["email"]    = $row["email"];
        $post["avatar"] = OW_URL_IMAGE . '/ow_userfiles/plugins/base/avatars/avatar_'.$row['id'].'_'.$row['hash'].'.jpg';
        
        
        
        //update our repsonse JSON data
        array_push($response["posts"], $post);
    }
    
    // echoing JSON response
    echo json_encode($response);
    
    
} else {
    $response["success"] = 0;
    $response["message"] = "No Members was returned by the query!";
    die(json_encode($response));
}

} else {
	
echo "Nothing to see here";	
}

?>
