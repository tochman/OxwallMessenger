<?php

//load and connect to MySQL database stuff
require("config.inc.php");



if($_GET)
/*  if (!empty($_POST))  */
{
    //gets user's info based off of a username.
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
    
WHERE 
	ow_base_user.id = :id 
	
GROUP BY ow_base_user.id;
        ";
        

    
    $query_params = array(
    	':id' => $_GET['user']
        //':username' => $_POST['username']
        
    );
    
    try {
        $stmt   = $db->prepare($query);
        $result = $stmt->execute($query_params);
    }
    catch (PDOException $ex) {
        // For testing, you could use a die and message. 
        //die("Failed to run query: " . $ex->getMessage());
        
        //or just use this use this one to product JSON data:
        $response["success"] = 0;
        $response["message"] = "Database Error1. Please Try Again!";
        die(json_encode($response));
        
    }
    
    //This will be the variable to determine whether or not the user's information is correct.
    //we initialize it as false.
    $validated_info = false;
    
    //fetching all the rows from the query
    $row = $stmt->fetch();
    $rows = $stmt->fetchAll();
    if ($row) {
        //we are checking the password after decryption. Secutiry issue with the SALT variable
        $salt = OW_PASSWORD_SALT;
        //$password = hash('sha256', $salt.$_GET['password']);
       $password = hash('sha256', $salt.$_POST['password']);

        if ($password === $row['password']) {
            $login_ok = true;
        }
        $login_ok = true;
    }
    $email = $row['email'];
    //there are two formats of avatar created by avatarService in Oxwall. Big and Small. We create links to both of them. Hardcoded in this version
    
    $avatar1 = OW_URL_IMAGE . '/ow_userfiles/plugins/base/avatars/avatar_big_'.$row['id'].'_'.$row['hash'].'.jpg';
    $avatar2 = OW_URL_IMAGE . '/ow_userfiles/plugins/base/avatars/avatar_'.$row['id'].'_'.$row['hash'].'.jpg';
    
    // get the realname from ow_base_question_data
    
    $realname = $row['realname'];
    
    // get the users sex from ow_base_question_data. What about couples????
    if ($row['sex'] = 1) {
	    $sex = "male";
    } else {
	    $sex = "female";
    };
    
    // get the brthdate from ow_base_question_data
    //$birth = $row['dateValue'];
    $birth = date('F d, Y', strtotime($row['birthdate']));
    
    // joinStamp är lite lustigt kodat
    //$joinStamp = CONVERT(VARCHAR(11),$row['joinStamp'],106)
    $joinStamp = gmdate('F d, Y', $row['joinStamp']);
    
    
    // call getAge to get the users age
    $age = get_age($birth, 'years');
    
    
    // If the user logged in successfully, then we send them to the private members-only page 
    // Otherwise, we display a login failed message and show the login form again 
    if ($login_ok) {
        $response["success"] = 1;
        $response["message"] = "Login successful!";
        $response["user"] = $row['username'];
        $response["realname"] = $realname;
        $response["email"] = $email;
        $response["member_since"] = $joinStamp;
        $response["sex"] = $sex;
        $response["birth"] = $birth;
        $response["age"] = $age;
        $response["big_avatar"] = $avatar1;
        $response["small_avatar"] = $avatar2;
        //$response["profiletext"] = $row['value'];
        
        die(json_encode($response));
    } else {
        $response["success"] = 0;
        $response["message"] = "Invalid Credentials!";
        die(json_encode($response));
    }
} else {
echo "Nothing to see here";
}

function get_age($date, $units='years')
{
    $modifier = date('n') - date('n', strtotime($date)) ? 1 : (date('j') - date('j', strtotime($date)) ? 1 : 0);
    $seconds = (time()-strtotime($date));
    $years = (date('Y')-date('Y', strtotime($date))-$modifier);
    switch($units)
    {
        
        case 'years':
        default:
            return $years;
    }
}

?> 
