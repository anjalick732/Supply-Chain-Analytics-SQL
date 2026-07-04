-- ==========================================
-- SUPPLY CHAIN ANALYTICS PROJECT
-- Author: Anjali Kalas
-- Description:
-- End-to-end Supply Chain Analytics using SQL
-- ==========================================

-- ==========================================
-- DATABASE SETUP
-- ==========================================

CREATE DATABASE IF NOT EXISTS supply_chain_project;

USE supply_chain_project;

SHOW DATABASES;

-- ==========================================
-- DATA EXPLORATION
-- ==========================================

-- View total records
SELECT COUNT(*) AS TotalRecords
FROM supply_chain;

-- View first 5 rows
SELECT *
FROM supply_chain
LIMIT 5;

-- Check table structure
DESCRIBE supply_chain;

-- ==========================================
-- DATA QUALITY CHECKS
-- ==========================================

-- Check NULL SKU values
SELECT *
FROM supply_chain
WHERE SKU IS NULL;

-- Check duplicate SKUs
SELECT
SKU,
COUNT(*) AS Total
FROM supply_chain
GROUP BY SKU
HAVING COUNT(*) > 1;

-- Check negative prices
SELECT *
FROM supply_chain
WHERE Price < 0;

-- Check negative revenue
SELECT *
FROM supply_chain
WHERE `Revenue generated` < 0;

-- Check negative stock
SELECT *
FROM supply_chain
WHERE `Stock levels` < 0;

-- Check defect rate range
SELECT
MIN(`Defect rates`) AS MinDefect,
MAX(`Defect rates`) AS MaxDefect
FROM supply_chain;

-- Total Revenue
SELECT
SUM(`Revenue generated`) AS TotalRevenue
FROM supply_chain;

-- Average Price
SELECT
AVG(Price) AS AveragePrice
FROM supply_chain;

-- Stock Statistics
SELECT
MIN(`Stock levels`) AS MinimumStock,
MAX(`Stock levels`) AS MaximumStock,
AVG(`Stock levels`) AS AverageStock
FROM supply_chain;

-- ==========================================
-- BUSINESS ANALYSIS
-- ==========================================

-- Q1: Which product type generates the highest revenue?

SELECT
    `Product type`,
    SUM(`Revenue generated`) AS TotalRevenue
FROM supply_chain
GROUP BY `Product type`
ORDER BY TotalRevenue DESC;


-- Q2: Which product type sells the most units?

SELECT
    `Product type`,
    SUM(`Number of products sold`) AS TotalUnitsSold
FROM supply_chain
GROUP BY `Product type`
ORDER BY TotalUnitsSold DESC;


-- Q3: Which products have high prices but low sales?

SELECT
    SKU,
    `Product type`,
    Price,
    `Number of products sold`
FROM supply_chain
ORDER BY Price DESC,
         `Number of products sold` ASC;


-- Q4: Which products have low stock levels?

SELECT
    SKU,
    `Product type`,
    `Stock levels`
FROM supply_chain
ORDER BY `Stock levels` ASC
LIMIT 10;


-- Q5: Which products require immediate restocking?

SELECT
    SKU,
    `Product type`,
    `Stock levels`,
    `Order quantities`
FROM supply_chain
WHERE `Stock levels` < 20
ORDER BY `Stock levels` ASC;


-- Q6: Is current stock sufficient to meet demand?

SELECT
    SKU,
    `Product type`,
    `Stock levels`,
    `Order quantities`,
    CASE
        WHEN `Stock levels` >= `Order quantities`
            THEN 'Sufficient'
        ELSE 'Insufficient'
    END AS StockStatus
FROM supply_chain;

-- ==========================================
-- SUPPLIER & LOGISTICS ANALYSIS
-- ==========================================

-- Q7: Which supplier has the shortest lead time?

SELECT
    `Supplier name`,
    MIN(`Lead time`) AS ShortestLeadTime
FROM supply_chain
GROUP BY `Supplier name`
ORDER BY ShortestLeadTime ASC
LIMIT 1;


-- Q8: Which supplier has the longest lead time?

SELECT
    `Supplier name`,
    MAX(`Lead time`) AS LongestLeadTime
FROM supply_chain
GROUP BY `Supplier name`
ORDER BY LongestLeadTime DESC
LIMIT 1;


-- Q9: Which supplier contributes most to product availability?

SELECT
    `Supplier name`,
    SUM(Availability) AS TotalAvailability
FROM supply_chain
GROUP BY `Supplier name`
ORDER BY TotalAvailability DESC
LIMIT 1;


-- Q10: Which shipping carrier is the most expensive?

