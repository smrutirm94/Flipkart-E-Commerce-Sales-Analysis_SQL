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

-- -------------------------------------------------------
-- Section 2: Customer Demographics and Category Analysis
-- Questions Q6 to Q10
-- Focus: Unique customer count, age group trends, gender patterns,
--        zone-wise demand, and average order quantity by category
-- Note: All queries consider only 'Delivered' orders for cleaner insights
-- -------------------------------------------------------


-- Q6: Number of Unique Customers by Category
-- Objective: Understand customer engagement across product categories
-- Note: Filtered only 'Delivered' orders to ensure analysis is based on successful transactions.

SELECT 
    p.Product_Category, 
    COUNT(DISTINCT o.CustomerID) AS unique_customers
FROM Product p
JOIN Orders o
  ON p.ProductID = o.ProductID
WHERE o.Status = 'Delivered'
GROUP BY p.Product_Category
ORDER BY unique_customers DESC;


-- Q7: Customer Age Group Distribution by Category
-- Objective: Identify age segments active in different product categories
-- Note: Focused only on delivered orders to reflect actual customer behavior.

SELECT 
    p.Product_Category,
    CASE 
        WHEN o.Customer_Age < 20 THEN 'Below 20'
        WHEN o.Customer_Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN o.Customer_Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN o.Customer_Age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+' 
    END AS age_group,
    COUNT(DISTINCT o.CustomerID) AS customer_count
FROM Orders o
JOIN Product p
  ON o.ProductID = p.ProductID
WHERE o.Status = 'Delivered'
GROUP BY p.Product_Category, 
         CASE 
            WHEN o.Customer_Age < 20 THEN 'Below 20'
            WHEN o.Customer_Age BETWEEN 20 AND 29 THEN '20-29'
            WHEN o.Customer_Age BETWEEN 30 AND 39 THEN '30-39'
            WHEN o.Customer_Age BETWEEN 40 AND 49 THEN '40-49'
            ELSE '50+' 
         END
ORDER BY p.Product_Category, age_group;


-- Q8: Product Category Purchase by Gender
-- Objective: Analyze gender-based purchase behavior per category
-- Note: Only delivered orders included to avoid distortion by returns or cancellations.

SELECT 
    p.Product_Category,
    o.Customer_Gender,
    COUNT(*) AS total_orders
FROM Orders o
JOIN Product p
  ON o.ProductID = p.ProductID
WHERE o.Status = 'Delivered'
GROUP BY p.Product_Category, o.Customer_Gender
ORDER BY p.Product_Category;


-- Q9: Customer Zone-wise Category Demand
-- Objective: Understand regional trends in category purchases
-- Note: Only completed deliveries are considered to reflect true geographic demand.

SELECT 
    o.Zone,
    p.Product_Category,
    COUNT(*) AS total_orders
FROM Orders o
JOIN Product p
  ON o.ProductID = p.ProductID
WHERE o.Status = 'Delivered'
GROUP BY o.Zone, p.Product_Category
ORDER BY o.Zone, total_orders DESC;


-- Q10: Average Order Quantity per Category
-- Objective: Determine how much customers typically order per category
-- Note: Analyzed only delivered orders for an accurate average.

SELECT 
    p.Product_Category,
    ROUND(AVG(o.Order_Quantity), 2) AS avg_order_quantity
FROM Orders o
JOIN Product p
  ON o.ProductID = p.ProductID
WHERE o.Status = 'Delivered'
GROUP BY p.Product_Category
ORDER BY avg_order_quantity DESC;

