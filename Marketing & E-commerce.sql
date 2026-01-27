/* =========================================================
   PROJECT: Marketing & E-commerce Analytics
   AUTHOR: Data Analyst Portfolio Project
   PURPOSE:
   - Build clean analytical tables
   - Validate data quality
   - Answer real business questions on
     customers, revenue, funnels, campaigns, and experiments
========================================================= */

-- =========================================================
-- DATABASE SETUP
-- Purpose: Create and activate project database
-- =========================================================
CREATE DATABASE Marketing_ecommerce;
USE Marketing_ecommerce;

-- =========================================================
-- DIMENSION TABLES
-- =========================================================

-- Products table
-- Purpose: Store product master data used for category,
-- pricing, and revenue analysis
CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  category VARCHAR(50) NOT NULL,
  brand VARCHAR(50),
  base_price FLOAT,
  launch_date DATE,
  is_premium INT        -- 1 = premium product, 0 = non-premium
);

-- Customers table
-- Purpose: Customer demographics and acquisition details
-- used for cohort, segmentation, and retention analysis
CREATE TABLE Customers (
  customer_id INT PRIMARY KEY,
  signup_date DATE,
  country VARCHAR(10),
  age SMALLINT,
  gender VARCHAR(20),
  loyalty_tier VARCHAR(50),
  acquisition_channel VARCHAR(50)
);

-- Campaigns table
-- Purpose: Marketing campaign metadata to measure
-- campaign performance and uplift
CREATE TABLE Campaigns (
  campaign_id INT PRIMARY KEY,
  channel VARCHAR(50),
  objective VARCHAR(50),
  start_date DATE,
  end_date DATE,
  target_segment VARCHAR(50),
  expected_uplift DECIMAL
);

-- =========================================================
-- FACT TABLES
-- =========================================================

-- Transactions table
-- Purpose: Stores order-level revenue data for sales,
-- AOV, refunds, and customer value analysis
CREATE TABLE Transactions (
  transaction_id INT,
  transaction_time VARCHAR(50),   -- raw string (to be converted)
  customer_id INT,
  product_id INT,
  quantity INT,
  discount_applied DECIMAL(5,2),
  gross_revenue DECIMAL(6,2),
  campaign_id INT,
  refund_flag INT                 -- 1 = refunded, 0 = successful
);

-- Events table
-- Purpose: User behavior tracking (clickstream)
-- used for funnel, engagement, experiment analysis
CREATE TABLE Events (
  event_id INT AUTO_INCREMENT PRIMARY KEY,
  event_time VARCHAR(50),          -- raw string timestamp
  customer_id INT NULL,
  session_id INT NULL,
  event_type VARCHAR(50),          -- visit, view, add_to_cart, purchase
  product_id VARCHAR(20),
  device_type VARCHAR(50),
  traffic_source VARCHAR(50),
  campaign_id INT NULL,
  page_category VARCHAR(20),
  session_duration_sec VARCHAR(20),
  experiment_group VARCHAR(50)
);

-- =========================================================
-- DATA TYPE CLEANING & STANDARDIZATION
-- =========================================================

-- Improve precision of expected uplift
ALTER TABLE campaigns
MODIFY expected_uplift DECIMAL(5,3);

-- Add proper datetime column for events
ALTER TABLE events
ADD COLUMN event_time_dt DATETIME;

SET SQL_SAFE_UPDATES = 0;

-- Convert string timestamp → DATETIME
UPDATE events
SET event_time_dt = STR_TO_DATE(event_time, '%d-%m-%Y %H:%i');

-- Convert session duration to numeric
ALTER TABLE events
MODIFY session_duration_sec DECIMAL(6,2);

-- Clean invalid product_id values
UPDATE events
SET product_id = NULL
WHERE product_id = 'Null';

ALTER TABLE events
MODIFY product_id INT NULL;

-- Add proper datetime for transactions
ALTER TABLE transactions
ADD COLUMN transaction_time_dt DATETIME;

UPDATE transactions
SET transaction_time_dt = STR_TO_DATE(transaction_time, '%d-%m-%Y %H:%i');

SET SQL_SAFE_UPDATES = 1;

-- =========================================================
-- BASIC DATA VALIDATION
-- Purpose: Understand table sizes and data completeness
-- =========================================================

