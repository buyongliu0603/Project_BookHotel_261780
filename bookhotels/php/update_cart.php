<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$bhotelid = $_POST['bhotelid'];
$quantity = $_POST['quantity'];

$sqlupdate = "UPDATE CART SET CQUANTITY = '$quantity' WHERE EMAIL = '$email' AND BHOTELID = '$bhotelid'";

if ($conn->query($sqlupdate) === true)
{
    echo "success";
}
else
{
    echo "failed";
}
    
$conn->close();
?>