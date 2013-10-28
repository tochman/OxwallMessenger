<?php

//load and connect to MySQL database stuff
require("config.inc.php");

if (!empty($_POST)) {
	//initial query
	
	// We need the `` in this query becouse of the table `read` Not good practice by db-designer
	$query = "
	UPDATE ow_mailbox_conversation 
	SET `read` =
	CASE WHEN `read` < 3 THEN
	 `read` + 1
	ELSE `read`
	END
	WHERE `id` = :conversationId;

	UPDATE ow_mailbox_conversation
	SET `viewed` =
	CASE WHEN `viewed` < 3 THEN
	 `viewed` + 1
	ELSE `viewed`
	END
	WHERE `id` = :conversationId;	
	";

    //Update query
    $query_params = array(
    
        ':conversationId' => $_POST['conversationId']

    );
  
	//execute query
    try {
        $stmt   = $db->prepare($query);
        $result = $stmt->execute($query_params);
		
        
    }
    catch (PDOException $ex) {
        // For testing, you could use a die and message. 
        //die("Failed to run query: " . $ex->getMessage());
        
        //or just use this one:
        $response["success"] = 0;
        $response["message"] = "Database Error. Couldn't Modify conversation! "  . $ex->getMessage();
        die(json_encode($response));
    }
    
    // $row = $stmt->fetchAll();

    $response["success"] = 1;
    $response["message"] = "Conversation Successfully Modified!";
    
    echo json_encode($response);
   
} else {

$date = date_create();
?>
		<h1>Nothing to see here</h1> 
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