SELECT
    `Shipping carriers`,
    AVG(`Shipping costs`) AS AverageShippingCost
FROM supply_chain
GROUP BY `Shipping carriers`
ORDER BY AverageShippingCost DESC
LIMIT 1;


-- Q11: Which transportation mode costs the most?

SELECT
    `Transportation modes`,
    AVG(Costs) AS AverageTransportationCost
FROM supply_chain
GROUP BY `Transportation modes`
ORDER BY AverageTransportationCost DESC
LIMIT 1;


-- Q12: Which route incurs the highest logistics cost?

SELECT
    Routes,
    AVG(`Shipping costs`) AS AverageLogisticsCost
FROM supply_chain
GROUP BY Routes
ORDER BY AverageLogisticsCost DESC
LIMIT 1;


-- Q13: What is the average shipping time?

SELECT
    AVG(`Shipping times`) AS AverageShippingTime
FROM supply_chain;


-- ==========================================
-- MANUFACTURING & QUALITY ANALYSIS
-- ==========================================

-- Q14: Which products have the highest manufacturing costs?

SELECT
    SKU,
    `Product type`,
    `Manufacturing costs`
FROM supply_chain
ORDER BY `Manufacturing costs` DESC
LIMIT 5;


-- Q15: Which products have the highest defect rates?

SELECT
    SKU,
    `Product type`,
    `Defect rates`
FROM supply_chain
ORDER BY `Defect rates` DESC
LIMIT 5;


-- Q16: How do inspection results vary across products?

SELECT
    `Product type`,
    `Inspection results`,
    COUNT(*) AS TotalProducts
FROM supply_chain
GROUP BY
    `Product type`,
    `Inspection results`
ORDER BY
    `Product type`,
    TotalProducts DESC;


-- ==========================================
-- PROFITABILITY ANALYSIS
-- ==========================================

-- Q17: Which products generate high revenue but low manufacturing costs?

SELECT
    SKU,
    `Product type`,
    `Revenue generated`,
    `Manufacturing costs`
FROM supply_chain
WHERE `Revenue generated` >
      (SELECT AVG(`Revenue generated`) FROM supply_chain)
AND `Manufacturing costs` <
      (SELECT AVG(`Manufacturing costs`) FROM supply_chain)
ORDER BY `Revenue generated` DESC;


-- Q18: Which products generate high revenue but high manufacturing costs?

SELECT
    SKU,
    `Product type`,
    `Revenue generated`,
    `Manufacturing costs`
FROM supply_chain
WHERE `Revenue generated` >
      (SELECT AVG(`Revenue generated`) FROM supply_chain)
AND `Manufacturing costs` >
      (SELECT AVG(`Manufacturing costs`) FROM supply_chain)
ORDER BY `Revenue generated` DESC;


-- Q19: Which product categories should the company focus on?

SELECT
    `Product type`,
    SUM(`Revenue generated`) AS TotalRevenue,
    SUM(`Number of products sold`) AS TotalUnitsSold
FROM supply_chain
GROUP BY `Product type`
ORDER BY TotalRevenue DESC;

-- ==========================================
-- ADVANCED SQL
-- ==========================================

-- Q20: Revenue Ranking by Product Type (Window Function)

SELECT
    `Product type`,
    SUM(`Revenue generated`) AS TotalRevenue,
    RANK() OVER (
        ORDER BY SUM(`Revenue generated`) DESC
    ) AS RevenueRank
FROM supply_chain
GROUP BY `Product type`;


-- Q21: Stock Classification using CASE Statement

SELECT
    SKU,
    `Product type`,
    `Stock levels`,
    CASE
        WHEN `Stock levels` < 20 THEN 'Low Stock'
        WHEN `Stock levels` BETWEEN 20 AND 50 THEN 'Medium Stock'
        ELSE 'High Stock'
    END AS StockCategory
FROM supply_chain
ORDER BY `Stock levels` ASC;


-- Q22: Products with Above-Average Revenue (Subquery)

SELECT
    SKU,
    `Product type`,
    `Revenue generated`
FROM supply_chain
WHERE `Revenue generated` >
(
    SELECT AVG(`Revenue generated`)
    FROM supply_chain
)
ORDER BY `Revenue generated` DESC;


-- Q23: Supplier Revenue Analysis using CTE

WITH SupplierRevenue AS
(
    SELECT
        `Supplier name`,
        SUM(`Revenue generated`) AS TotalRevenue
    FROM supply_chain
    GROUP BY `Supplier name`
)

SELECT *
FROM SupplierRevenue
ORDER BY TotalRevenue DESC;