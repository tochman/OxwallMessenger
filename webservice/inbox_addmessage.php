<?php

//load and connect to MySQL database stuff
require("config.inc.php");

if (!empty($_POST)) {
	//initial query
	// This one is not that straight forward as adding a conversation. Here we must check who is the sender of the message to set the rigt flag in `read`, `viewed` & `deleted`.
	// `notificationSent` is just used to notuify the user in the webintercase so it has to be set to 0 every time there is a new message.

	$query = "START TRANSACTION;
	INSERT INTO ow_mailbox_message ( conversationId, timeStamp, senderId, recipientId, text ) VALUES ( :conversationId, :timeStamp, :senderId, :recipientId, :text );

UPDATE ow_mailbox_conversation
	SET

	 `read`=
(CASE
 WHEN
 `interlocutorId` = :senderId
 THEN
 2
 WHEN
 `initiatorId` = :senderId
 THEN
 1
 END),
 
 	 `viewed`=
(CASE
 WHEN
 `interlocutorId` = :senderId
 THEN
 2
 WHEN
 `initiatorId` = :senderId
 THEN
 1
 END),

     `deleted` = IF(`deleted` != '0', '0', '0') ,
     `notificationSent` = '0'
     
    
	 WHERE ow_mailbox_conversation.id = :conversationId;

SET @last_message_id = (SELECT id FROM ow_mailbox_last_message WHERE conversationId = :conversationId);

SELECT 
CASE 
WHEN  `interlocutorId` =  :senderId
THEN (

SELECT MAX( id ) 
FROM  `ow_mailbox_message` 
WHERE  `conversationId` =  :conversationId
AND  `senderId` =  :senderId
)
ELSE (

SELECT MAX( id ) 
FROM  `ow_mailbox_message` 
WHERE  `conversationId` =  :conversationId
AND  `recipientId` =  :senderId
)
END 
INTO @last_interlocutorMessageId 
FROM ow_mailbox_conversation
WHERE  `id` =  :conversationId;


SELECT 
CASE 
WHEN  `initiatorId` =  :senderId
THEN (

SELECT MAX( id ) 
FROM  `ow_mailbox_message` 
WHERE  `conversationId` =  :conversationId
AND  `senderId` =  :senderId
)
ELSE (

SELECT MAX( id ) 
FROM  `ow_mailbox_message` 
WHERE  `conversationId` =  :conversationId
AND  `recipientId` =  :senderId
)
END 
INTO @last_initiatorMessageId 
FROM ow_mailbox_conversation
WHERE  `id` =  :conversationId;

	 

    INSERT IGNORE INTO  ow_mailbox_last_message (  id ,  conversationId ,  initiatorMessageId ,  interlocutorMessageId ) 
    VALUES (@last_message_id, :conversationId, @last_initiatorMessageId, @last_interlocutorMessageId ) 
    ON DUPLICATE KEY UPDATE 
    id = @last_message_id,
    conversationId = :conversationId,
    initiatorMessageId = @last_initiatorMessageId,
    interlocutorMessageId = @last_interlocutorMessageId ;		
	
	
	COMMIT;	
	";

	//Update query
	$query_params = array(

		':conversationId' => $_POST['conversationId'],
		':timeStamp' => $_POST['timeStamp'],
		':senderId' => $_POST['senderId'],
		':recipientId' => $_POST['recipientId'],
		':text' => $_POST['text'] . "<br><span class='ow_tiny'> - sent with <a href='http://tochman.github.io/OxwallMessenger'>OxwallMessenger</a></span><br \/>\r\n"

	);

	//execute query
	try {
		$stmt   = $db->prepare($query);
		$result = $stmt->execute($query_params);
	}
	catch (PDOException $ex) {
		// For testing, you could use a die and message.
		//die("Failed to run query: " . $ex->getMessage());

		//or just use this use this one:
		$response["success"] = 0;
		$response["message"] = "Database Error. Couldn't send message!";
		die(json_encode($response));
	}

	$response["success"] = 1;
	$response["message"] = "Message Successfully Added!";
	echo json_encode($response);

} else {

	$date = date_create();
?>
		<h1>Add Comment</h1>
		<form action="inbox_addmessage.php" method="post">
			conversationId:<br />
		    <input type="text" name="conversationId" placeholder="conversationId" />
		    <br /><br />
		    timeStamp:<br />
		    <input type="text" name="timeStamp" placeholder="timeStamp" value="<?php echo $date->format('U'); ?>" />
		    senderId:<br />
		    <input type="text" name="senderId" placeholder="senderId" />
		    <br /><br />
		    recipientId:<br />
		    <input type="text" name="recipientId" placeholder="recipientId" />
		    <br /><br />
			Message:<br />
		    <input type="text" name="text" placeholder="text" />
		    <br /><br />
		    <input type="submit" value="Add Message" />
		</form>
	<?php
}

?>
