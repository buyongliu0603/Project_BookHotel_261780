<?php
error_reporting(0);
include_once ("dbconnect.php");
$description = $_POST['description'];
$name = $_POST['name'];
$bhotelid = $_POST['bhotelid'];

if (isset($description)){
    if ($description == "Recent"){
        $sql = "SELECT * FROM HOTEL ORDER BY ID lIMIT 25";    
    }else{
        $sql = "SELECT * FROM HOTEL WHERE DESCRIPTION = '$description'";    
    }
}else{
    $sql = "SELECT * FROM HOTEL ORDER BY ID lIMIT 25";    
}
if (isset($name)){
   $sql = "SELECT * FROM HOTEL WHERE NAME LIKE  '%$name%'";
}

if (isset($bhotelid)){
   $sql = "SELECT * FROM HOTEL WHERE ID = '$bhotelid'";
}


$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["hotels"] = array();
    while ($row = $result->fetch_assoc())
    {
        $hotellist = array();
        $hotellist["id"] = $row["ID"];
        $hotellist["name"] = $row["NAME"];
        $hotellist["location"] = $row["LOCATION"];
        $hotellist["description"] = $row["DESCRIPTION"];
        $hotellist["budget"] = $row["BUDGET"];
        $hotellist["quantity"] = $row["TOTALROOMS"];
        $hotellist["date"] = $row["DATE"];
        $hotellist["sold"] = $row["SOLD"];
        array_push($response["hotels"], $hotellist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>