<?php
include 'db_connect.php';

// Fetch filter and sort options from query parameters
$uname = isset($_GET['uname']) ? $_GET['uname'] : '';
$experience = isset($_GET['experience']) ? $_GET['experience'] : '';
$sort_by = isset($_GET['sort_by']) ? $_GET['sort_by'] : 'uname';
$order = isset($_GET['order']) ? $_GET['order'] : 'ASC';

// Validate order and sort_by
$allowed_sort_by = ['uname', 'licenseID', 'experience'];
$allowed_order = ['ASC', 'DESC'];
if (!in_array($sort_by, $allowed_sort_by)) $sort_by = 'uname';
if (!in_array($order, $allowed_order)) $order = 'ASC';

// Build the SQL query with filtering and sorting
$sql = "SELECT * FROM drone_pilots WHERE 1=1";
$params = [];
$types = "";

if ($uname) {
    $sql .= " AND uname LIKE ?";
    $params[] = '%' . $uname . '%';
    $types .= "s";
}
if ($experience) {
    $sql .= " AND experience = ?";
    $params[] = $experience;
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
echo "<h2>Drone Pilot List</h2>";
if ($result->num_rows > 0) {
    echo "<table border='1'><tr><th>Username</th><th>License ID</th><th>Experience</th></tr>";
    while ($row = $result->fetch_assoc()) {
        echo "<tr><td>" . $row["uname"] . "</td><td>" . $row["licenseID"] . "</td><td>" . $row["experience"] . "</td></tr>";
    }
    echo "</table>";
} else {
    echo "No drone pilots found.";
}

$stmt->close();
$conn->close();
?>