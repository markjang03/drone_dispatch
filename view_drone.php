<?php
include 'db_connect.php';

$storeID = $_GET['storeID'];
$droneTag = $_GET['droneTag'];

$sql = "SELECT * FROM drones WHERE storeID = ? AND droneTag = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("si", $storeID, $droneTag);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo "Store ID: " . $row["storeID"] . "<br>";
    echo "Drone Tag: " . $row["droneTag"] . "<br>";
    echo "Capacity: " . $row["capacity"] . "<br>";
    echo "Remaining Trips: " . $row["remaining_trips"] . "<br>";
    echo "Pilot: " . $row["pilot"] . "<br>";
} else {
    echo "No drone found with that store ID and drone tag.";
}

$stmt->close();
$conn->close();
?>