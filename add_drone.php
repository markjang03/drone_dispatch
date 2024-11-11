<?php
include 'db_connect.php';

$storeID = $_POST['storeID'];
$droneTag = $_POST['droneTag'];
$capacity = $_POST['capacity'];
$remaining_trips = $_POST['remaining_trips'];
$pilot = $_POST['pilot'];

$sql = "CALL add_drone(?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("siiis", $storeID, $droneTag, $capacity, $remaining_trips, $pilot);

if ($stmt->execute()) {
    echo "Drone added successfully!";
} else {
    echo "Error: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>