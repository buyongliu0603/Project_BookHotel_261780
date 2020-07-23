<?php
$servername = "localhost";
$username   = "lintattc_buyongliu";
$password   = "E)o81ZRj[E;t";
$dbname     = "lintattc_bookhotels";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>