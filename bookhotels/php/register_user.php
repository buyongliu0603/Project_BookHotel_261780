<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);

$sqlinsert = "INSERT INTO USER(NAME,EMAIL,PASSWORD,PHONE,CREDIT,VERIFY) VALUES ('$name','$email','$password','$phone','0','0')";

if ($conn->query($sqlinsert) === true)
{
    sendEmail($email);
    echo "success";
    
}
else
{
    echo "failed";
}

//http://lintatt.com/bookhotels/php/register_user.php?name=lin&email=byongliu@gmail.com&phone=0182924786&password=123456789bu
function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for BookHotel'; 
    $message = 'http://lintatt.com/bookhotels/php/verify.php?email='.$useremail; 
    $headers = 'From: lintatt@bookhotels.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

?>
