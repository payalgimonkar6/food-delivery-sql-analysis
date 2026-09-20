-- Duplicate Orders

SELECT order_id,
    COUNT(*) AS order_count
FROM food_orders_raw
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY order_count DESC;

-- Missing Values Check
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

SELECT *
FROM food_orders_raw
WHERE order_status IS NULL
   OR TRIM(order_status) = '';

-- Exact Order Status Values
SELECT CONCAT('[', order_status, ']') AS exact_status,
    LENGTH(order_status) AS status_length,
    COUNT(*) AS order_count
FROM food_orders_raw
GROUP BY order_status, LENGTH(order_status)
ORDER BY order_count DESC;

UPDATE food_orders_raw
SET
    restaurant_name = TRIM(restaurant_name),
    subzone = TRIM(subzone),
    city = TRIM(city),
    order_status = TRIM(order_status),
    delivery = TRIM(delivery);

SELECT DISTINCT order_status
FROM food_orders_raw;

-- Rating Check & Cleaning
SELECT rating,
    COUNT(*) AS rating_count
FROM food_orders_raw
WHERE rating IS NOT NULL
  AND rating <> ''
GROUP BY rating
ORDER BY rating;

-- Numerical Data Check
SELECT
    MIN(total) AS min_total,
    MAX(total) AS max_total,
    MIN(distance) AS min_distance,
    MAX(distance) AS max_distance,
    MIN(items_in_order) AS min_items,
    MAX(items_in_order) AS max_items
FROM food_orders_raw;

SELECT
    COUNT(*) AS total_orders,
    SUM(total IS NULL) AS null_total,
    SUM(total <= 0) AS invalid_total,
    MIN(total) AS minimum_total,
    MAX(total) AS maximum_total
FROM food_orders_raw;

ALTER TABLE food_orders_raw
ADD COLUMN distance_km DECIMAL(5,2);

UPDATE food_orders_raw
SET distance_km =
    CASE
        WHEN TRIM(distance) = '<1km' THEN 0.5
        ELSE CAST(REPLACE(TRIM(distance), 'km', '') AS DECIMAL(5,2))
    END;
    
SELECT distance,
    distance_km,
    COUNT(*) AS order_count
FROM food_orders_raw
GROUP BY distance, distance_km
ORDER BY distance_km;

ALTER TABLE food_orders_raw
ADD COLUMN item_count INT;

UPDATE food_orders_raw
SET item_count =
(
    SELECT SUM(CAST(SUBSTRING_INDEX(TRIM(item), ' x ', 1) AS UNSIGNED))
    FROM JSON_TABLE(
        CONCAT(
            '["',
            REPLACE(REPLACE(items_in_order, '"', ''), ', ', '","'),
            '"]'
        ),
        '$[*]' COLUMNS (
            item VARCHAR(255) PATH '$'
        )
    ) AS jt
);

SELECT
    item_count,
    COUNT(*) AS order_count
FROM food_orders_raw
GROUP BY item_count
ORDER BY item_count;

SELECT COUNT(*) AS missing_item_count
FROM food_orders_raw
WHERE item_count IS NULL;

SELECT COUNT(*) AS missing_distance
FROM food_orders_raw
WHERE distance_km IS NULL;

SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT restaurant_id) AS unique_restaurants
FROM food_orders_raw;

-- Q1) Which restaurants have the highest number of orders?
SELECT restaurant_name,
    COUNT(*) AS order_count
FROM food_orders_raw
GROUP BY restaurant_name
ORDER BY order_count DESC;

-- Q2) Which restaurants generate the highest total sales?
SELECT restaurant_name,
    COUNT(*) AS order_count,
    ROUND(SUM(total), 2) AS total_sales
FROM food_orders_raw
GROUP BY restaurant_name
ORDER BY total_sales DESC;

-- Q3)Which restaurants have the highest average order value?
SELECT restaurant_name,
    COUNT(*) AS order_count,
    ROUND(AVG(total), 2) AS avg_order_value
FROM food_orders_raw
GROUP BY restaurant_name
ORDER BY avg_order_value DESC;

