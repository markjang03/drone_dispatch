<?php
include 'db_connect.php';

$storeID = $_POST['storeID'];
$sname = $_POST['sname'];
$revenue = $_POST['revenue'];
$manager = $_POST['manager'];

$sql = "INSERT INTO stores (storeID, sname, revenue, manager) VALUES (?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssis", $storeID, $sname, $revenue, $manager);

if ($stmt->execute()) {
    echo "Store added successfully!";
} else {
    echo "Error: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>