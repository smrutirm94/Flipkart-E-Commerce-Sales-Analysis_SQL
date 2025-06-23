-- Q1: Total Revenue from Delivered Orders
-- Objective: Calculate total revenue from all successfully delivered orders.

SELECT 
    SUM(sale_price) AS total_revenue
FROM orders
WHERE status = 'Delivered';

--------------------------------------------------

-- Q2: Revenue by Product Category
-- Objective: Determine which product categories generate the most revenue.

SELECT 
    p.product_category, 
    SUM(o.sale_price) AS total_revenue
FROM orders o
JOIN product p ON o.productid = p.productid
WHERE o.status = 'Delivered'
GROUP BY p.product_category
ORDER BY total_revenue DESC;

--------------------------------------------------

-- Q3: Top 10 Best-Selling Products by Sales Value
-- Objective: Identify the top 10 products that brought in the highest revenue.

SELECT TOP 10 
    p.product_name, 
    SUM(o.sale_price) AS total_sales
FROM orders o
JOIN product p ON o.productid = p.productid
WHERE o.status = 'Delivered'
GROUP BY p.product_name
ORDER BY total_sales DESC;

--------------------------------------------------

-- Q4: Total Orders and Revenue by Zone
-- Objective: Compare order volume and revenue across zones.

SELECT 
    o.zone, 
    COUNT(o.orderid) AS total_orders,
    SUM(o.sale_price) AS total_revenue
FROM orders o
WHERE o.status = 'Delivered'
GROUP BY o.zone
ORDER BY total_revenue DESC;

--------------------------------------------------

-- Q5: Month-over-Month Revenue Trend (last 6 months)
-- Objective: Identify recent revenue trends and detect any seasonality.

SELECT 
    FORMAT(orderdate, 'yyyy-MM') AS month_year,
    SUM(sale_price) AS monthly_revenue
FROM orders
WHERE status = 'Delivered'
AND orderdate >= DATEADD(MONTH, -6, GETDATE())
GROUP BY FORMAT(orderdate, 'yyyy-MM')
ORDER BY month_year;

--Here as the latest date in the dataset is 31st DEC 2020
--so in general last 6 months from the current date will not give us the exact output, so
--to modify the question little bit , identify the last 6 month revenue trend from the latest year

"Since the dataset ends on 31st Dec 2020, using GETDATE() wouldn’t give relevant results.
Instead, I dynamically anchored the last 6 months based on the MAX(orderdate) in the dataset.
I used > instead of >= to include exactly 6 full months, from July to December 2020."

SELECT 
    FORMAT(orderdate, 'yyyy-MM') AS month_year,
    SUM(sale_price) AS monthly_revenue
FROM orders
WHERE status = 'Delivered'
AND orderdate > DATEADD(MONTH, -6, (select max(orderdate) from orders))
GROUP BY FORMAT(orderdate, 'yyyy-MM')
ORDER BY month_year;
