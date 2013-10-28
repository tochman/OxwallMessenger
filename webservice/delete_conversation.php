<?php

//load and connect to MySQL database stuff
require("config.inc.php");

if (!empty($_POST)) {
	//initial query
	
	// We need the `` in this query becouse of the table `read` 
	$query = "
	UPDATE ow_mailbox_conversation 
	SET `deleted` =
	CASE WHEN `initiatorId` = :userId THEN
	 1
	ELSE 2
	END
	WHERE `id` = :conversationId;

		
	";

    //Update query
    $query_params = array(
    
        ':conversationId' => $_POST['conversationId'],
        ':userId' => $_POST['userId']
        

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
		<form action="delete_conversation.php" method="post"> 
			
		 	conversationId:<br /> 
		    <input type="text" name="conversationId" placeholder="conversationId" /> 
		    <br /><br /> 
		    userId:<br /> 
		    <input type="text" name="userId" placeholder="userId" /> 
		    <br /><br />
	
		    <input type="submit" value="Delete Conversation" /> 
		</form> 
	<?php
}

?> 
