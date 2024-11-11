<?php
include 'db_connect.php';

$uname = $_POST['uname'];

$sql = "CALL remove_customer(?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $uname);

if ($stmt->execute()) {
    echo "Customer removed successfully!";
} else {
    echo "Error: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>