
-- Total Sales by Category
SELECT c.category_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sales DESC;

-- Top 5 Products by Revenue
SELECT p.product_name, SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 5;

-- Customer Orders & Spend
SELECT c.customer_name, COUNT(o.order_id) AS total_orders,
       SUM(oi.quantity * oi.unit_price) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_name
ORDER BY total_spend DESC
LIMIT 10;

-- Monthly Sales Trend
SELECT strftime('%Y-%m', o.order_date) AS month, 
       SUM(oi.quantity * oi.unit_price) AS monthly_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- Orders Without Payment
SELECT o.order_id, c.customer_name
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE p.payment_id IS NULL;

-- Create View for Reuse
CREATE VIEW customer_spending AS
SELECT c.customer_name, SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_name;
