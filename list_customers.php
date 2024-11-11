<?php
include 'db_connect.php';

// Fetch filter and sort options from query parameters
$uname = isset($_GET['uname']) ? $_GET['uname'] : '';
$rating = isset($_GET['rating']) ? $_GET['rating'] : '';
$sort_by = isset($_GET['sort_by']) ? $_GET['sort_by'] : 'uname';
$order = isset($_GET['order']) ? $_GET['order'] : 'ASC';

// Validate order and sort_by
$allowed_sort_by = ['uname', 'rating', 'credit'];
$allowed_order = ['ASC', 'DESC'];
if (!in_array($sort_by, $allowed_sort_by)) $sort_by = 'uname';
if (!in_array($order, $allowed_order)) $order = 'ASC';

// Build the SQL query with filtering and sorting
$sql = "SELECT * FROM customers WHERE 1=1";
$params = [];
$types = "";

if ($uname) {
    $sql .= " AND uname LIKE ?";
    $params[] = '%' . $uname . '%';
    $types .= "s";
}
if ($rating) {
    $sql .= " AND rating = ?";
    $params[] = $rating;
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
echo "<h2>Customer List</h2>";
if ($result->num_rows > 0) {
    echo "<table border='1'><tr><th>Username</th><th>Rating</th><th>Credit</th></tr>";
    while ($row = $result->fetch_assoc()) {
        echo "<tr><td>" . $row["uname"] . "</td><td>" . $row["rating"] . "</td><td>" . $row["credit"] . "</td></tr>";
    }
    echo "</table>";
} else {
    echo "No customers found.";
}

$stmt->close();
$conn->close();
?>