<?php
include 'db_connect.php';

// Fetch filter and sort options from query parameters
$storeID = isset($_GET['storeID']) ? $_GET['storeID'] : '';
$capacity = isset($_GET['capacity']) ? $_GET['capacity'] : '';
$sort_by = isset($_GET['sort_by']) ? $_GET['sort_by'] : 'storeID';
$order = isset($_GET['order']) ? $_GET['order'] : 'ASC';

// Validate order and sort_by
$allowed_sort_by = ['storeID', 'droneTag', 'capacity', 'remaining_trips'];
$allowed_order = ['ASC', 'DESC'];
if (!in_array($sort_by, $allowed_sort_by)) $sort_by = 'storeID';
if (!in_array($order, $allowed_order)) $order = 'ASC';

// Build the SQL query with filtering and sorting
$sql = "SELECT * FROM drones WHERE 1=1";
$params = [];
$types = "";

if ($storeID) {
    $sql .= " AND storeID LIKE ?";
    $params[] = '%' . $storeID . '%';
    $types .= "s";
}
if ($capacity) {
    $sql .= " AND capacity >= ?";
    $params[] = $capacity;
    $types .= "i";
}

$sql .= " ORDER BY $sort_by $order";

// Prepare and execute the statement
$stmt = $conn->prepare($sql);
if ($types) {
    $stmt->bind_param($types, ...$params);
}
$stmt->execute();
$result = $stmt->get_result();

// Display the results
echo "<h2>Drone List</h2>";
if ($result->num_rows > 0) {
    echo "<table border='1'><tr><th>Store ID</th><th>Drone Tag</th><th>Capacity</th><th>Remaining Trips</th><th>Pilot</th></tr>";
    while ($row = $result->fetch_assoc()) {
        echo "<tr><td>" . $row["storeID"] . "</td><td>" . $row["droneTag"] . "</td><td>" . $row["capacity"] . "</td><td>" . $row["remaining_trips"] . "</td><td>" . $row["pilot"] . "</td></tr>";
    }
    echo "</table>";
} else {
    echo "No drones found.";
}

$stmt->close();
$conn->close();
?>