-- Q4) Which order status has the highest number of orders?
SELECT order_status,
    COUNT(*) AS order_count
FROM food_orders_raw
GROUP BY order_status
ORDER BY order_count DESC;

-- Q5) Which ratings are most common among customers?
SELECT rating,
    COUNT(*) AS rating_count
FROM food_orders_raw
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY rating_count DESC;

-- Q6) What percentage of orders were successfully delivered?
SELECT
    COUNT(*) AS total_orders,
    SUM(order_status = 'Delivered') AS delivered_orders,
    ROUND(
        SUM(order_status = 'Delivered') * 100.0 / COUNT(*),
        2
    ) AS delivery_percentage
FROM food_orders_raw;

-- Q7) Which restaurants have the highest number of rejected orders?
SELECT restaurant_name,
    COUNT(*) AS rejected_orders
FROM food_orders_raw
WHERE order_status = 'Rejected'
GROUP BY restaurant_name
ORDER BY rejected_orders DESC;

-- Q8) Which restaurants have the highest number of returned orders?
SELECT restaurant_name,
    COUNT(*) AS returned_orders
FROM food_orders_raw
WHERE order_status = 'Returned'
GROUP BY restaurant_name
ORDER BY returned_orders DESC;

-- Q9) Which restaurants have the highest average rating?
SELECT restaurant_name,
    ROUND(AVG(rating), 2) AS avg_rating
FROM food_orders_raw
WHERE rating IS NOT NULL
GROUP BY restaurant_name
ORDER BY avg_rating DESC;

-- Q10) Which restaurants have the highest average order value?
SELECT restaurant_name,
    ROUND(AVG(total), 2) AS avg_order_value
FROM food_orders_raw
GROUP BY restaurant_name
ORDER BY avg_order_value DESC;

-- Q11) Which restaurants have the highest number of delivered orders?
SELECT restaurant_name,
    COUNT(*) AS delivered_orders
FROM food_orders_raw
WHERE order_status = 'Delivered'
GROUP BY restaurant_name
ORDER BY delivered_orders DESC;

-- Q12) Which restaurants have the highest total revenue from delivered orders?
SELECT restaurant_name,
    ROUND(SUM(total), 2) AS delivered_revenue
FROM food_orders_raw
WHERE order_status = 'Delivered'
GROUP BY restaurant_name
ORDER BY delivered_revenue DESC;

-- Q13) Which restaurants have the highest rejection rate?
SELECT
    restaurant_name,
    COUNT(*) AS total_orders,
    SUM(order_status = 'Rejected') AS rejected_orders,
    ROUND(
        SUM(order_status = 'Rejected') * 100.0 / COUNT(*),
        2
    ) AS rejection_rate
FROM food_orders_raw
GROUP BY restaurant_name
ORDER BY rejection_rate DESC;

-- Q14) Which restaurants have the highest delivery success rate?
SELECT restaurant_name,
    COUNT(*) AS total_orders,
    SUM(order_status = 'Delivered') AS delivered_orders,
    ROUND(
        SUM(order_status = 'Delivered') * 100.0 / COUNT(*),
        2
    ) AS delivery_success_rate
FROM food_orders_raw
GROUP BY restaurant_name
ORDER BY delivery_success_rate DESC;

-- Q15) Which restaurants have the highest average rating among restaurants with at least 100 orders?
SELECT restaurant_name,
    COUNT(*) AS total_orders,
    ROUND(AVG(rating), 2) AS avg_rating
FROM food_orders_raw
WHERE rating IS NOT NULL
GROUP BY restaurant_name
HAVING COUNT(*) >= 100
ORDER BY avg_rating DESC;

-- Q16) Which restaurants have the highest average order value among restaurants with at least 100 orders?
SELECT restaurant_name,
    COUNT(*) AS total_orders,
    ROUND(AVG(total), 2) AS avg_order_value
FROM food_orders_raw
GROUP BY restaurant_name
HAVING COUNT(*) >= 100
ORDER BY avg_order_value DESC;

