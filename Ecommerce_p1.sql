-- Step 1: Create a new database for the E-commerce sales analysis project using My SQL
CREATE DATABASE ecommerce_db;

-- Step 2: using the database to work on
USE ecommerce_db;

-- Step 3: Create a table to store e-commerce order data
CREATE TABLE orders (
-- Unique ID for each orde
    order_id INT PRIMARY KEY,
-- Unique ID of the customer
    customer_id INT,
-- Name of the product
    product VARCHAR(50),
-- Category of the product
    category VARCHAR(50),
-- Price of a single product
    price INT,
-- Quantity ordered
    quantity INT,
-- Payment method used by the customer
    payment_method VARCHAR(30),
-- Date when the order was placed
    order_date DATE,
-- Total order amount (price × quantity)
    total_amount INT
);

-- inserted data using import method
select * from orders;

-- Total revenue from all orders
SELECT SUM(total_amount) AS total_sales
FROM orders;

-- Count of all orders
SELECT COUNT(order_id) AS total_orders
FROM orders;

-- Average value per order
SELECT AVG(total_amount) AS avg_order_value
FROM orders;

-- Total products sold
SELECT SUM(quantity) AS total_products_sold
FROM orders;

-- Sales by each category
SELECT category, SUM(total_amount) AS total_sales
FROM orders
GROUP BY category;

-- Top 5 revenue generating products
SELECT product, SUM(total_amount) AS revenue
FROM orders
GROUP BY product
ORDER BY revenue DESC
LIMIT 5;

-- Top 5 products by quantity sold
SELECT product, SUM(quantity) AS total_quantity
FROM orders
GROUP BY product
ORDER BY total_quantity DESC
LIMIT 5;

-- unique total customers
select Count( distinct customer_id) AS total_customers
from orders;

-- customers with highest spending
select customer_id,sum(total_amount) AS total_spent
from orders
group by customer_id
order by total_spent desc
limit 5;

-- Customers with more than one order
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

-- sale by payment_methods 
select payment_method,sum(total_amount) AS total_sales
from orders
group by payment_method;

-- most used payment_method
select payment_method , count(*) AS method_usage
from orders
group by payment_method
order by method_usage desc
limit 1;

select order_date,sum(total_amount) AS daily_sales
from orders
group by order_date;

-- Monthly sales analysis
SELECT 
YEAR(order_date) AS year,
MONTH(order_date) AS month,
SUM(total_amount) AS monthly_sales
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

describe orders;

SELECT @@SQL_SAFE_UPDATES;
SET @@SQL_SAFE_UPDATES = 0;

-- updated the order_date format
UPDATE orders
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y')
WHERE order_id IS NOT NULL;

-- verify the data type
SELECT order_date FROM orders LIMIT 5;

ALTER TABLE orders
MODIFY order_date DATE;

-- Day with highest sales
SELECT order_date, SUM(total_amount) AS total_sales
FROM orders
GROUP BY order_date
ORDER BY total_sales DESC
LIMIT 1;

-- cumulative sales
select  order_date,sum(total_amount) AS total_sales,
 sum(sum(total_amount)) over(order by order_date)
from orders
group by order_date;


-- product ranking by revenue
select product,sum(total_amount) AS total_revenue,
rank() over(order by sum(total_amount) desc) 
from orders
group by product;


-- revenue contribution by category in percentage
select  category,sum(total_amount)
 AS category_sales,
 round(
 (sum(total_amount)/ (select sum(total_amount) from orders))*100, 2) AS sales_percentage
 from orders
 group by category;
 
 -- low revenue products
 select product,sum(total_amount) AS low_revenue_product
 from orders
 group by product
 having low_revenue_product <100000111;
 
 -- Customers inactive in last 3 months
SELECT customer_id, MAX(order_date) AS last_order_date
FROM orders
GROUP BY customer_id
HAVING last_order_date < DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

 





 





















