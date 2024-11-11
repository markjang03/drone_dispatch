<?php
include 'db_connect.php';

$uname = $_GET['uname'];

$sql = "SELECT * FROM customers WHERE uname = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $uname);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo "Username: " . $row["uname"] . "<br>";
    echo "Rating: " . $row["rating"] . "<br>";
    echo "Credit: " . $row["credit"] . "<br>";
} else {
    echo "No customer found with that username.";
}

$stmt->close();
$conn->close();
?>