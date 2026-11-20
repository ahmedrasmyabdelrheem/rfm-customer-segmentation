/*******************************************************************************
 * SCRIPT: rfm_customer_segmentation.sql
 * AUTHOR: Ahmed Rasmy (Data & BI Analyst)
 * DESCRIPTION:
 *   Production-grade T-SQL pipeline to perform Recency, Frequency, and Monetary
 *   (RFM) behavioral customer segmentation on 12 months of transactional sales.
 *
 * PIPELINE STAGES:
 *   1. Data Consolidation (UNION ALL across 12 monthly transactional partitions)
 *   2. Base RFM Metric Calculation (Aggregating Recency, Frequency, and Monetary)
 *   3. Statistical Quintile Scoring (NTILE(5) Ranking)
 *   4. Behavioral Segmentation Logic (Classification into 6 Business Cohorts)
 *   5. Churn Risk Identification (Dedicated View for High-Value At-Risk Clients)
 *******************************************************************************/

USE [master]; -- Adjust database name as needed
GO

-- =============================================================================
-- STAGE 1: DATA CONSOLIDATION
-- Consolidate 12 monthly transactional logs (2025-01 through 2025-12)
-- =============================================================================

IF OBJECT_ID('dbo.sales', 'U') IS NOT NULL
    DROP TABLE dbo.sales;
GO

SELECT * 
INTO dbo.sales
FROM (
    SELECT * FROM dbo.[202501]
    UNION ALL SELECT * FROM dbo.[202502]
    UNION ALL SELECT * FROM dbo.[202503]
    UNION ALL SELECT * FROM dbo.[202504]
    UNION ALL SELECT * FROM dbo.[202505]
    UNION ALL SELECT * FROM dbo.[202506]
    UNION ALL SELECT * FROM dbo.[202507]
    UNION ALL SELECT * FROM dbo.[202508]
    UNION ALL SELECT * FROM dbo.[202509]
    UNION ALL SELECT * FROM dbo.[202510]
    UNION ALL SELECT * FROM dbo.[202511]
    UNION ALL SELECT * FROM dbo.[202512]
) AS consolidated_sales;
GO

-- Create index to optimize customer aggregation
CREATE NONCLUSTERED INDEX IX_sales_CustomerID_OrderDate 
ON dbo.sales (CustomerID, OrderDate) 
INCLUDE (OrderValue);
GO


-- =============================================================================
-- STAGE 2: BASE RFM METRIC COMPUTATION
-- Calculates:
--   - Recency: Days elapsed between latest purchase and analysis cutoff date
--   - Frequency: Total distinct transaction count
--   - Monetary: Total historical expenditure per customer
-- =============================================================================

IF OBJECT_ID('dbo.rfm_metrics', 'V') IS NOT NULL
    DROP VIEW dbo.rfm_metrics;
GO

CREATE VIEW dbo.rfm_metrics AS
WITH CutoffDate AS (
    -- Set fixed analysis anchor date representing the end of the fiscal year
    SELECT CAST('2025-12-31' AS DATE) AS analysis_date
),
CustomerAggregations AS (
    SELECT 
        s.CustomerID,
        MAX(s.OrderDate) AS last_order_date,
        DATEDIFF(day, MAX(s.OrderDate), cd.analysis_date) AS recency,
        COUNT(1) AS frequency,
        ROUND(SUM(s.OrderValue), 2) AS monetary
    FROM dbo.sales s
    CROSS JOIN CutoffDate cd
    GROUP BY s.CustomerID, cd.analysis_date
)
SELECT 
    CustomerID,
    last_order_date,
    recency,
    frequency,
    monetary
FROM CustomerAggregations;
GO


-- =============================================================================
-- STAGE 3: QUINTILE SCORING (1 to 5)
-- Using NTILE(5) statistical distribution:
--   - Recency Score 5: Most recent purchasers (lower recency days = higher score)
--   - Frequency Score 5: Most frequent purchasers
--   - Monetary Score 5: Highest spenders
-- =============================================================================

