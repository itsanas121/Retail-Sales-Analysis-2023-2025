-- =========================
-- RetailDB - Analysis Queries
-- =========================

-- 1) KPIs
-- Total revenue
SELECT SUM(revenue) AS total_revenue FROM sales;

-- Total customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM customers;

-- Total transactions
SELECT COUNT(*) AS total_transactions FROM sales;

-- 2) Revenue by payment method (للـ Donut)
SELECT p.payment_method, SUM(s.revenue) AS total_revenue
FROM sales s
JOIN payments p ON s.payment_id = p.payment_id
GROUP BY p.payment_method
ORDER BY total_revenue DESC;

-- 3) Monthly revenue trend (للـ Line)
SELECT DATE_TRUNC('month', sale_date) AS month,
       SUM(revenue) AS monthly_revenue
FROM sales
GROUP BY month
ORDER BY month;

-- مع نمو شهري باستخدام LAG()
WITH m AS (
  SELECT DATE_TRUNC('month', sale_date) AS month,
         SUM(revenue) AS monthly_revenue
  FROM sales
  GROUP BY 1
)
SELECT month,
       monthly_revenue,
       monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month) AS growth
FROM m
ORDER BY month;

-- 4) Revenue by region
SELECT r.region_name, SUM(s.revenue) AS total_revenue
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN regions r   ON c.region_id   = r.region_id
GROUP BY r.region_name
ORDER BY total_revenue DESC;

-- 5) Top products by revenue
SELECT p.product_name, p.category, SUM(s.revenue) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 10;