SELECT COUNT(*) AS campaigns_cnt FROM campaigns;
SELECT COUNT(*) AS customers_cnt FROM customers;
SELECT COUNT(*) AS events_cnt FROM events;
SELECT COUNT(*) AS products_cnt FROM products;
SELECT COUNT(*) AS transactions_cnt FROM transactions;

-- =========================================================
-- DATE RANGE CHECKS (Data Coverage)
-- =========================================================

-- Event data coverage
SELECT
  MIN(event_time_dt) AS min_event_time,
  MAX(event_time_dt) AS max_event_time
FROM events;

-- Transaction data coverage
SELECT
  MIN(transaction_time_dt) AS min_txn_time,
  MAX(transaction_time_dt) AS max_txn_time
FROM transactions;

-- =========================================================
-- DATA QUALITY CHECKS
-- =========================================================

-- Check missing critical fields in events
SELECT
  SUM(customer_id IS NULL) AS null_customers,
  SUM(session_id IS NULL) AS null_sessions,
  SUM(event_type IS NULL) AS null_events
FROM events;

-- Duplicate event_id check
SELECT event_id, COUNT(*) 
FROM events
GROUP BY event_id
HAVING COUNT(*) > 1;

-- Orphan transactions (no matching customer)
SELECT COUNT(*) AS orphan_transactions
FROM transactions t
LEFT JOIN customers c
  ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Orphan events (no matching customer)
SELECT COUNT(*) AS orphan_events
FROM events e
LEFT JOIN customers c
  ON e.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- =========================================================
-- CORE BUSINESS KPIs
-- =========================================================

-- Total customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Total products & average base price
SELECT
  COUNT(*) AS total_products,
  AVG(base_price) AS avg_price
FROM products;

-- Total revenue (excluding refunds)
SELECT SUM(gross_revenue) AS total_revenue
FROM transactions
WHERE refund_flag = 0;

-- Active customers (users with at least one event)
SELECT COUNT(DISTINCT customer_id) AS active_customers
FROM events;

-- =========================================================
-- CUSTOMER GROWTH ANALYSIS
-- =========================================================

-- Monthly signup trend
SELECT
  DATE_FORMAT(signup_date, '%Y-%m') AS month,
  COUNT(*) AS new_customers
FROM customers
GROUP BY month
ORDER BY month;

-- =========================================================
-- PRODUCT & SALES ANALYSIS
-- =========================================================

-- Product distribution by category
SELECT
  category,
  COUNT(*) AS product_count
FROM products
GROUP BY category;

-- Orders, revenue, and AOV
SELECT
  SUM(gross_revenue) AS total_revenue,
  COUNT(DISTINCT transaction_id) AS total_orders,
  SUM(gross_revenue) / COUNT(DISTINCT transaction_id) AS aov
FROM transactions
WHERE refund_flag = 0;

-- =========================================================
-- USER BEHAVIOR ANALYSIS
-- =========================================================

-- Users per event type
SELECT
  event_type,
  COUNT(DISTINCT customer_id) AS users
FROM events
GROUP BY event_type;

-- Funnel using ordered events
-- Purpose: Understand sequential user journey
WITH ordered_events AS (
  SELECT
    customer_id,
    event_type,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY event_time_dt
    ) AS rn
  FROM events
)
SELECT
  COUNT(DISTINCT CASE WHEN rn=1 AND event_type='visit' THEN customer_id END) AS visits,
  COUNT(DISTINCT CASE WHEN rn=2 AND event_type='view' THEN customer_id END) AS views,
  COUNT(DISTINCT CASE WHEN rn=3 AND event_type='add_to_cart' THEN customer_id END) AS carts,
  COUNT(DISTINCT CASE WHEN rn=4 AND event_type='purchase' THEN customer_id END) AS purchases
FROM ordered_events;

-- Funnel (presence-based)
WITH funnel AS (
  SELECT
    customer_id,
    MAX(event_type='visit') AS visit,
    MAX(event_type='view') AS view,
    MAX(event_type='add_to_cart') AS cart,
    MAX(event_type='purchase') AS purchase
  FROM events
  GROUP BY customer_id
)
SELECT
  SUM(visit) AS visits,
  SUM(view) AS views,
  SUM(cart) AS carts,
  SUM(purchase) AS purchases
