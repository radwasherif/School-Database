<?php
	$servername = 'localhost'; 
	$dbusername = 'root'; 
	$dbpassword = '1tayswi3'; 
	$dbname = 'School_System'; 
	$conn = new mysqli($servername, $dbusername, $dbpassword, $dbname, "3306");
	if($conn->connect_errno) {
		die($conn->connect_errno); 
	} else {
		// echo "CONNECTED\n"; 
	}
?>