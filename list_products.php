<?php
include 'db_connect.php';

$order = isset($_GET['order']) ? $_GET['order'] : 'barcode';
$filter = isset($_GET['filter']) ? $_GET['filter'] : '';

$sql = "SELECT * FROM products WHERE pname LIKE ? ORDER BY $order";
$stmt = $conn->prepare($sql);
$filter_param = "%$filter%";
$stmt->bind_param("s", $filter_param);
$stmt->execute();
$result = $stmt->get_result();

echo "<form method='get'>";
echo "Filter by Product Name: <input type='text' name='filter' value='$filter'>";
echo "<input type='submit' value='Filter'>";
echo "</form>";

echo "<table border='1'><tr><th><a href='?order=barcode'>Barcode</a></th><th><a href='?order=pname'>Product Name</a></th><th><a href='?order=weight'>Weight</a></th></tr>";
while($row = $result->fetch_assoc()) {
    echo "<tr><td>" . $row["barcode"]. "</td><td>" . $row["pname"]. "</td><td>" . $row["weight"]. "</td></tr>";
}
echo "</table>";

$stmt->close();
$conn->close();
?>