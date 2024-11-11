<?php
include 'db_connect.php';

$order = isset($_GET['order']) ? $_GET['order'] : 'storeID';
$filter = isset($_GET['filter']) ? $_GET['filter'] : '';

$sql = "SELECT * FROM stores WHERE sname LIKE ? ORDER BY $order";
$stmt = $conn->prepare($sql);
$filter_param = "%$filter%";
$stmt->bind_param("s", $filter_param);
$stmt->execute();
$result = $stmt->get_result();

echo "<h1>All Stores</h1>";
echo "<form method='get'>";
echo "Filter by Store Name: <input type='text' name='filter' value='$filter'>";
echo "<input type='submit' value='Filter'>";
echo "</form>";

echo "<table border='1'><tr><th>Store ID</th><th>Store Name</th><th>Revenue</th></tr>";
while($row = $result->fetch_assoc()) {
    echo "<tr><td>" . $row["storeID"] . "</td><td>" . $row["sname"] . "</td><td>" . $row["revenue"] . "</td></tr>";
}
echo "</table>";

$stmt->close();
$conn->close();
?>