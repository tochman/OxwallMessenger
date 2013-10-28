<?php

//Hard-coded list of Messenger powered URL's

    $site1 = array(
    "site" => "Demosite", 
    "url" => "http://www.scalo.se",
    "assets_url" => "http://www.scalo.se");
    $site2 = array(
    "site" => "SecondDate", 
    "url" => "http://www.cloudshare.se",
    "assets_url" => "http://www.seconddate.se");
	
    $site3 = array(
    "site" => "YourSite", 
    "url" => "http://www.cloudshare.se",
    "assets_url" => "http://www.seconddate.se");
    
    $sites = array($site1, $site2, $site3);
    	$response["message"] = "Sites available";
        $response["sites"] = $sites;
        die(json_encode($response));
   


?> 
