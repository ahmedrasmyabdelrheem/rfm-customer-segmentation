# Customer Behavioral Segmentation & RFM Analysis

## 📌 Project Overview
Customer retention and targeted marketing are critical for sustainable business growth. This project focuses on analyzing 12 months of transactional sales data to evaluate customer purchasing behavior, score customers using the **Recency, Frequency, and Monetary (RFM)** framework, and classify them into strategic behavioral cohorts.

The final deliverables include an optimized **T-SQL data pipeline** and an interactive **Power BI dashboard** enabling marketing stakeholders to uncover high-value champions, identify at-risk customers, and deploy data-driven retention campaigns.

---

## 🎯 Business Problem & Objectives
- **Lack of Visibility:** The business treated all customers uniformly without identifying purchase recency or lifetime value.
- **Churn Risk:** Customers were quietly churning without early warning indicators.
- **Objective:** Segment 287 active customers into behavioral segments to optimize marketing spend and enhance customer lifetime value (CLV).

---

## 🏗️ Technical Architecture & Pipeline

```text
[Raw Transaction Logs] 
         ↓
[SQL Server / T-SQL Transformation]
  - UNION ALL consolidation across 12 monthly tables
  - Date parsing & aggregation per customer
  - NTILE(5) scoring for Recency, Frequency, and Monetary metrics
         ↓
[Analytical Views & Segment Logic]
  - Multi-tier CASE WHEN cohort classification (11 segments)
         ↓
[Power BI Analytical Layer]
  - Star Schema dimensional model
  - Dynamic DAX measures & Cohort drill-downs
  - Interactive executive dashboard
