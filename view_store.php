<?php
include 'db_connect.php';

$storeID = $_GET['storeID'];

$sql = "SELECT * FROM stores WHERE storeID = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $storeID);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo "<h1>Store Details</h1>";
    echo "Store ID: " . $row["storeID"] . "<br>";
    echo "Store Name: " . $row["sname"] . "<br>";
    echo "Revenue: " . $row["revenue"] . "<br>";
    echo "Manager: " . $row["manager"] . "<br>";
} else {
    echo "Store not found.";
}

$stmt->close();
$conn->close();
?>