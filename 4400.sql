/*team 44*/

/* Check MySQL version */
SELECT VERSION() AS MySQL_Version;

/* Adjust the transaction isolation level based on MySQL version */
SET @MySQL_Version := SUBSTRING_INDEX(VERSION(), '.', 2);

IF @MySQL_Version >= '5.7' THEN
    SET SESSION transaction_isolation = 'SERIALIZABLE';
ELSE
    SET SESSION tx_isolation = 'SERIALIZABLE';
END IF;

/* Configure SQL modes */
SET SESSION sql_mode = 'ANSI,TRADITIONAL';

/* Set character encoding */
SET NAMES utf8mb4;

/* Disable safe updates */
SET SQL_SAFE_UPDATES = 0;

/* Define the database name */
SET @thisDatabase = 'drone_dispatch';

/* Drop and recreate the database to ensure a fresh setup */
DROP DATABASE IF EXISTS drone_dispatch;
CREATE DATABASE drone_dispatch;
USE drone_dispatch;-----------------------
-- Table Structures
-- -----------------------------------------------

-- Users table stores basic user information
CREATE TABLE users (
    uname VARCHAR(40) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    address VARCHAR(500) NOT NULL,
    birthdate DATE DEFAULT NULL,
    PRIMARY KEY (uname)
) ENGINE=InnoDB;