-- Q17) Which restaurants have the highest percentage of delivered orders?
SELECT restaurant_name,
    COUNT(*) AS total_orders,
    SUM(order_status = 'Delivered') AS delivered_orders,
    ROUND(
        SUM(order_status = 'Delivered') * 100.0 / COUNT(*),
        2
    ) AS delivery_success_rate
FROM food_orders_raw
GROUP BY restaurant_name
ORDER BY delivery_success_rate DESC;

-- Q18) Which restaurants have the highest rejection rate?
SELECT restaurant_name,
    COUNT(*) AS total_orders,
    SUM(order_status = 'Rejected') AS rejected_orders,
    ROUND(
        SUM(order_status = 'Rejected') * 100.0 / COUNT(*),
        2
    ) AS rejection_rate
FROM food_orders_raw
GROUP BY restaurant_name
ORDER BY rejection_rate DESC;

-- Q19) Which restaurants have the highest number of returned orders?
SELECT restaurant_name,
    COUNT(*) AS total_orders,
    SUM(order_status = 'Returned') AS returned_orders
FROM food_orders_raw
GROUP BY restaurant_name
ORDER BY returned_orders DESC;

-- Q20) Which restaurants generate the highest revenue per delivered order?
SELECT restaurant_name,
    SUM(order_status = 'Delivered') AS delivered_orders,
    ROUND(
        SUM(CASE
            WHEN order_status = 'Delivered' THEN total
            ELSE 0
        END)
        / SUM(order_status = 'Delivered'),
        2
    ) AS revenue_per_delivered_order
FROM food_orders_raw
GROUP BY restaurant_name
ORDER BY revenue_per_delivered_order DESC;

-- Q21) Which restaurants have the highest average number of items per order?
SELECT restaurant_name,
    COUNT(*) AS total_orders,
    ROUND(AVG(item_count), 2) AS avg_items_per_order
FROM food_orders_raw
GROUP BY restaurant_name
ORDER BY avg_items_per_order DESC;

-- Q22) Which restaurants have the highest average delivery distance?
SELECT restaurant_name,
       ROUND(AVG(distance_km), 2) AS avg_delivery_distance
FROM food_orders_raw
WHERE distance_km IS NOT NULL
GROUP BY restaurant_name
ORDER BY avg_delivery_distance DESC;

-- Q23) Which restaurants have the highest average delivery time?
SELECT restaurant_name,
       ROUND(AVG(delivery), 2) AS avg_delivery_time
FROM food_orders_raw
WHERE delivery IS NOT NULL
GROUP BY restaurant_name
ORDER BY avg_delivery_time DESC;

-- Q24) Which restaurants have the highest average rider waiting time?
SELECT restaurant_name,
       ROUND(AVG(rider_wait_time_minutes), 2) AS avg_rider_wait_time
FROM food_orders_raw
WHERE rider_wait_time_minutes IS NOT NULL
GROUP BY restaurant_name
ORDER BY avg_rider_wait_time DESC;

-- Q25) Which restaurants have the highest average discount amount?
SELECT restaurant_name,
       ROUND(AVG(discount_construct), 2) AS avg_discount
FROM food_orders_raw
WHERE discount_construct IS NOT NULL
GROUP BY restaurant_name
ORDER BY avg_discount DESC;

-- Q26) Which restaurants have the highest total discount amount?
SELECT restaurant_name,
       ROUND(SUM(discount_construct), 2) AS total_discount
FROM food_orders_raw
WHERE discount_construct IS NOT NULL
GROUP BY restaurant_name
ORDER BY total_discount DESC;

-- Q27) Which restaurants have the highest total packaging charges?
SELECT restaurant_name,
       ROUND(SUM(packaging_charges), 2) AS total_packaging_charges
FROM food_orders_raw
WHERE packaging_charges IS NOT NULL
GROUP BY restaurant_name
ORDER BY total_packaging_charges DESC;

-- Q28) Which restaurants have the highest total bill subtotal?
SELECT restaurant_name,
    ROUND(SUM(bill_subtotal), 2) AS total_bill_subtotal
FROM food_orders_raw
WHERE bill_subtotal IS NOT NULL
GROUP BY restaurant_name
ORDER BY total_bill_subtotal DESC;

