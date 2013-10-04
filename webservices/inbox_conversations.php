<?php

/*
Our "config.inc.php" file connects to database every time we include or require
it within a php script.  Since we want this script to add a new user to our db,
we will be talking with our database, and therefore,
let's require the connection to happen:
*/
require("config.inc.php");


if (isset($_GET['user'])) {
//initial query
$query = "

SELECT interlocutorId AS receiverID, initiatorId, subject, viewed, textValue AS realname, ow_mailbox_conversation.id AS conversation_id, ow_base_question_data.userId AS userID, ow_base_avatar.hash
FROM ow_mailbox_conversation
LEFT JOIN ow_base_question_data ON 
CASE WHEN initiatorId =  :user
THEN ow_base_question_data.userId = interlocutorId
AND questionName =  'realname'
ELSE ow_base_question_data.userId = initiatorId
AND questionName =  'realname'
END
LEFT JOIN ow_base_avatar ON 
CASE WHEN initiatorId =  :user
THEN interlocutorId = ow_base_avatar.userId
ELSE initiatorId = ow_base_avatar.userId
END 

WHERE interlocutorId = :user AND initiatorID != :user AND deleted != '2' OR interlocutorId != :user AND initiatorID = :user AND deleted != '1'

ORDER BY createStamp DESC;

";


 
    $query_params = array(
    	':user' => $_GET['user']

        
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



$conversation_count = 0;
while ($row = $stmt->fetch()) {
	
  $conversation_count = $conversation_count +1;
  
  $rows[] = $row;
};

if ($rows) {
    $response["success"] = 1;
    $response["message"] = "Conversations exist!";
    $response["conversationcount"] = $conversation_count;
    $response["conversations"]   = array();

    foreach ($rows as $row) {

        $post             = array();
        $post["conversationid"]    = $row["conversation_id"];
        $post["startedbyid"] = $row["userID"];
        $post["startedby"] = $row["realname"];
        $post["sentto"] = $row["receiverID"];
        if ($row['initiatorId']!=$_GET['user']) {
        $post["avatar"] = OW_URL_IMAGE . '/ow_userfiles/plugins/base/avatars/avatar_'.$row['initiatorId'].'_'.$row['hash'].'.jpg';
        } else {
        $post["avatar"] = OW_URL_IMAGE . '/ow_userfiles/plugins/base/avatars/avatar_'.$row['receiverID'].'_'.$row['hash'].'.jpg';
	        
        };
        $post["title"]  = $row["subject"];
        $post["messages"] = OW_URL_HOME . '/webservice/inbox_messages.php?conversationId='.$row["conversation_id"];
;
        
        
        //update our repsonse JSON data
        array_push($response["conversations"], $post);
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