IF OBJECT_ID('dbo.rfm_score', 'V') IS NOT NULL
    DROP VIEW dbo.rfm_score;
GO

CREATE VIEW dbo.rfm_score AS
SELECT 
    CustomerID,
    recency,
    frequency,
    monetary,
    NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
    NTILE(5) OVER (ORDER BY frequency ASC) AS frequency_score,
    NTILE(5) OVER (ORDER BY monetary ASC) AS monetary_score
FROM dbo.rfm_metrics;
GO


-- =============================================================================
-- STAGE 4: RFM CELL & TOTAL COMPOSITE SCORE
-- =============================================================================

IF OBJECT_ID('dbo.rfm_total_scores', 'V') IS NOT NULL
    DROP VIEW dbo.rfm_total_scores;
GO

CREATE VIEW dbo.rfm_total_scores AS
SELECT 
    CustomerID,
    recency,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    (recency_score + frequency_score + monetary_score) AS rfm_total,
    CONCAT(recency_score, frequency_score, monetary_score) AS rfm_cell
FROM dbo.rfm_score;
GO


-- =============================================================================
-- STAGE 5: BEHAVIORAL COHORT CLASSIFICATION
-- Maps RFM score permutations into actionable commercial customer tiers
-- =============================================================================

IF OBJECT_ID('dbo.rfm_segments_final', 'U') IS NOT NULL
    DROP TABLE dbo.rfm_segments_final;
GO

SELECT 
    CustomerID,
    recency,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    rfm_total,
    rfm_cell,
    CASE 
        WHEN recency_score >= 4 AND frequency_score >= 4 THEN 'Champions'
        WHEN recency_score >= 3 AND frequency_score >= 4 THEN 'Loyal Customers'
        WHEN recency_score >= 4 AND frequency_score <= 2 THEN 'New Customers'
        WHEN recency_score >= 3 AND frequency_score BETWEEN 2 AND 3 THEN 'Potential Loyalists'
        WHEN recency_score <= 2 AND frequency_score >= 3 THEN 'At Risk'
        WHEN recency_score <= 2 AND frequency_score <= 2 THEN 'Hibernating'
        ELSE 'Others'
    END AS segment
INTO dbo.rfm_segments_final
FROM dbo.rfm_total_scores;
GO


-- =============================================================================
-- STAGE 6: HIGH-PRIORITY CHURN MITIGATION VIEW
-- Isolates former high spenders who haven't ordered recently
-- =============================================================================

IF OBJECT_ID('dbo.AtRisk_HighValue_Customers', 'V') IS NOT NULL
    DROP VIEW dbo.AtRisk_HighValue_Customers;
GO

CREATE VIEW dbo.AtRisk_HighValue_Customers AS 
SELECT 
    CustomerID,
    recency,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    rfm_cell,
    segment
FROM dbo.rfm_segments_final
WHERE recency_score IN (1, 2) 
  AND monetary_score IN (4, 5);
GO


-- =============================================================================
-- STAGE 7: EXECUTIVE VALIDATION QUERIES
-- =============================================================================

-- 1. Cohort Summary & Distribution
SELECT 
    segment,
    COUNT(1) AS total_customers,
    ROUND(AVG(recency), 1) AS avg_recency_days,
    ROUND(AVG(frequency), 1) AS avg_orders,
    ROUND(AVG(monetary), 2) AS avg_spend,
    ROUND(SUM(monetary), 2) AS total_segment_revenue,
    ROUND(SUM(monetary) * 100.0 / SUM(SUM(monetary)) OVER (), 2) AS revenue_contribution_pct
FROM dbo.rfm_segments_final
GROUP BY segment
ORDER BY total_segment_revenue DESC;

-- 2. Urgent Churn Action List
SELECT * 
FROM dbo.AtRisk_HighValue_Customers
ORDER BY monetary DESC;
GO
