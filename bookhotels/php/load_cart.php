<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
   $sql = "SELECT HOTEL.ID, HOTEL.NAME, HOTEL.LOCATION, HOTEL.DESCRIPTION, HOTEL.BUDGET, HOTEL.TOTALROOMS, CART.CQUANTITY FROM HOTEL INNER JOIN CART ON CART.BHOTELID = HOTEL.ID WHERE CART.EMAIL = '$email'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["cart"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["id"] = $row["ID"];
        $cartlist["name"] = $row["NAME"];
        $cartlist["location"] = $row["LOCATION"];
        $cartlist["description"] = $row["DESCRIPTION"];
        $cartlist["budget"] = $row["BUDGET"];
        $cartlist["quantity"] = $row["TOTALROOMS"];
        $cartlist["cquantity"] = $row["CQUANTITY"];
        $cartlist["yourbudget"] = round(doubleval($row["BUDGET"])*(doubleval($row["CQUANTITY"])),2)."";
        array_push($response["cart"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";
}
?>