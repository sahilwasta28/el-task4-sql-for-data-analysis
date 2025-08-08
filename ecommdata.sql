-- 1) Basic SELECT
SELECT order_id, customer_first_name, customer_city, taxless_total_price
FROM ecommerce
LIMIT 10;

-- 2) WHERE filter
SELECT order_id, customer_first_name, taxless_total_price
FROM ecommerce
WHERE taxless_total_price > 100;

-- 3) ORDER BY
SELECT order_id, customer_first_name, taxless_total_price
FROM ecommerce
ORDER BY taxless_total_price DESC;

-- 4) GROUP BY: Total sales by city
SELECT customer_city, SUM(taxless_total_price) AS total_sales
FROM ecommerce
GROUP BY customer_city
ORDER BY total_sales DESC;

-- 5) GROUP BY: Orders by category
SELECT category, COUNT(order_id) AS order_count
FROM ecommerce
GROUP BY category
ORDER BY order_count DESC;

-- 6) SUM: Total revenue
SELECT SUM(taxless_total_price) AS total_revenue
FROM ecommerce;

-- 7) AVG: Average order value
SELECT AVG(taxless_total_price) AS avg_order_value
FROM ecommerce;

-- 8) MAX/MIN order value
SELECT MAX(taxless_total_price) AS highest_order, MIN(taxless_total_price) AS lowest_order
FROM ecommerce;

-- 9) Customers with above-average spending
SELECT customer_first_name, customer_city, taxless_total_price
FROM ecommerce
WHERE taxless_total_price > (
    SELECT AVG(taxless_total_price) FROM ecommerce
);

-- 10) Top 5 cities by total sales
SELECT customer_city, total_sales
FROM (
    SELECT customer_city, SUM(taxless_total_price) AS total_sales
    FROM ecommerce
    GROUP BY customer_city
) t
ORDER BY total_sales DESC
LIMIT 5;

-- 11) Orders from customers in top-spending city
SELECT *
FROM ecommerce
WHERE customer_city = (
    SELECT customer_city
    FROM ecommerce
    GROUP BY customer_city
    ORDER BY SUM(taxless_total_price) DESC
    LIMIT 1
);

-- Creating a small table customer segments for for join operations 
CREATE TABLE customers_segment (
    customer_first_name TEXT,
    segment TEXT
);

-- Inserting sample data into the table
INSERT INTO customers_segment VALUES
('John', 'Premium'),
('Mary', 'Standard'),
('Elyssa', 'Premium'),
('Mostafa', 'Standard');

--Displaying it to see data values are entered successfully 
select * from customers_segment;

-- 13) INNER JOIN 
SELECT e.customer_first_name, e.customer_city, s.segment
FROM ecommerce e
INNER JOIN customers_segment s
ON e.customer_first_name = s.customer_first_name;

-- 14) LEFT JOIN
SELECT e.customer_first_name, e.customer_city, s.segment
FROM ecommerce e
LEFT JOIN customers_segment s
ON e.customer_first_name = s.customer_first_name;

-- 15) RIGHT JOIN (SQLite doesn’t support RIGHT JOIN directly; so we will emulate with LEFT JOIN reversed)
SELECT e.customer_first_name, e.customer_city, s.segment
FROM customers_segment s
LEFT JOIN ecommerce e
ON e.customer_first_name = s.customer_first_name;

-- 16) Create view for top categories
CREATE VIEW top_categories AS
SELECT category, SUM(taxless_total_price) AS total_sales
FROM ecommerce
GROUP BY category
ORDER BY total_sales DESC;

--displaying the VIEW
select * from top_categories; 

-- 17) Create view for monthly sales trend
CREATE VIEW monthly_sales AS
SELECT substr(order_date, 1, 7) AS month, SUM(taxless_total_price) AS total_sales
FROM ecommerce
GROUP BY month;

--displaying the view
select * from monthly_sales; 

-- 18) Select from monthly sales view
SELECT * FROM monthly_sales ORDER BY month;

-- 19) Create index on order_date and customer_city 
CREATE INDEX idx_order_date ON ecommerce(order_date);

CREATE INDEX idx_customer_city ON ecommerce(customer_city);

-- 20) Optimized query using index
SELECT customer_city, SUM(taxless_total_price) AS total_sales
FROM ecommerce
WHERE order_date >= '2019-01-01'
GROUP BY customer_city;





