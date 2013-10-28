<?php

//load and connect to MySQL database stuff
require("config.inc.php");

if (!empty($_POST)) {
	//initial query
	
	// We need the `` in this query becouse of the table `read` Not good practice by db-designer
	$query = "
	
	INSERT INTO ow_mailbox_conversation 
	(`id`,
	`initiatorId` ,
	`interlocutorId` ,
	`subject` ,
	`read` ,
	`deleted` ,
	`viewed` ,
	`notificationSent` ,
	`createStamp`
	)	
	VALUES ('', :senderId, :recipientId, :subject, '1', '0', '1', '0', :timeStamp);
	
	
	";

    //Update query
    $query_params = array(
    
        //':conversationId' => $_POST['conversationId'],
        ':timeStamp' => $_POST['timeStamp'],
		':senderId' => $_POST['senderId'],
		':recipientId' => $_POST['recipientId'],
		':subject' => $_POST['subject'] 

    );
  
	//execute query
    try {
        $stmt   = $db->prepare($query);
        $result = $stmt->execute($query_params);
		$groupID = $db->lastInsertId('id');
        
    }
    catch (PDOException $ex) {
        // For testing, you could use a die and message. 
        //die("Failed to run query: " . $ex->getMessage());
        
        //or just use this one:
        $response["success"] = 0;
        $response["message"] = "Database Error. Couldn't create conversation! "  . $ex->getMessage();
        die(json_encode($response));
    }
    
    // $row = $stmt->fetchAll();

    $response["success"] = 1;
    $response["message"] = "Conversation Successfully Added!";
    $response["conversationId"] = $groupID;
    echo json_encode($response);
   
} else {

$date = date_create();
?>
		<h1>Add Conversation</h1> 
		<form action="inbox_addconversation.php" method="post"> 
			
		    timeStamp:<br /> 
		    <input type="text" name="timeStamp" placeholder="timeStamp" value="<?php echo $date->format('U'); ?>" /> 
		    senderId:<br /> 
		    <input type="text" name="senderId" placeholder="senderId" /> 
		    <br /><br /> 
		    recipientId:<br /> 
		    <input type="text" name="recipientId" placeholder="recipientId" /> 
		    <br /><br />
			Subject:<br /> 
		    <input type="text" name="subject" placeholder="text" /> 
		    <br /><br />
		    <input type="submit" value="Add Conversation" /> 
		</form> 
	<?php
}

?> 
