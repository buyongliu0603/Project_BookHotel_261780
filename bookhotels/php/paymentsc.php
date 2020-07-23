<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_POST['userid'];
$amount = $_POST['amount'];
$orderid = $_POST['orderid'];
$newcr = $_POST['newcr'];
$receiptid ="storecr";

 $sqlcart ="SELECT CART.BHOTELID, CART.CQUANTITY, HOTEL.BUDGET FROM CART INNER JOIN HOTEL ON CART.BHOTELID = HOTEL.ID WHERE CART.EMAIL = '$userid'";
        $cartresult = $conn->query($sqlcart);
        if ($cartresult->num_rows > 0)
        {
        while ($row = $cartresult->fetch_assoc())
        {
            $bhotelid = $row["BHOTELID"];
            $cq = $row["CQUANTITY"]; //cart qty
            $pr = $row["BUDGET"];
            $sqlinsertcarthistory = "INSERT INTO CARTHISTORY(EMAIL,ORDERID,BILLID,PRODID,CQUANTITY,BUDGET) VALUES ('$userid','$orderid','$receiptid','$bhotelid','$cq','$pr')";
            $conn->query($sqlinsertcarthistory);
            
            $selectproduct = "SELECT * FROM HOTEL WHERE ID = '$bhotelid'";
            $productresult = $conn->query($selectproduct);
             if ($productresult->num_rows > 0){
                  while ($rowp = $productresult->fetch_assoc()){
                    $prquantity = $rowp["QUANTITY"];
                    $prevsold = $rowp["SOLD"];
                    $newquantity = $prquantity - $cq; //quantity in store - quantity ordered by user
                    $newsold = $prevsold + $cq;
                    $sqlupdatequantity = "UPDATE HOTEL SET QUANTITY = '$newquantity', SOLD = '$newsold' WHERE ID = '$bhotelid'";
                    $conn->query($sqlupdatequantity);
                  }
             }
        }
        
       $sqldeletecart = "DELETE FROM CART WHERE EMAIL = '$userid'";
       $sqlinsert = "INSERT INTO PAYMENT(ORDERID,BILLID,USERID,TOTAL) VALUES ('$orderid','$receiptid','$userid','$amount')";
        $sqlupdatecredit = "UPDATE USER SET CREDIT = '$newcr' WHERE EMAIL = '$userid'";
        
       $conn->query($sqldeletecart);
       $conn->query($sqlinsert);
       $conn->query($sqlupdatecredit);
       echo "success";
        }else{
            echo "failed";
        }

?>