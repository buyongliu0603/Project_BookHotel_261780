<?php
error_reporting(0);
include_once ("dbconnect.php");
$orderid = $_POST['orderid'];

$sql = "SELECT HOTEL.ID, HOTEL.NAME, HOTEL.BUDGET, HOTEL.TOTALROOMS, CARTHISTORY.CQUANTITY FROM HOTEL INNER JOIN CARTHISTORY ON CARTHISTORY.BHOTELID = HOTEL.ID WHERE  CARTHISTORY.ORDERID = '$orderid'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["carthistory"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["id"] = $row["ID"];
        $cartlist["name"] = $row["NAME"];
        $cartlist["budget"] = $row["BUDGET"];
        $cartlist["cquantity"] = $row["CQUANTITY"];
        array_push($response["carthistory"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";
}
?>
