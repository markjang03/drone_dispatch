<?php
include 'db_connect.php';

$barcode = $_POST['barcode'];

$sql = "DELETE FROM products WHERE barcode = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $barcode);

if ($stmt->execute()) {
    echo "Product removed successfully!";
} else {
    echo "Error: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>