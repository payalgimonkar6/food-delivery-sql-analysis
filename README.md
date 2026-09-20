# Food Delivery SQL Analysis

## Project Overview

This project analyzes food delivery data using MySQL to understand restaurant performance, orders, revenue, ratings, delivery performance, rejected orders, returned orders, and customer behavior.

The project contains SQL queries covering basic to advanced SQL concepts, including aggregation, subqueries, CTEs, views, and window functions.

## Tools & Technologies

- MySQL
- MySQL Workbench
- SQL
- GitHub

## Dataset

The main table used in this project is:

`food_orders_raw`

The dataset contains information related to:

- Restaurant
- Customer
- Order ID
- Order Date
- Order Status
- Delivery Time
- Delivery Distance
- Items per Order
- Order Value
- Rating
- Discounts

## SQL Concepts Used

- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- COUNT()
- SUM()
- AVG()
- ROUND()
- CASE
- Subqueries
- CTEs
- Views
- RANK()
- ROW_NUMBER()
- LAG()
- PARTITION BY
- DATE_FORMAT()
- STR_TO_DATE()
- NULLIF()

## Analysis Performed

### Restaurant Analysis

- Restaurant-wise order count
- Restaurant-wise revenue
- Average order value
- Average rating
- Delivered orders
- Rejected orders
- Returned orders
- Delivery success rate
- Rejection rate
- Average items per order
- Average delivery distance
- Average delivery time

### Revenue Analysis

- Total revenue
- Delivered order revenue
- Average order value
- Monthly revenue
- Previous month revenue
- Revenue growth percentage

### Order Performance

- Order status analysis
- Delivery performance
- Rejection analysis
- Return analysis
- Restaurant performance comparison

## Advanced SQL

### Window Functions

Used `RANK()`, `ROW_NUMBER()` and `LAG()` for ranking and comparing records.

### CTE

Used Common Table Expressions to simplify complex queries.

### Views

Created SQL views for reusable restaurant and customer performance analysis.

## Business Insights

The analysis helps understand:

- Restaurant sales performance
- Revenue contribution
- Order volume
- Delivery efficiency
- Rejection patterns
- Return patterns
- Customer ordering behavior
- Rating performance
- Monthly revenue trends

## Project Files

- `foodsql.sql` – SQL analysis queries
- `foodsql2.sql` – Additional SQL analysis queries

## Author

Payal Gimonkar

B.E. Computer Science & Engineering  
Specialization: Data Science
