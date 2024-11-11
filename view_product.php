<?php
include 'db_connect.php';

$barcode = $_GET['barcode'];

$sql = "SELECT * FROM products WHERE barcode = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $barcode);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo "<h1>Product Details</h1>";
    echo "Barcode: " . $row["barcode"] . "<br>";
    echo "Product Name: " . $row["pname"] . "<br>";
    echo "Weight: " . $row["weight"] . "<br>";
} else {
    echo "Product not found.";
}

$stmt->close();
$conn->close();
?>