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

$sqlinsert = "INSERT INTO HOTEL(ID,NAME,LOCATION,DESCRIPTION,BUDGET,TOTALROOMS,SOLD) VALUES ('$bhotelid','$name','$location','$description','$budget','$quantity','$sold')";
$sqlsearch = "SELECT * FROM HOTEL WHERE ID='$bhotelid'";
$resultsearch = $conn->query($sqlsearch);
if ($resultsearch->num_rows > 0)
{
    echo 'found';
}else{
if ($conn->query($sqlinsert) === true)
{
    if (file_put_contents($path, $decoded_string)){
        echo 'success';
    }else{
        echo 'failed';
    }
}
else
{
    echo "failed";
}    
}


?>