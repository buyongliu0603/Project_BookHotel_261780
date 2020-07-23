<?php
error_reporting(0);
include_once ("dbconnect.php");
$bhotelid = $_POST['bhotelid'];
$name  = ucwords($_POST['name']);
$location = $_POST['location'];
$description  = $_POST['description'];
$budget  = $_POST['budget'];
$quantity  = $_POST['quantity'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$sold = '0';
$path = '../images/'.$bhotelid.'.jpg';

if (isset($_POST['bhotelid'])){
    $sqldelete = "DELETE FROM HOTEL WHERE ID ='$bhotelid'";
}else{
    
}
    
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>