-- Q29) Which restaurants have the highest total restaurant promotional discounts?
SELECT restaurant_name,
    ROUND(SUM(restaurant_discount_promo), 2) AS total_promo_discount
FROM food_orders_raw
WHERE restaurant_discount_promo IS NOT NULL
GROUP BY restaurant_name
ORDER BY total_promo_discount DESC;

-- Q30) Which restaurants have the highest total flat-off discounts?
SELECT restaurant_name,
    ROUND(SUM(restaurant_discount_flat_offs), 2) AS total_flat_off_discount
FROM food_orders_raw
WHERE restaurant_discount_flat_offs IS NOT NULL
GROUP BY restaurant_name
ORDER BY total_flat_off_discount DESC;

-- Q31) Which restaurants have the highest total Gold discounts?
SELECT restaurant_name,
    ROUND(SUM(gold_discount), 2) AS total_gold_discount
FROM food_orders_raw
WHERE gold_discount IS NOT NULL
GROUP BY restaurant_name
ORDER BY total_gold_discount DESC;

-- Q32) Which restaurants have the highest total brand pack discounts?
SELECT
    restaurant_name,
    ROUND(SUM(brand_pack_discount), 2) AS total_brand_pack_discount
FROM food_orders_raw
WHERE brand_pack_discount IS NOT NULL
GROUP BY restaurant_name
ORDER BY total_brand_pack_discount DESC;

-- Q33) Which restaurants have the highest total restaurant compensation?
SELECT restaurant_name,
    ROUND(SUM(restaurant_compensation_cancellation), 2) AS total_compensation
FROM food_orders_raw
WHERE restaurant_compensation_cancellation IS NOT NULL
GROUP BY restaurant_name
ORDER BY total_compensation DESC;

-- Q34) Customer Order Analysis
SELECT customer_id,
    COUNT(*) AS total_orders
FROM food_orders_raw
GROUP BY customer_id
ORDER BY total_orders DESC;

-- Q35) Which customers generate the highest total revenue?
SELECT customer_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(total), 2) AS total_spent
FROM food_orders_raw
GROUP BY customer_id
ORDER BY total_spent DESC;

-- Q36) Which customers have the highest average order value?
SELECT customer_id,
    COUNT(*) AS total_orders,
    ROUND(AVG(total), 2) AS avg_order_value
FROM food_orders_raw
GROUP BY customer_id
ORDER BY avg_order_value DESC;

-- Q37) Which customers have placed more than 5 orders?
SELECT customer_id,
    COUNT(*) AS total_orders
FROM food_orders_raw
GROUP BY customer_id
HAVING COUNT(*) > 5
ORDER BY total_orders DESC;

-- Q38) Which customers have placed orders from multiple restaurants?
SELECT customer_id,
    COUNT(DISTINCT restaurant_id) AS restaurant_count
FROM food_orders_raw
GROUP BY customer_id
HAVING COUNT(DISTINCT restaurant_id) > 1
ORDER BY restaurant_count DESC;

-- Q39) Which customers have the highest number of delivered orders?
SELECT customer_id,
    COUNT(*) AS delivered_orders
FROM food_orders_raw
WHERE order_status = 'Delivered'
GROUP BY customer_id
ORDER BY delivered_orders DESC;

-- Q40) Which customers have the highest total spending on delivered orders?
SELECT customer_id,
    COUNT(*) AS delivered_orders,
    ROUND(SUM(total), 2) AS delivered_spending
FROM food_orders_raw
WHERE order_status = 'Delivered'
GROUP BY customer_id
ORDER BY delivered_spending DESC;

-- Q41) Top Revenue-Generating Restaurants
WITH restaurant_revenue AS (
    SELECT
        restaurant_name,
        ROUND(SUM(total), 2) AS total_revenue
    FROM food_orders_raw
    GROUP BY restaurant_name
)

SELECT
    restaurant_name,
    total_revenue
FROM restaurant_revenue
WHERE total_revenue > (
    SELECT AVG(total_revenue)
    FROM restaurant_revenue
)
ORDER BY total_revenue DESC;

-- Q42) Customers Spending Above Average
SELECT customer_id,
    ROUND(SUM(total), 2) AS total_spent
