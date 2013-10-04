<?php

/*
Our "config.inc.php" file connects to database every time we include or require
it within a php script.  Since we want this script to add a new user to our db,
we will be talking with our database, and therefore,
let's require the connection to happen:
*/
require("config.inc.php");


if (isset($_GET['conversationId'])) {
//initial query
$query = "

SELECT 
viewed, 
initiatorId,
interlocutorId, 
subject, 
text,
timeStamp,
textValue AS realname, 
ow_mailbox_message.id AS message_id,
ow_mailbox_message.senderId  AS sentbyID


FROM ow_mailbox_conversation 

LEFT JOIN ow_mailbox_message

ON ow_mailbox_conversation.id = ow_mailbox_message.conversationId

LEFT JOIN
     ow_base_question_data 
ON 
	ow_base_question_data.userId = ow_mailbox_message.senderId  
AND
   	questionName = 'realname' 

WHERE conversationId = :conversationId

ORDER BY ow_mailbox_message.timeStamp ASC 




";


 
    $query_params = array(
    	':conversationId' => $_GET['conversationId']
        
        
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



//$head = $stmt->fetch();
// Finally, we can retrieve all of the found rows into an array using fetchAll 
//$rows = $stmt->fetchAll();


//$rows = mysql_fetch_array($stmt,MYSQL_NUM);
$message_count = 0;
while ($row = $stmt->fetch()) {
	
  $message_count = $message_count +1;
  $rows[] = $row;
};

if ($rows) {
    $response["success"] = 1;
    $response["message"] = "Messages exist!";
    $response["conversationId"] = $_GET['conversationId'];
    $response["countmessagesinconversation"] = $message_count;
    $response["messagesinconversation"]   = array();

    foreach ($rows as $row) {

        $post             = array();
        $post["messageid"]    = $row["message_id"];
		$post["messagecreated"]  = gmdate('F d, Y H:i', $row['timeStamp']);
		$post["sentbyID"] = $row["sentbyID"];
        $post["sentby"] = $row["realname"];
        $post["title"]    = $row["subject"];
        $post["message"]  = strip_tags($row["text"]);
        
        
        //update our repsonse JSON data
        array_push($response["messagesinconversation"], $post);
    }
    
    // echoing JSON response
    echo json_encode($response);

    
    
} else {
    $response["success"] = 0;
    $response["message"] = "No messages";
    die(json_encode($response));
}
} else {
echo "Nothing to see here";
}

?>
