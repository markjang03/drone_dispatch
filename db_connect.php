<?php
$host = 'localhost';
$user = 'root';
$password = ''; // Replace with your MySQL password
$dbname = 'drone_dispatch';

$conn = new mysqli($host, $user, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>