FROM food_orders_raw
GROUP BY customer_id
HAVING SUM(total) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT
            customer_id,
            SUM(total) AS customer_total
        FROM food_orders_raw
        GROUP BY customer_id
    ) AS customer_spending
)
ORDER BY total_spent DESC;

-- Q43) Customer Spending Category
SELECT
    customer_id,
    ROUND(SUM(total), 2) AS total_spent,
    CASE
        WHEN SUM(total) >= 10000 THEN 'High Spender'
        WHEN SUM(total) >= 5000 THEN 'Medium Spender'
        ELSE 'Low Spender'
    END AS spending_category
FROM food_orders_raw
GROUP BY customer_id
ORDER BY total_spent DESC;

-- Q44) Order Value Classification
SELECT
    order_id,
    restaurant_name,
    total,
    CASE
        WHEN total >= 800 THEN 'High Value'
        WHEN total >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS order_value_category
FROM food_orders_raw
ORDER BY total DESC;

-- Q45) Restaurant Performance Analysis
CREATE VIEW restaurant_performance AS
SELECT
    restaurant_name,
    COUNT(*) AS total_orders,
    SUM(order_status = 'Delivered') AS delivered_orders,
    SUM(order_status = 'Rejected') AS rejected_orders,
    ROUND(SUM(total), 2) AS total_revenue,
    ROUND(AVG(total), 2) AS avg_order_value,
    ROUND(AVG(rating), 2) AS avg_rating
FROM food_orders_raw
GROUP BY restaurant_name;
SELECT *
FROM restaurant_performance
ORDER BY total_revenue DESC;

-- Q46) Customer Performance Analysis
CREATE VIEW customer_performance AS
SELECT
    customer_id,
    COUNT(*) AS total_orders,
    SUM(order_status = 'Delivered') AS delivered_orders,
    ROUND(SUM(total), 2) AS total_spent,
    ROUND(AVG(total), 2) AS avg_order_value,
    COUNT(DISTINCT restaurant_id) AS restaurants_ordered_from
FROM food_orders_raw
GROUP BY customer_id;
SELECT *
FROM customer_performance
ORDER BY total_spent DESC;

-- Q47) Rank Restaurants by Revenue
SELECT restaurant_name,
    ROUND(SUM(total), 2) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(total) DESC
    ) AS revenue_rank
FROM food_orders_raw
GROUP BY restaurant_name
ORDER BY revenue_rank;

-- Q48) Rank Orders Within Each Restaurant
SELECT restaurant_name,
    order_id,
    total,
    ROW_NUMBER() OVER (
        PARTITION BY restaurant_name
        ORDER BY total DESC
    ) AS order_rank
FROM food_orders_raw;

-- Q49) Compare with Previous Order
SELECT customer_id,
    order_id, order_placed_at,
    total,
    LAG(total) OVER (
        PARTITION BY customer_id
        ORDER BY order_placed_at
    ) AS previous_order_value
FROM food_orders_raw;

-- Q50) Monthly Revenue & Month-over-Month Growth
-- SELECT order_placed_at
-- FROM food_orders_raw
-- LIMIT 5;

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(
            STR_TO_DATE(order_placed_at, '%h:%i %p, %M %d %Y'),
            '%Y-%m'
        ) AS order_month,

        ROUND(SUM(total), 2) AS monthly_revenue

    FROM food_orders_raw

    GROUP BY
        DATE_FORMAT(
            STR_TO_DATE(order_placed_at, '%h:%i %p, %M %d %Y'),
            '%Y-%m'
        )
)

SELECT
    order_month,
    monthly_revenue,

    LAG(monthly_revenue) OVER (
        ORDER BY order_month
    ) AS previous_month_revenue,

    ROUND(
        (
            monthly_revenue -
            LAG(monthly_revenue) OVER (
                ORDER BY order_month
            )
        ) * 100.0
        /
        NULLIF(
            LAG(monthly_revenue) OVER (
                ORDER BY order_month
            ),
            0
        ),
        2
    ) AS revenue_growth_percentage

FROM monthly_revenue

ORDER BY order_month;