<?php
include 'db_connect.php';

$uname = $_GET['uname'];

$sql = "SELECT * FROM drone_pilots WHERE uname = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $uname);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo "Username: " . $row["uname"] . "<br>";
    echo "License ID: " . $row["licenseID"] . "<br>";
    echo "Experience: " . $row["experience"] . "<br>";
} else {
    echo "No drone pilot found with that username.";
}

$stmt->close();
$conn->close();
?>