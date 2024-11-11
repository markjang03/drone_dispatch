<?php
include 'db_connect.php';

$sql = "SELECT users.uname, first_name, last_name, address, birthdate, rating, credit FROM customers JOIN users ON customers.uname = users.uname";
$result = $conn->query($sql);

echo "<h2>Customers</h2>";
if ($result->num_rows > 0) {
    echo "<table border='1'><tr><th>Username</th><th>First Name</th><th>Last Name</th><th>Address</th><th>Birthdate</th><th>Rating</th><th>Credit</th></tr>";
    while ($row = $result->fetch_assoc()) {
        echo "<tr><td>" . $row["uname"] . "</td><td>" . $row["first_name"] . "</td><td>" . $row["last_name"] . "</td><td>" . $row["address"] . "</td><td>" . $row["birthdate"] . "</td><td>" . $row["rating"] . "</td><td>" . $row["credit"] . "</td></tr>";
    }
    echo "</table>";
} else {
    echo "No customers found.";
}
$conn->close();
?>