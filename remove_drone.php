<?php
include 'db_connect.php';

$storeID = $_POST['storeID'];
$droneTag = $_POST['droneTag'];

$sql = "CALL remove_drone(?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("si", $storeID, $droneTag);

if ($stmt->execute()) {
    echo "Drone removed successfully!";
} else {
    echo "Error: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>