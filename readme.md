# ITCS 3160 Database design project
Riley Schoppa. I will be working alone


## Introduction
With COVID-19 there is an increasing demand for ordering food online and getting it delivered. 
Given this, online ordering systems should be equipped to handle efficient ordering and delivery process.
This database should be designed to accommodate those needs.

## Use Case
Any entity that would like to run a food delivery service (such as crave on campus) should be able to run this mysql server and have the necessary fields to manage customers, drives, restaurants, and orders


## Business Rules
1. Students should be able to order food as well as deliver food
2. Food should be able to be ordered to a location
3. A record of order should be kept for each user
4. Valid restaurants to order from must be approved first
5. Users should be able to rate the quality of a delivery
6. Delivery drivers must be approved and have a valid drivers license
7. Orders that have not been fulfilled should be able to be cancelled

## EERD
![EERD Diagram](https://github.com/riley19280/3160-database/blob/master/EERD.png?raw=true)

## MySQL Queries
```sql
-- Get the total spent for each user
SELECT u.first_name, u.last_name, SUM(o.price) AS total_spent
FROM users u 
JOIN orders o ON
u.id = o.user_id
GROUP BY u.id;
```

```sql
-- get the average order cost for each resturant
SELECT r.name, AVG(o.price) AS avg_spent
FROM orders o 
JOIN restaurants r ON
r.id = o.restaurant_id
GROUP BY o.restaurant_id;
```

```sql
-- get the average rating of each driver
SELECT u.first_name, u.last_name, AVG(r.rating) AS avg_rating FROM users u
JOIN orders o ON
o.driver_id = u.id
JOIN ratings r ON o.id = r.id
WHERE u.id IN (SELECT id FROM drivers)
GROUP BY u.id
```

## Trigger
```sql
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`orders_AFTER_DELETE` AFTER DELETE ON `orders` FOR EACH ROW
BEGIN
    INSERT INTO cancelled_orders(cancelled_orders.id) VALUES (orders.id);
END
```
## Stored Procedure
```sql
DELIMITER $$

CREATE PROCEDURE QuickOrder (
    IN first_name VARCHAR(128),
    IN last_name VARCHAR(128),
    IN email VARCHAR(255),
	IN phone VARCHAR(10),
    IN address VARCHAR(256),
	IN address2 VARCHAR(256),
    IN city VARCHAR(64),
	IN zip INT,
    IN state VARCHAR(2),
	IN restaurant_id INT,
    IN order_text VARCHAR(1024)
)
BEGIN
    INSERT INTO users (first_name, last_name, email, phone) VALUES (first_name, last_name, email, phone);
    SET @userid = LAST_INSERT_ID();
    
    INSERT INTO locations (address, address2, city, state, zip, user_id) VALUES (address, address2, city, state, zip, userid);
    SET @locationid = LAST_INSERT_ID();
    
    SET @driverid = (SELECT id FROM drivers WHERE is_working  = 1 LIMIT 1);
    
    INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text) VALUES (@userid, @driverid, restaurant_id, @locationid, order_text);
    SET @orderid = LAST_INSERT_ID();
    
    UPDATE drivers SET is_working = 1 WHERE id = @driverid;
    
END$$
```
## Web/App Implementation (Optional) or Description of Future Work

In the future a front end application would need to be built to use the database.
Additionally, when an order is created

## MySQL dump

The SQL to generate only the tables and procedures can be found in the tables.sql files

The generated data can be found in data.sql

The MySql dump with all of the data is dump.sql
 
 ## Presentation
 
 View the slides [here](https://docs.google.com/presentation/d/1qs8Xnh6SEhNay_Fixh8lE5ZL5RedROPQ8gEZAiJto60/edit?usp=sharing)
 
 Watch the video [here](https://youtu.be/7uV8n6E7e4w)