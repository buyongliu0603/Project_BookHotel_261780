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
$path = '../images/'.$bhotelid.'.jpg';

$sqlupdate = "UPDATE HOTEL SET NAME ='$name', LOCATION = '$location', DESCRIPTION = '$description', BUDGET = '$budget', TOTALROOMS = '$quantity' WHERE ID = '$bhotelid'";
$sqlsearch = "SELECT * FROM HOTEL WHERE ID='$bhotelid'";
$resultsearch = $conn->query($sqlsearch);

if ($conn->query($sqlupdate) === true)
{
    if (isset($encode_string)){
        file_put_contents($path,$decoded_string);
    }
    echo "success";
}
else
{
    echo "failed";
}    

$conn->close();
?>