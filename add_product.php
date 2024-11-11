<?php
include 'db_connect.php';

$barcode = $_POST['barcode'];
$pname = $_POST['pname'];
$weight = $_POST['weight'];

$sql = "CALL add_product(?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssi", $barcode, $pname, $weight);

if ($stmt->execute()) {
    echo "Product added successfully!";
} else {
    echo "Error: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>