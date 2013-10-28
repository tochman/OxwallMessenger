<?php

//load and connect to MySQL database stuff
require("config.inc.php");

if (!empty($_POST)) {
	//initial query

	$query = "

REPLACE INTO  `ow_newsfeed_status` (  `id` ,  `feedType` ,  `feedId` ,  `timeStamp` ,  `status` )
VALUES ('',  'user', :userId, :timeStamp, 'Logged in with OxwallMessenger for iOS');

SET @last_status_id = (SELECT `id` FROM `ow_newsfeed_status` WHERE `feedId` = :userId AND `feedType` = 'user');

INSERT INTO `ow_newsfeed_action` (`id` , `entityId`, `entityType`, `pluginKey`, `data`)
VALUES('', @last_status_id, 'user-status', 'newsfeed', :data2 );

SET @last_entity_id = (SELECT MAX(`id`) FROM `ow_newsfeed_action` WHERE entityId = @last_status_id);

INSERT INTO `ow_newsfeed_activity`(`id`, `activityType`, `activityId`, `userId`, `data`, `actionId`, `timeStamp`, `privacy`, `visibility`, `status`) VALUES ('','subscribe',:userId, :userId,'\[\]',@last_entity_id,:timeStamp,'everybody','15','active');

INSERT INTO `ow_newsfeed_activity`(`id`, `activityType`, `activityId`, `userId`, `data`, `actionId`, `timeStamp`, `privacy`, `visibility`, `status`) VALUES ('','create',:userId, :userId,'\[\]',@last_entity_id,:timeStamp,'everybody','15','active');

SET @last_activity_id = (SELECT MAX(`id`) FROM `ow_newsfeed_activity` WHERE actionId = @last_entity_id);

INSERT INTO `ow_newsfeed_action_feed`(`id`, `feedType`, `feedId`, `activityId`) VALUES ('','user', :userId, @last_activity_id )



";

	//Update query
	$data = array(
		"string" => "Logged in with OxwallMessenger for iOS",
		"view" => "iconClass",
		"actionDto" => "null");

	$data2 = array(
		"content" => "<div class=\"ow_smallmargin ow_newsfeed_status_txt\">Logged in with <a href='http://tochman.github.io/OxwallMessenger'>OxwallMessenger</a> for iOS<br \/>\r\n</div> [ph:attachment]",
		"view" => array("iconClass" => "ow_ic_comment"),
		"attachment" => array("oembed" => "null", "url"=>"null", "attachId"=>"null"),
		"data" => array("userId"=>"".$_POST['userId']."", "status"=>"Logged in with <a href='http://tochman.github.io/OxwallMessenger'>OxwallMessenger</a> for iOS<br \/>\r\n"),
		"actionDto"=>"null"
	);
	$query_params = array(
		':userId' => $_POST['userId'],
		':timeStamp' => $_POST['timeStamp'],
		':data' => json_encode($data),
		':data2' => json_encode($data2)
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
		$response["message"] = "Database Error. Couldn't update newsfeed! "  . $ex->getMessage();
		die(json_encode($response));
	}

	// $row = $stmt->fetchAll();

	$response["success"] = 1;
	$response["message"] = "Newsfeed Successfully Updated!";
	echo json_encode($response);

} else {

	$date = date_create();
?>
		<h1>Add Conversation</h1>
		<form action="om_notify_login.php" method="post">

 timeStamp:<br /> 
		    <input type="text" name="timeStamp" placeholder="timeStamp" value="<?php echo $date->format('U'); ?>" /> 

		    userId:<br />
		    <input type="text" name="userId" placeholder="senderId" />

		    <input type="submit" value="Add Conversation" />
		</form>
	<?php
}

?>
                                                        