-- Customers table extends users with customer-specific attributes
CREATE TABLE customers (
    uname VARCHAR(40) NOT NULL,
    rating INTEGER NOT NULL,
    credit INTEGER NOT NULL,
    PRIMARY KEY (uname),
    FOREIGN KEY (uname) REFERENCES users(uname)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- Employees table extends users with employee-specific attributes
CREATE TABLE employees (
    uname VARCHAR(40) NOT NULL,
    taxID VARCHAR(40) NOT NULL,
    service INTEGER NOT NULL,
    salary INTEGER NOT NULL,
    PRIMARY KEY (uname),
    UNIQUE KEY (taxID),
    FOREIGN KEY (uname) REFERENCES users(uname)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- Drone Pilots table stores pilot-specific information
CREATE TABLE drone_pilots (
    uname VARCHAR(40) NOT NULL,
    licenseID VARCHAR(40) NOT NULL,
    experience INTEGER NOT NULL,
    PRIMARY KEY (uname),
    UNIQUE KEY (licenseID),
    FOREIGN KEY (uname) REFERENCES employees(uname)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- Store Workers table identifies employees who manage stores
CREATE TABLE store_workers (
    uname VARCHAR(40) NOT NULL,
    PRIMARY KEY (uname),
    FOREIGN KEY (uname) REFERENCES employees(uname)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- Products table catalogs available products
CREATE TABLE products (
    barcode VARCHAR(40) NOT NULL,
    pname VARCHAR(100) NOT NULL,
    weight INTEGER NOT NULL,
    PRIMARY KEY (barcode)
) ENGINE=InnoDB;

-- Stores table contains store-specific information
CREATE TABLE stores (
    storeID VARCHAR(40) NOT NULL,
    sname VARCHAR(100) NOT NULL,
    revenue INTEGER NOT NULL DEFAULT 0,
    manager VARCHAR(40) NOT NULL,
    PRIMARY KEY (storeID),
    FOREIGN KEY (manager) REFERENCES store_workers(uname)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Drones table tracks drone details and assignments
CREATE TABLE drones (
    storeID VARCHAR(40) NOT NULL,
    droneTag INTEGER NOT NULL,
    capacity INTEGER NOT NULL,
    remaining_trips INTEGER NOT NULL,
    pilot VARCHAR(40) NOT NULL,
    PRIMARY KEY (storeID, droneTag),
    FOREIGN KEY (storeID) REFERENCES stores(storeID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (pilot) REFERENCES drone_pilots(uname)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Orders table records customer orders
CREATE TABLE orders (
    orderID VARCHAR(40) NOT NULL,
    sold_on DATE NOT NULL,
    purchased_by VARCHAR(40) NOT NULL,
    carrier_store VARCHAR(40) NOT NULL,
    carrier_tag INTEGER NOT NULL,
    PRIMARY KEY (orderID),
    FOREIGN KEY (purchased_by) REFERENCES customers(uname)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (carrier_store, carrier_tag) REFERENCES drones(storeID, droneTag)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Order Lines table details products within each order
CREATE TABLE order_lines (
    orderID VARCHAR(40) NOT NULL,
    barcode VARCHAR(40) NOT NULL,
    price INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    PRIMARY KEY (orderID, barcode),
    FOREIGN KEY (orderID) REFERENCES orders(orderID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (barcode) REFERENCES products(barcode)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Employed Workers table links employees to stores
CREATE TABLE employed_workers (
    storeID VARCHAR(40) NOT NULL,
    uname VARCHAR(40) NOT NULL,
    PRIMARY KEY (storeID, uname),
    FOREIGN KEY (storeID) REFERENCES stores(storeID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (uname) REFERENCES store_workers(uname)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------
-- Table Data
-- -----------------------------------------------

-- Insert data into users
INSERT INTO users (uname, first_name, last_name, address, birthdate) VALUES
('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19'),
('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
('agarcia7', 'Alejandro', 'Garcia', '710 Living Water Drive', '1966-10-29'),
('bsummers4', 'Brie', 'Summers', '5105 Dragon Star Circle', '1976-02-09'),
('cjordan5', 'Clark', 'Jordan', '77 Infinite Stars Road', '1966-06-05'),
('fprefontaine6', 'Ford', 'Prefontaine', '10 Hitch Hikers Lane', '1961-01-28');

-- Insert data into customers
INSERT INTO customers (uname, rating, credit) VALUES
('jstone5', 4, 40),
('sprince6', 5, 30),
('awilson5', 2, 100),
('lrodriguez5', 4, 60),
('bsummers4', 3, 110),
('cjordan5', 3, 50);

-- Insert data into employees
INSERT INTO employees (uname, taxID, service, salary) VALUES
('awilson5', '111-11-1111', 9, 46000),
('lrodriguez5', '222-22-2222', 20, 58000),
('tmccall5', '333-33-3333', 29, 33000),
('eross10', '444-44-4444', 10, 61000),
('hstark16', '555-55-5555', 20, 59000),
('echarles19', '777-77-7777', 3, 27000),
('csoares8', '888-88-8888', 26, 57000),
('agarcia7', '999-99-9999', 24, 41000),
('bsummers4', '000-00-0000', 17, 35000),
('fprefontaine6', '121-21-2121', 5, 20000);

-- Insert data into store_workers
INSERT INTO store_workers (uname) VALUES
('eross10'),
('hstark16'),
('echarles19');

-- Insert data into stores
INSERT INTO stores (storeID, sname, revenue, manager) VALUES
('pub', 'Publix', 200, 'hstark16'),
('krg', 'Kroger', 300, 'echarles19');

-- Insert data into employed_workers
INSERT INTO employed_workers (storeID, uname) VALUES
('pub', 'eross10'),
('pub', 'hstark16'),
('krg', 'eross10'),
('krg', 'echarles19');

-- Insert data into drone_pilots
INSERT INTO drone_pilots (uname, licenseID, experience) VALUES
('awilson5', '314159', 41),
('lrodriguez5', '287182', 67),
('tmccall5', '181633', 10),
('agarcia7', '610623', 38),
('bsummers4', '411911', 35),
('fprefontaine6', '657483', 2);

-- Insert data into drones
INSERT INTO drones (storeID, droneTag, capacity, remaining_trips, pilot) VALUES
('pub', 1, 10, 3, 'awilson5'),
('pub', 2, 20, 2, 'lrodriguez5'),
('krg', 1, 15, 4, 'tmccall5'),
('pub', 9, 45, 1, 'fprefontaine6');

-- Insert data into products
INSERT INTO products (barcode, pname, weight) VALUES
('pr_3C6A9R', 'pot roast', 6),
('ss_2D4E6L', 'shrimp salad', 3),
('hs_5E7L23M', 'hoagie sandwich', 3),
('clc_4T9U25X', 'chocolate lava cake', 5),
('ap_9T25E36L', 'antipasto platter', 4);

-- Insert data into orders
INSERT INTO orders (orderID, sold_on, purchased_by, carrier_store, carrier_tag) VALUES
('pub_303', '2024-05-23', 'sprince6', 'pub', 1),
('pub_305', '2024-05-22', 'sprince6', 'pub', 2),
('krg_217', '2024-05-23', 'jstone5', 'krg', 1),
('pub_306', '2024-05-22', 'awilson5', 'pub', 2);

-- Insert data into order_lines
INSERT INTO order_lines (orderID, barcode, price, quantity) VALUES
('pub_303', 'pr_3C6A9R', 20, 1),
('pub_303', 'ap_9T25E36L', 4, 1),
('pub_305', 'clc_4T9U25X', 3, 2),
('pub_306', 'hs_5E7L23M', 3, 2),
('pub_306', 'ap_9T25E36L', 10, 1),
('krg_217', 'pr_3C6A9R', 15, 2);

-- -----------------------------------------------
-- Stored Procedures and Views
-- -----------------------------------------------

-- Add Customer
DELIMITER //
CREATE PROCEDURE sp_add_customer (
    IN ip_uname VARCHAR(40),
    IN ip_first_name VARCHAR(100),
    IN ip_last_name VARCHAR(100),
    IN ip_address VARCHAR(500),
    IN ip_birthdate DATE,
    IN ip_rating INTEGER,
    IN ip_credit INTEGER
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed in sp_add_customer';
    END;

    START TRANSACTION;

    -- Validate input parameters
    IF ip_uname IS NULL OR ip_first_name IS NULL OR ip_last_name IS NULL OR
       ip_address IS NULL OR ip_rating IS NULL OR ip_credit IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'All input parameters must be provided';
    END IF;

    -- Check if user already exists
    IF NOT EXISTS (SELECT 1 FROM users WHERE uname = ip_uname)
       AND NOT EXISTS (SELECT 1 FROM customers WHERE uname = ip_uname) THEN
        INSERT INTO users (uname, first_name, last_name, address, birthdate)
            VALUES (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
        INSERT INTO customers (uname, rating, credit)
            VALUES (ip_uname, ip_rating, ip_credit);
    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User already exists';
    END IF;

    COMMIT;
END //
DELIMITER ;

-- Add Drone Pilot
DELIMITER //
CREATE PROCEDURE sp_add_drone_pilot (
    IN ip_uname VARCHAR(40),
    IN ip_first_name VARCHAR(100),
    IN ip_last_name VARCHAR(100),
    IN ip_address VARCHAR(500),
    IN ip_birthdate DATE,
    IN ip_taxID VARCHAR(40),
    IN ip_service INTEGER,
    IN ip_salary INTEGER,
    IN ip_licenseID VARCHAR(40),
    IN ip_experience INTEGER
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed in sp_add_drone_pilot';
    END;

    START TRANSACTION;

    -- Validate input parameters
    IF ip_uname IS NULL OR ip_first_name IS NULL OR ip_last_name IS NULL OR
       ip_address IS NULL OR ip_taxID IS NULL OR ip_service IS NULL OR
       ip_salary IS NULL OR ip_licenseID IS NULL OR ip_experience IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'All input parameters must be provided';
    END IF;

    -- Validate Tax ID format
    IF ip_taxID NOT REGEXP '^[0-9]{3}-[0-9]{2}-[0-9]{4}$' THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid Tax ID format';
    END IF;

    -- Check for existing user, drone pilot, employee, and license ID
    IF EXISTS (SELECT 1 FROM users WHERE uname = ip_uname) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username already exists in users';
    END IF;

    IF EXISTS (SELECT 1 FROM drone_pilots WHERE uname = ip_uname) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username already exists in drone_pilots';
    END IF;

    IF EXISTS (SELECT 1 FROM employees WHERE taxID = ip_taxID) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tax ID already exists in employees';
    END IF;

    IF EXISTS (SELECT 1 FROM drone_pilots WHERE licenseID = ip_licenseID) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'License ID already exists in drone_pilots';
    END IF;

    -- Insert into users
    INSERT INTO users (uname, first_name, last_name, address, birthdate)
        VALUES (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);

    -- Insert into employees
    INSERT INTO employees (uname, taxID, service, salary)
        VALUES (ip_uname, ip_taxID, ip_service, ip_salary);

    -- Insert into drone_pilots
    INSERT INTO drone_pilots (uname, licenseID, experience)
        VALUES (ip_uname, ip_licenseID, ip_experience);

    COMMIT;
END //
DELIMITER ;

-- Add Product
DELIMITER //
CREATE PROCEDURE sp_add_product (
    IN ip_barcode VARCHAR(40),
    IN ip_pname VARCHAR(100),
    IN ip_weight INTEGER
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed in sp_add_product';
    END;

    START TRANSACTION;

    -- Validate input parameters
    IF ip_barcode IS NULL OR ip_pname IS NULL OR ip_weight IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'All input parameters must be provided';
    END IF;

    -- Check if product already exists
    IF NOT EXISTS (SELECT 1 FROM products WHERE barcode = ip_barcode) THEN
        INSERT INTO products (barcode, pname, weight)
            VALUES (ip_barcode, ip_pname, ip_weight);
    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product already exists';
    END IF;

    COMMIT;
END //
DELIMITER ;

-- Add Drone
DELIMITER //
CREATE PROCEDURE sp_add_drone (
    IN ip_storeID VARCHAR(40),
    IN ip_droneTag INTEGER,
    IN ip_capacity INTEGER,
    IN ip_remaining_trips INTEGER,
    IN ip_pilot VARCHAR(40)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed in sp_add_drone';
    END;

    START TRANSACTION;

    -- Validate input parameters
    IF ip_storeID IS NULL OR ip_droneTag IS NULL OR ip_capacity IS NULL OR
       ip_remaining_trips IS NULL OR ip_pilot IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'All input parameters must be provided';
    END IF;

    -- Check if store exists
    IF NOT EXISTS (SELECT 1 FROM stores WHERE storeID = ip_storeID) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Store does not exist';
    END IF;

    -- Check if drone tag already exists for the store
    IF EXISTS (SELECT 1 FROM drones WHERE storeID = ip_storeID AND droneTag = ip_droneTag) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Drone tag already exists for this store';
    END IF;

    -- Check if pilot is already assigned to a drone
    IF EXISTS (SELECT 1 FROM drones WHERE pilot = ip_pilot) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pilot is already assigned to another drone';
    END IF;

    -- Check if pilot exists
    IF NOT EXISTS (SELECT 1 FROM drone_pilots WHERE uname = ip_pilot) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pilot does not exist';
    END IF;

    -- Insert into drones
    INSERT INTO drones (storeID, droneTag, capacity, remaining_trips, pilot)
        VALUES (ip_storeID, ip_droneTag, ip_capacity, ip_remaining_trips, ip_pilot);

    COMMIT;
END //
DELIMITER ;

-- Increase Customer Credits
DELIMITER //
CREATE PROCEDURE sp_increase_customer_credits (
    IN ip_uname VARCHAR(40),
    IN ip_money INTEGER
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed in sp_increase_customer_credits';
    END;

    START TRANSACTION;

    -- Validate input parameters
    IF ip_uname IS NULL OR ip_money IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'All input parameters must be provided';
    END IF;

    -- Check if customer exists
    IF NOT EXISTS (SELECT 1 FROM customers WHERE uname = ip_uname) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer does not exist';
    END IF;

    -- Ensure ip_money is non-negative
    IF ip_money < 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Credit increase amount must be non-negative';
    END IF;

    -- Update customer's credit
    UPDATE customers
    SET credit = credit + ip_money
    WHERE uname = ip_uname;

    COMMIT;
END //
DELIMITER ;

-- Swap Drone Control
DELIMITER //
CREATE PROCEDURE sp_swap_drone_control (
    IN ip_incoming_pilot VARCHAR(40),
    IN ip_outgoing_pilot VARCHAR(40)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed in sp_swap_drone_control';
    END;

    START TRANSACTION;

    -- Validate input parameters
    IF ip_incoming_pilot IS NULL OR ip_outgoing_pilot IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'All input parameters must be provided';
    END IF;

    -- Check if incoming pilot exists
    IF NOT EXISTS (SELECT 1 FROM drone_pilots WHERE uname = ip_incoming_pilot) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incoming pilot does not exist';
    END IF;

    -- Check if incoming pilot is already assigned to a drone
    IF EXISTS (SELECT 1 FROM drones WHERE pilot = ip_incoming_pilot) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incoming pilot is already assigned to a drone';
    END IF;

    -- Check if outgoing pilot exists and is assigned to at least one drone
    IF NOT EXISTS (SELECT 1 FROM drones WHERE pilot = ip_outgoing_pilot) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Outgoing pilot does not have any drones assigned';
    END IF;

    -- Swap pilots in drones
    UPDATE drones
    SET pilot = ip_incoming_pilot
    WHERE pilot = ip_outgoing_pilot;

    COMMIT;
END //
DELIMITER ;

-- Repair or Refuel Drone
DELIMITER //
CREATE PROCEDURE sp_repair_refuel_drone (
    IN ip_drone_store VARCHAR(40),
    IN ip_drone_tag INTEGER,
    IN ip_refueled_trips INTEGER
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed in sp_repair_refuel_drone';
    END;

    START TRANSACTION;

    -- Validate input parameters
    IF ip_drone_store IS NULL OR ip_drone_tag IS NULL OR ip_refueled_trips IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'All input parameters must be provided';
    END IF;

    -- Ensure refueled trips is non-negative
    IF ip_refueled_trips < 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Refueled trips must be non-negative';
    END IF;

    -- Check if drone exists
    IF NOT EXISTS (SELECT 1 FROM drones WHERE storeID = ip_drone_store AND droneTag = ip_drone_tag) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Drone does not exist';
    END IF;

    -- Update remaining trips
    UPDATE drones
    SET remaining_trips = remaining_trips + ip_refueled_trips
    WHERE storeID = ip_drone_store AND droneTag = ip_drone_tag;

    COMMIT;
END //
DELIMITER ;

-- Begin Order
DELIMITER //
CREATE PROCEDURE sp_begin_order (
    IN ip_orderID VARCHAR(40),
    IN ip_sold_on DATE,
    IN ip_purchased_by VARCHAR(40),
    IN ip_carrier_store VARCHAR(40),
    IN ip_carrier_tag INTEGER,
    IN ip_barcode VARCHAR(40),
    IN ip_price INTEGER,
    IN ip_quantity INTEGER
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed in sp_begin_order';
    END;

    DECLARE customer_credit INTEGER;
    DECLARE weight_limit INTEGER;
    DECLARE product_weight INTEGER;

    START TRANSACTION;

    -- Validate input parameters
    IF ip_purchased_by IS NULL OR ip_orderID IS NULL OR ip_carrier_tag IS NULL OR ip_barcode IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'All input parameters must be provided';
    END IF;

    -- Check if customer exists
    IF NOT EXISTS (SELECT 1 FROM customers WHERE uname = ip_purchased_by) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer does not exist';
    END IF;

    -- Check if drone exists
    IF NOT EXISTS (SELECT 1 FROM drones WHERE storeID = ip_carrier_store AND droneTag = ip_carrier_tag) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Drone does not exist';
    END IF;

    -- Check if product exists
    IF NOT EXISTS (SELECT 1 FROM products WHERE barcode = ip_barcode) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product does not exist';
    END IF;

    -- Check if orderID already exists
    IF EXISTS (SELECT 1 FROM orders WHERE orderID = ip_orderID) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order ID already exists';
    END IF;

    -- Validate price and quantity
    IF ip_price < 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Price must be non-negative';
    END IF;

    IF ip_quantity <= 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantity must be positive';
    END IF;

    -- Check customer credit
    SELECT credit INTO customer_credit FROM customers WHERE uname = ip_purchased_by;
    IF customer_credit < (ip_price * ip_quantity) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient customer credit';
    END IF;

    -- Check drone capacity
    SELECT capacity INTO weight_limit FROM drones
    WHERE storeID = ip_carrier_store AND droneTag = ip_carrier_tag;
    SELECT weight INTO product_weight FROM products WHERE barcode = ip_barcode;
    IF (product_weight * ip_quantity) > weight_limit THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Drone capacity insufficient for the order';
    END IF;

    -- Insert into orders
    INSERT INTO orders (orderID, sold_on, purchased_by, carrier_store, carrier_tag)
        VALUES (ip_orderID, ip_sold_on, ip_purchased_by, ip_carrier_store, ip_carrier_tag);

    -- Insert into order_lines
    INSERT INTO order_lines (orderID, barcode, price, quantity)
        VALUES (ip_orderID, ip_barcode, ip_price, ip_quantity);

    COMMIT;
END //
DELIMITER ;

-- Order Total Prices View
DROP VIEW IF EXISTS order_total_prices;
CREATE OR REPLACE VIEW order_total_prices AS
SELECT
    ol.orderID,
    SUM(ol.quantity * ol.price) AS price_total
FROM
    order_lines ol
JOIN
    products p ON ol.barcode = p.barcode
GROUP BY
    ol.orderID;

-- Order Total Weights View
DROP VIEW IF EXISTS order_total_weights;
CREATE OR REPLACE VIEW order_total_weights AS
SELECT
    ol.orderID,
    SUM(ol.quantity * p.weight) AS weight_total
FROM
    order_lines ol
JOIN
    products p ON ol.barcode = p.barcode
GROUP BY
    ol.orderID;

-- Add Order Line
DELIMITER //
CREATE PROCEDURE sp_add_order_line (
    IN ip_orderID VARCHAR(40),
    IN ip_barcode VARCHAR(40),
    IN ip_price INTEGER,
    IN ip_quantity INTEGER
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed in sp_add_order_line';
    END;

    DECLARE customer_credit INTEGER;
    DECLARE order_price INTEGER;
    DECLARE total_cost INTEGER;
    DECLARE store_id VARCHAR(40);
    DECLARE drone_tag INTEGER;
    DECLARE product_weight INTEGER;
    DECLARE drone_capacity INTEGER;
    DECLARE order_total_weight INTEGER;
    DECLARE calculated_weight INTEGER;

    START TRANSACTION;

    -- Validate existence of order and product
    IF NOT EXISTS (SELECT 1 FROM orders WHERE orderID = ip_orderID) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM products WHERE barcode = ip_barcode) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product does not exist';
    END IF;

    -- Check if order line already exists
    IF EXISTS (SELECT 1 FROM order_lines WHERE orderID = ip_orderID AND barcode = ip_barcode) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order line already exists for this product';
    END IF;

    -- Validate price and quantity
    IF ip_price < 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Price must be non-negative';
    END IF;

    IF ip_quantity <= 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantity must be positive';
    END IF;

    -- Retrieve customer credit
    SELECT c.credit INTO customer_credit
    FROM customers c
    JOIN orders o ON c.uname = o.purchased_by
    WHERE o.orderID = ip_orderID;

    -- Retrieve current order price
    SELECT ot.price_total INTO order_price
    FROM order_total_prices ot
    WHERE ot.orderID = ip_orderID;

    -- Calculate total cost after adding the new line
    SET total_cost = (ip_price * ip_quantity) + order_price;

    -- Check customer credit
    IF customer_credit < total_cost THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient customer credit for the additional products';
    END IF;

    -- Retrieve drone details
    SELECT o.carrier_store, o.carrier_tag INTO store_id, drone_tag
    FROM orders o
    WHERE o.orderID = ip_orderID;

    -- Retrieve product weight
    SELECT p.weight INTO product_weight
    FROM products p
    WHERE p.barcode = ip_barcode;

    -- Retrieve drone capacity
    SELECT d.capacity INTO drone_capacity
    FROM drones d
    WHERE d.storeID = store_id AND d.droneTag = drone_tag;

    -- Retrieve current total weight of the order
    SELECT ot.weight_total INTO order_total_weight
    FROM order_total_weights ot
    WHERE ot.orderID = ip_orderID;

    -- Calculate additional weight
    SET calculated_weight = product_weight * ip_quantity;

    -- Check drone capacity
    IF drone_capacity < (order_total_weight + calculated_weight) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Drone capacity insufficient for the additional products';
    END IF;

    -- Insert into order_lines
    INSERT INTO order_lines (orderID, barcode, price, quantity)
        VALUES (ip_orderID, ip_barcode, ip_price, ip_quantity);

    COMMIT;
END //
DELIMITER ;

-- Deliver Order
DELIMITER //
CREATE PROCEDURE sp_deliver_order (
    IN ip_orderID VARCHAR(40)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed in sp_deliver_order';
    END;

    DECLARE carrierStore VARCHAR(40);
    DECLARE carrierTag INTEGER;
    DECLARE remainingTrips INTEGER;
    DECLARE purchasedBy VARCHAR(40);
    DECLARE cost INTEGER;
    DECLARE currRating INTEGER;
    DECLARE dronePilot VARCHAR(40);

    START TRANSACTION;

    -- Validate orderID
    IF ip_orderID IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order ID must be provided';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM orders WHERE orderID = ip_orderID) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order does not exist';
    END IF;

    -- Retrieve drone details
    SELECT carrier_store, carrier_tag INTO carrierStore, carrierTag
    FROM orders
    WHERE orderID = ip_orderID;

    -- Check remaining trips
    SELECT remaining_trips INTO remainingTrips
    FROM drones
    WHERE storeID = carrierStore AND droneTag = carrierTag;

    IF remainingTrips <= 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Drone has no remaining trips';
    END IF;

    -- Reduce customer's credit
    SELECT purchased_by INTO purchasedBy
    FROM orders
    WHERE orderID = ip_orderID;

    SELECT SUM(price * quantity) INTO cost
    FROM order_lines
    WHERE orderID = ip_orderID
    GROUP BY orderID;

    UPDATE customers
    SET credit = credit - cost
    WHERE uname = purchasedBy;

    -- Increase store's revenue
    UPDATE stores
    SET revenue = revenue + cost
    WHERE storeID = carrierStore;

    -- Reduce remaining trips
    SET remainingTrips = remainingTrips - 1;
    UPDATE drones
    SET remaining_trips = remainingTrips
    WHERE storeID = carrierStore AND droneTag = carrierTag;

    -- Increase pilot's experience
    SELECT pilot INTO dronePilot
    FROM drones
    WHERE storeID = carrierStore AND droneTag = carrierTag;

    UPDATE drone_pilots
    SET experience = experience + 1
    WHERE uname = dronePilot;

    -- Increase customer's rating if applicable
    SELECT rating INTO currRating
    FROM customers
    WHERE uname = purchasedBy;

    IF cost > 25 AND currRating < 5 THEN
        UPDATE customers
        SET rating = rating + 1
        WHERE uname = purchasedBy;
    END IF;

    -- Remove order and order lines
    DELETE FROM order_lines
    WHERE orderID = ip_orderID;

    DELETE FROM orders
    WHERE orderID = ip_orderID;

    COMMIT;
END //
DELIMITER ;

-- Cancel Order
DELIMITER //
CREATE PROCEDURE sp_cancel_order (
    IN ip_orderID VARCHAR(40)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed in sp_cancel_order';
    END;

    DECLARE cusUname VARCHAR(40);
    DECLARE curRating INTEGER;

    START TRANSACTION;

    -- Check if order exists
    IF NOT EXISTS (SELECT 1 FROM orders WHERE orderID = ip_orderID) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order does not exist';
    END IF;

    -- Retrieve customer username
    SELECT purchased_by INTO cusUname
    FROM orders
    WHERE orderID = ip_orderID;

    -- Retrieve current rating
    SELECT rating INTO curRating
    FROM customers
    WHERE uname = cusUname;

    -- Decrease customer's rating if applicable
    IF curRating > 1 THEN
        UPDATE customers
        SET rating = rating - 1
        WHERE uname = cusUname;
    END IF;

    -- Remove order and order lines
    DELETE FROM order_lines
    WHERE orderID = ip_orderID;

    DELETE FROM orders
    WHERE orderID = ip_orderID;

    COMMIT;
END //
DELIMITER ;

-- Remove Customer
DELIMITER //
CREATE PROCEDURE sp_remove_customer (
    IN ip_uname VARCHAR(40)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed in sp_remove_customer';
    END;

    START TRANSACTION;

    -- Validate input parameter
    IF ip_uname IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username must be provided';
    END IF;

    -- Check if customer has existing orders
    IF EXISTS (SELECT 1 FROM orders WHERE purchased_by = ip_uname) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer has existing orders and cannot be removed';
    END IF;

    -- Delete from customers
    DELETE FROM customers
    WHERE uname = ip_uname;

    -- If user is not an employee, delete from users
    IF NOT EXISTS (SELECT 1 FROM employees WHERE uname = ip_uname) THEN
        DELETE FROM users
        WHERE uname = ip_uname;
    END IF;

    COMMIT;
END //
DELIMITER ;

-- Remove Drone Pilot
DELIMITER //
CREATE PROCEDURE sp_remove_drone_pilot (
    IN ip_uname VARCHAR(40)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed in sp_remove_drone_pilot';
    END;

    START TRANSACTION;

    -- Validate input parameter
    IF ip_uname IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username must be provided';
    END IF;

    -- Check if pilot is assigned to any drone
    IF EXISTS (SELECT 1 FROM drones WHERE pilot = ip_uname) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pilot is currently assigned to a drone and cannot be removed';
    END IF;

    -- Delete from drone_pilots
    DELETE FROM drone_pilots
    WHERE uname = ip_uname;

    -- Delete from employees
    DELETE FROM employees
    WHERE uname = ip_uname;

    -- If user is not a customer, delete from users
    IF NOT EXISTS (SELECT 1 FROM customers WHERE uname = ip_uname) THEN
        DELETE FROM users
        WHERE uname = ip_uname;
    END IF;

    COMMIT;
END //
DELIMITER ;

-- Remove Product
DELIMITER //
CREATE PROCEDURE sp_remove_product (
    IN ip_barcode VARCHAR(40)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed in sp_remove_product';
    END;

    START TRANSACTION;

    -- Validate input parameter
    IF ip_barcode IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Barcode must be provided';
    END IF;

    -- Check if product is part of any order
    IF EXISTS (SELECT 1 FROM order_lines WHERE barcode = ip_barcode) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product is part of existing orders and cannot be removed';
    END IF;

    -- Delete from products
    DELETE FROM products
    WHERE barcode = ip_barcode;

    COMMIT;
END //
DELIMITER ;

-- Remove Drone
DELIMITER //
CREATE PROCEDURE sp_remove_drone (
    IN ip_storeID VARCHAR(40),
    IN ip_droneTag INTEGER
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed in sp_remove_drone';
    END;

    START TRANSACTION;

    -- Validate input parameters
    IF ip_storeID IS NULL OR ip_droneTag IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Store ID and Drone Tag must be provided';
    END IF;

    -- Check if drone is associated with any orders
    IF EXISTS (
        SELECT 1 FROM orders
        WHERE carrier_store = ip_storeID AND carrier_tag = ip_droneTag
    ) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Drone is associated with existing orders and cannot be removed';
    END IF;

    -- Delete from drones
    DELETE FROM drones
    WHERE storeID = ip_storeID AND droneTag = ip_droneTag;

    COMMIT;
END //
DELIMITER ;

-- -----------------------------------------------
-- Views
-- -----------------------------------------------

-- View to display distribution of persons across various roles
CREATE OR REPLACE VIEW role_distribution AS
SELECT 'users' AS category, COUNT(*) AS total
FROM users
UNION ALL
SELECT 'customers', COUNT(*)
FROM customers
UNION ALL
SELECT 'employees', COUNT(*)
FROM employees
UNION ALL
SELECT 'customer_employer_overlap', COUNT(*)
FROM customers
JOIN employees ON customers.uname = employees.uname
UNION ALL
SELECT 'drone_pilots', COUNT(*)
FROM drone_pilots
UNION ALL
SELECT 'store_workers', COUNT(*)
FROM store_workers
UNION ALL
SELECT 'other_employee_roles', COUNT(*)
FROM employees
WHERE uname NOT IN (SELECT uname FROM drone_pilots)
  AND uname NOT IN (SELECT uname FROM store_workers);


CREATE OR REPLACE VIEW customer_credit_check AS
SELECT
    c.uname AS customer_name,
    c.rating,
    c.credit AS current_credit,
    COALESCE(SUM(ol.price * ol.quantity), 0) AS credit_already_allocated
FROM
    customers c
LEFT JOIN
    orders o ON o.purchased_by = c.uname
LEFT JOIN
    order_lines ol ON o.orderID = ol.orderID
GROUP BY
    c.uname, c.rating, c.credit;


CREATE OR REPLACE VIEW drone_traffic_control AS
SELECT
    d.storeID AS drone_serves_store,
    d.droneTag AS drone_tag,
    d.pilot,
    d.capacity AS total_weight_allowed,
    COALESCE(SUM(p.weight * ol.quantity), 0) AS current_weight,
    d.remaining_trips AS deliveries_allowed,
    COUNT(DISTINCT o.orderID) AS deliveries_in_progress
FROM
    drones d
LEFT JOIN
    orders o ON o.carrier_store = d.storeID AND o.carrier_tag = d.droneTag
LEFT JOIN
    order_lines ol ON o.orderID = ol.orderID
LEFT JOIN
    products p ON ol.barcode = p.barcode
GROUP BY
    d.storeID, d.droneTag, d.pilot, d.capacity, d.remaining_trips;

-- View to display product status and popularity metrics
CREATE OR REPLACE VIEW most_popular_products AS
SELECT
    p.barcode,
    p.pname AS product_name,
    p.weight,
    MIN(ol.price) AS lowest_price,
    MAX(ol.price) AS highest_price,
    COALESCE(MIN(ol.quantity), 0) AS lowest_quantity,
    COALESCE(MAX(ol.quantity), 0) AS highest_quantity,
    COALESCE(SUM(ol.quantity), 0) AS total_quantity
FROM
    products p
LEFT JOIN
    order_lines ol ON p.barcode = ol.barcode
LEFT JOIN
    orders o ON ol.orderID = o.orderID
GROUP BY
    p.barcode, p.pname, p.weight;

-- View to display drone pilot roster and activity
CREATE OR REPLACE VIEW drone_pilot_roster AS
SELECT
    dp.uname AS pilot,
    dp.licenseID AS licenseID,
    d.storeID AS drone_serves_store,
    d.droneTag AS drone_tag,
    dp.experience AS successful_deliveries,
    COUNT(o.orderID) AS pending_deliveries
FROM
    drone_pilots dp
LEFT JOIN
    drones d ON dp.uname = d.pilot
LEFT JOIN
    orders o ON d.storeID = o.carrier_store AND d.droneTag = o.carrier_tag
GROUP BY
    dp.uname, dp.licenseID, d.storeID, d.droneTag, dp.experience;

-- View to overview store revenue and incoming activities
CREATE OR REPLACE VIEW store_sales_overview AS
WITH incoming_revenue_data AS (
    SELECT
        o.carrier_store AS storeID,
        SUM(ol.price * ol.quantity) AS total_incoming_revenue,
        COUNT(DISTINCT o.orderID) AS total_incoming_orders
    FROM orders o
    JOIN order_lines ol ON o.orderID = ol.orderID
    GROUP BY o.carrier_store
)
SELECT
    s.storeID,
    s.sname,
    s.manager,
    s.revenue,
    COALESCE(ird.total_incoming_revenue, 0) AS incoming_revenue,
    COALESCE(ird.total_incoming_orders, 0) AS incoming_orders
FROM
    stores s
LEFT JOIN
    incoming_revenue_data ird ON s.storeID = ird.storeID;

-- View to display current orders in progress
CREATE OR REPLACE VIEW orders_in_progress AS
WITH order_details AS (
    SELECT
        ol.orderID,
        SUM(ol.price * ol.quantity) AS cost,
        COUNT(DISTINCT ol.barcode) AS num_products,
        SUM(p.weight * ol.quantity) AS payload,
        GROUP_CONCAT(p.pname ORDER BY p.pname SEPARATOR ',') AS contents
    FROM order_lines ol
    INNER JOIN products p ON ol.barcode = p.barcode
    GROUP BY ol.orderID
)
SELECT
    o.orderID,
    od.cost,
    od.num_products,
    od.payload,
    od.contents
FROM
    orders o
INNER JOIN
    order_details od ON o.orderID = od.orderID
ORDER BY
    o.orderID;

-- -----------------------------------------------
-- End of Script
-- -----------------------------------------------
