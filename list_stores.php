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

echo "<form method='get'>";
echo "Filter by Store Name: <input type='text' name='filter' value='$filter'>";
echo "<input type='submit' value='Filter'>";
echo "</form>";

echo "<table border='1'><tr><th><a href='?order=storeID'>Store ID</a></th><th><a href='?order=sname'>Store Name</a></th><th><a href='?order=revenue'>Revenue</a></th></tr>";
while($row = $result->fetch_assoc()) {
    echo "<tr><td>" . $row["storeID"]. "</td><td>" . $row["sname"]. "</td><td>" . $row["revenue"]. "</td></tr>";
}
echo "</table>";

$stmt->close();
$conn->close();
?>