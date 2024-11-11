<?php
include 'db_connect.php';

$storeID = $_POST['storeID'];

$sql = "DELETE FROM stores WHERE storeID = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $storeID);

if ($stmt->execute()) {
    echo "Store removed successfully!";
} else {
    echo "Error: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>