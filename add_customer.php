<?php
include 'db_connect.php';

// Optionally remove error display in production
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$uname = $_POST['uname'];
$first_name = $_POST['first_name'];
$last_name = $_POST['last_name'];
$address = $_POST['address'];
$birthdate = $_POST['birthdate'];
$rating = $_POST['rating'];
$credit = $_POST['credit'];

$sql = "CALL sp_add_customer(?, ?, ?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
if ($stmt === false) {
    die("Prepare failed: " . htmlspecialchars($conn->error));
}
$stmt->bind_param("sssssis", $uname, $first_name, $last_name, $address, $birthdate, $rating, $credit);

if ($stmt->execute()) {
    echo "Customer added successfully!";
} else {
    error_log("Error in sp_add_customer: " . $stmt->error);
    echo "An error occurred while adding the Customer.";
}

$stmt->close();
$conn->close();
?>