FROM funnel;

-- =========================================================
-- ENGAGEMENT ANALYSIS
-- =========================================================

-- Avg session duration by device
SELECT
  device_type,
  AVG(session_duration_sec) AS avg_session_sec
FROM events
GROUP BY device_type;

-- Bounce analysis by page
SELECT
  page_category,
  COUNT(*) AS bounce_events
FROM events
WHERE event_type='bounce'
GROUP BY page_category;

-- =========================================================
-- A/B TESTING & EXPERIMENT ANALYSIS
-- =========================================================

-- Conversion rate by experiment group
WITH users AS (
  SELECT DISTINCT customer_id, experiment_group
  FROM events
),
conversions AS (
  SELECT DISTINCT customer_id
  FROM transactions
  WHERE refund_flag = 0
)
SELECT
  u.experiment_group,
  COUNT(DISTINCT c.customer_id) AS converted_users,
  COUNT(DISTINCT u.customer_id) AS total_users,
  COUNT(DISTINCT c.customer_id) / COUNT(DISTINCT u.customer_id) AS conversion_rate
FROM users u
LEFT JOIN conversions c
  ON u.customer_id = c.customer_id
GROUP BY u.experiment_group;

-- Revenue by experiment group
SELECT
  e.experiment_group,
  SUM(t.gross_revenue) AS revenue
FROM events e
JOIN transactions t
  ON e.customer_id = t.customer_id
WHERE t.refund_flag = 0
GROUP BY e.experiment_group;

-- =========================================================
-- REVENUE TREND ANALYSIS
-- =========================================================

-- Month-over-month revenue growth
WITH monthly AS (
  SELECT
    DATE_FORMAT(transaction_time_dt, '%Y-%m') AS month,
    SUM(gross_revenue) AS revenue
  FROM transactions
  WHERE refund_flag = 0
  GROUP BY month
)
SELECT
  month,
  revenue,
  revenue - LAG(revenue) OVER (ORDER BY month) AS mom_change,
  (revenue - LAG(revenue) OVER (ORDER BY month))
    / LAG(revenue) OVER (ORDER BY month) * 100 AS mom_growth_pct
FROM monthly;

-- =========================================================
-- SEGMENTATION ANALYSIS
-- =========================================================

-- Revenue by loyalty tier
SELECT
  c.loyalty_tier,
  SUM(t.gross_revenue) AS revenue
FROM customers c
JOIN transactions t
  ON c.customer_id = t.customer_id
WHERE t.refund_flag = 0
GROUP BY c.loyalty_tier;

-- Revenue & discount by product category
SELECT
  p.category,
  SUM(t.gross_revenue) AS revenue,
  AVG(t.discount_applied) AS avg_discount
FROM transactions t
JOIN products p
  ON t.product_id = p.product_id
WHERE t.refund_flag = 0
GROUP BY p.category;

-- =========================================================
-- DATA CONSISTENCY CHECKS (Events vs Transactions)
-- =========================================================

-- Transactions without events
SELECT COUNT(*)
FROM transactions t
LEFT JOIN events e
  ON t.customer_id = e.customer_id
WHERE e.customer_id IS NULL;

-- Events without transactions
SELECT COUNT(DISTINCT e.customer_id)
FROM events e
LEFT JOIN transactions t
  ON e.customer_id = t.customer_id
WHERE t.customer_id IS NULL;

-- =========================================================
-- ANALYTICAL VIEWS
-- Purpose: Simplify downstream BI & reporting
-- =========================================================

CREATE VIEW vw_events AS
SELECT
  event_id,
  event_time_dt AS event_time,
  customer_id,
  session_id,
  event_type,
  product_id,
  device_type,
  traffic_source,
  campaign_id,
  page_category,
  session_duration_sec,
  experiment_group
FROM events;

CREATE VIEW vw_transactions AS
SELECT
  transaction_id,
  transaction_time_dt AS transaction_time,
  customer_id,
  product_id,
  quantity,
  discount_applied,
  gross_revenue,
  campaign_id,
  refund_flag
FROM transactions;

CREATE VIEW vw_customers  AS SELECT * FROM customers;
CREATE VIEW vw_products   AS SELECT * FROM products;
CREATE VIEW vw_campaigns  AS SELECT * FROM campaigns;
