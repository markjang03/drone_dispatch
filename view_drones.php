<?php
include 'db_connect.php';

$sql = "SELECT * FROM drone_traffic_control";
$result = $conn->query($sql);

echo "<h2>Drone Traffic Control</h2>";
if ($result->num_rows > 0) {
    echo "<table border='1'><tr><th>Drone Store</th><th>Drone Tag</th><th>Pilot</th><th>Weight Allowed</th><th>Current Weight</th><th>Deliveries Allowed</th><th>Deliveries in Progress</th></tr>";
    while ($row = $result->fetch_assoc()) {
        echo "<tr><td>" . $row["drone_serves_store"] . "</td><td>" . $row["drone_tag"] . "</td><td>" . $row["pilot"] . "</td><td>" . $row["total_weight_allowed"] . "</td><td>" . $row["current_weight"] . "</td><td>" . $row["deliveries_allowed"] . "</td><td>" . $row["deliveries_in_progress"] . "</td></tr>";
    }
    echo "</table>";
} else {
    echo "No drones found.";
}
$conn->close();
?>