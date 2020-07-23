<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$bookhotelid = $_POST['bookhotelid'];


if (isset($_POST['bookhotelid'])){
    $sqldelete = "DELETE FROM CART WHERE EMAIL = '$email' AND BHOTELID='$bookhotelid'";
}else{
    $sqldelete = "DELETE FROM CART WHERE EMAIL = '$email'";
}
    
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>