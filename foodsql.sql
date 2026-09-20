CREATE DATABASE food_delivery_db;
USE food_delivery_db;

SELECT DATABASE();

CREATE TABLE food_orders_raw (
    restaurant_id INT,
    restaurant_name VARCHAR(255),
    subzone VARCHAR(100),
    city VARCHAR(100),
    order_id BIGINT,
    order_placed_at DATETIME,
    order_status VARCHAR(100),
    delivery VARCHAR(100),
    distance VARCHAR(50),
    items_in_order TEXT,
    instructions TEXT,
    discount_construct TEXT,
    bill_subtotal DECIMAL(10,2),
    packaging_charges DECIMAL(10,2),
    restaurant_discount_promo DECIMAL(10,2),
    restaurant_discount_flat_offs DECIMAL(10,2),
    gold_discount DECIMAL(10,2),
    brand_pack_discount DECIMAL(10,2),
    total DECIMAL(10,2),
    rating DECIMAL(3,2),
    review TEXT,
    cancellation_rejection_reason TEXT,
    restaurant_compensation_cancellation DECIMAL(10,2),
    restaurant_penalty_rejection DECIMAL(10,2),
    kpt_duration_minutes DECIMAL(10,2),
    rider_wait_time_minutes DECIMAL(10,2),
    order_ready_marked VARCHAR(100),
    customer_complaint_tag VARCHAR(255),
    customer_id VARCHAR(100)
);

SHOW TABLES;
DESCRIBE food_orders_raw;

ALTER TABLE food_orders_raw
MODIFY COLUMN order_placed_at VARCHAR(100);

ALTER TABLE food_orders_raw
MODIFY restaurant_id VARCHAR(100),
MODIFY order_id VARCHAR(100),
MODIFY order_placed_at VARCHAR(100),
MODIFY bill_subtotal VARCHAR(100),
MODIFY packaging_charges VARCHAR(100),
MODIFY restaurant_discount_promo VARCHAR(100),
MODIFY restaurant_discount_flat_offs VARCHAR(100),
MODIFY gold_discount VARCHAR(100),
MODIFY brand_pack_discount VARCHAR(100),
MODIFY total VARCHAR(100),
MODIFY rating VARCHAR(100),
MODIFY restaurant_compensation_cancellation VARCHAR(100),
MODIFY restaurant_penalty_rejection VARCHAR(100),
MODIFY kpt_duration_minutes VARCHAR(100),
MODIFY rider_wait_time_minutes VARCHAR(100);

SELECT COUNT(*) AS total_rows
FROM food_orders_raw;

SELECT *
FROM food_orders_raw
LIMIT 10;

-- Total Rows
SELECT COUNT(*) AS total_rows
FROM food_orders_raw;

-- Duplicate Orders Check
SELECT order_id,
    COUNT(*) AS order_count
FROM food_orders_raw
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY order_count DESC;

-- NULL / Blank Values
SELECT
    SUM(order_id IS NULL OR order_id = '') AS missing_order_id,
    SUM(customer_id IS NULL OR customer_id = '') AS missing_customer_id,
    SUM(restaurant_id IS NULL OR restaurant_id = '') AS missing_restaurant_id,
    SUM(order_status IS NULL OR order_status = '') AS missing_order_status,
    SUM(total IS NULL OR total = '') AS missing_total,
    SUM(rating IS NULL OR rating = '') AS missing_rating
FROM food_orders_raw;

-- Order Status Check
SELECT order_status,
    COUNT(*) AS order_count
FROM food_orders_raw
GROUP BY order_status
ORDER BY order_count DESC;

-- Rating Check
SELECT rating,
    COUNT(*) AS count_rating
FROM food_orders_raw
GROUP BY rating
ORDER BY rating;

SELECT order_status,
    COUNT(*) AS order_count
FROM food_orders_raw
GROUP BY order_status
ORDER BY order_count DESC;

SELECT order_placed_at
FROM food_orders_raw
LIMIT 10;

ALTER TABLE food_orders_raw
ADD COLUMN order_datetime DATETIME;

UPDATE food_orders_raw
SET order_datetime = STR_TO_DATE(
    order_placed_at,
    '%h:%i %p, %M %d %Y'
);

SELECT order_placed_at,
    order_datetime
FROM food_orders_raw
LIMIT 10;

SELECT COUNT(*) AS total_rows,
    COUNT(order_datetime) AS converted_dates,
    SUM(order_datetime IS NULL) AS failed_dates
FROM food_orders_raw;

SELECT COUNT(*) AS total_rows
FROM food_orders_raw;

ALTER TABLE food_orders_raw
DROP COLUMN order_datetime;

TRUNCATE TABLE food_orders_raw;

ALTER TABLE food_orders_raw
MODIFY restaurant_id VARCHAR(100),
MODIFY restaurant_name VARCHAR(255),
MODIFY subzone VARCHAR(255),
MODIFY city VARCHAR(100),
MODIFY order_id VARCHAR(100),
MODIFY order_placed_at VARCHAR(100),
MODIFY order_status VARCHAR(100),
MODIFY delivery VARCHAR(100),
MODIFY distance VARCHAR(100),
MODIFY items_in_order TEXT,
MODIFY instructions TEXT,
MODIFY discount_construct TEXT,
MODIFY bill_subtotal VARCHAR(100),
MODIFY packaging_charges VARCHAR(100),
MODIFY restaurant_discount_promo VARCHAR(100),
MODIFY restaurant_discount_flat_offs VARCHAR(100),
MODIFY gold_discount VARCHAR(100),
MODIFY brand_pack_discount VARCHAR(100),
MODIFY total VARCHAR(100),
MODIFY rating VARCHAR(100),
MODIFY review TEXT,
MODIFY cancellation_rejection_reason TEXT,
MODIFY restaurant_compensation_cancellation VARCHAR(100),
MODIFY restaurant_penalty_rejection VARCHAR(100),
MODIFY kpt_duration_minutes VARCHAR(100),
MODIFY rider_wait_time_minutes VARCHAR(100),
MODIFY order_ready_marked VARCHAR(100),
MODIFY customer_complaint_tag VARCHAR(255),
MODIFY customer_id VARCHAR(100);

SELECT COUNT(*) AS total_rows
FROM food_orders_raw;

LOAD DATA LOCAL INFILE 'C:/Users/Payal/Downloads/archive (13)/order_history_kaggle_data.csv'
INTO TABLE food_orders_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

TRUNCATE TABLE food_orders_raw;

LOAD DATA LOCAL INFILE 'C:/Users/Payal/Downloads/archive (13)/order_history_kaggle_data.csv'
INTO TABLE food_orders_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_rows
FROM food_orders_raw;