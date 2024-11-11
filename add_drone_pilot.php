<?php
include 'db_connect.php';

$uname = $_POST['uname'];
$first_name = $_POST['first_name'];
$last_name = $_POST['last_name'];
$address = $_POST['address'];
$birthdate = $_POST['birthdate'];
$taxID = $_POST['taxID'];
$service = $_POST['service'];
$salary = $_POST['salary'];
$licenseID = $_POST['licenseID'];
$experience = $_POST['experience'];

$sql = "CALL sp_add_drone_pilot(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
if ($stmt === false) {
    die("Prepare failed: " . htmlspecialchars($conn->error));
}
$stmt->bind_param("sssssisisi", $uname, $first_name, $last_name, $address, $birthdate, $taxID, $service, $salary, $licenseID, $experience);

if ($stmt->execute()) {
    echo "Drone Pilot added successfully!";
} else {
    // Log the detailed error and show a generic message
    error_log("Error in sp_add_drone_pilot: " . $stmt->error);
    echo "An error occurred while adding the Drone Pilot.";
}

$stmt->close();
$conn->close();
?>