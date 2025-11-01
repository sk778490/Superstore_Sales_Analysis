-- Superstore Sales Analysis - Step-by-step SQL queries with explanation
-- Assumes table name: superstore_sales with columns:
-- OrderID, OrderDate (YYYY-MM-DD), Region, Category, Sub-Category, Sales, Quantity, Discount, Profit, CustomerID, Segment

-- 0) Quick check: show sample rows
-- Purpose: Inspect raw data first
SELECT * FROM superstore_sales
LIMIT 10;

-- 1) Total sales and profit overall
-- Purpose: Business-level KPIs
SELECT SUM(Sales) AS total_sales, SUM(Profit) AS total_profit
FROM superstore_sales;

-- 2) Monthly sales trend
-- Purpose: See how sales change month-to-month
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS year_month,
       SUM(Sales) AS monthly_sales,
       SUM(Profit) AS monthly_profit
FROM superstore_sales
GROUP BY year_month
ORDER BY year_month;

-- 3) Sales by region (descending)
-- Purpose: Find top-performing regions
SELECT Region, SUM(Sales) AS region_sales, SUM(Profit) AS region_profit
FROM superstore_sales
GROUP BY Region
ORDER BY region_sales DESC;

-- 4) Top categories by sales and profit
-- Purpose: Which product categories drive revenue and profit
SELECT Category, SUM(Sales) AS category_sales, SUM(Profit) AS category_profit
FROM superstore_sales
GROUP BY Category
ORDER BY category_sales DESC;

-- 5) Top sub-categories by profit (show top 10)
-- Purpose: Identify high-margin sub-categories
SELECT `Sub-Category`, SUM(Sales) AS sales, SUM(Profit) AS profit
FROM superstore_sales
GROUP BY `Sub-Category`
ORDER BY profit DESC
LIMIT 10;

-- 6) Customers with highest lifetime value (sales)
-- Purpose: Find top customers by revenue
SELECT CustomerID, COUNT(*) AS orders, SUM(Sales) AS lifetime_sales, SUM(Profit) AS lifetime_profit
FROM superstore_sales
GROUP BY CustomerID
ORDER BY lifetime_sales DESC
LIMIT 20;

-- 7) Repeat purchase rate (approx)
-- Purpose: Estimate repeat business using customer order count
SELECT
  SUM(CASE WHEN cnt > 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS repeat_customer_ratio
FROM (
  SELECT CustomerID, COUNT(*) AS cnt
  FROM superstore_sales
  GROUP BY CustomerID
) AS t;

-- 8) Impact of discount on profit (average)
-- Purpose: Compare average profit at different discount levels
SELECT Discount, COUNT(*) AS orders, AVG(Profit) AS avg_profit, AVG(Sales) AS avg_sales
FROM superstore_sales
GROUP BY Discount
ORDER BY Discount;

-- 9) Quantity distribution (how many high-quantity orders)
-- Purpose: Understand order sizes
SELECT Quantity, COUNT(*) AS order_count, SUM(Sales) AS total_sales
FROM superstore_sales
GROUP BY Quantity
ORDER BY Quantity;

-- 10) Loss-making orders (negative profit) by region and category
-- Purpose: Find problem areas where profit is negative
SELECT Region, Category, COUNT(*) AS loss_orders, SUM(Profit) AS total_loss
FROM superstore_sales
WHERE Profit < 0
GROUP BY Region, Category
ORDER BY total_loss ASC;
