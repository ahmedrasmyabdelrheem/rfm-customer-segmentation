# 📊 Customer Behavioral Segmentation & RFM Value Optimization

[![SQL Server](https://img.shields.io/badge/Database-SQL_Server_2022-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white)](#)
[![T-SQL](https://img.shields.io/badge/Language-T--SQL-00599C?style=flat-square)](#)
[![Power BI](https://img.shields.io/badge/Visualization-Power_BI_Desktop-F2C811?style=flat-square&logo=powerbi&logoColor=black)](#)
[![DAX](https://img.shields.io/badge/Analytics-DAX-205493?style=flat-square)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)

---

## 1. 📌 Project Title
**Customer Behavioral Segmentation & RFM Value Optimization**

---

## 2. 📖 Project Overview
This project delivers an end-to-end customer intelligence solution designed to segment commercial accounts based on their historical transaction dynamics. Leveraging a robust **T-SQL data pipeline** and an interactive **Power BI dashboard**, the project ingests and standardizes 12 months of transactional sales data, scores customers using the statistical **RFM (Recency, Frequency, Monetary)** model, and classifies them into strategic behavioral cohorts. The final deliverables empower commercial directors and marketing leads to prioritize high-value accounts, prevent silent customer churn, and reallocate promotional budgets with precision.

---

## 3. 🎯 Business Problem
A mid-sized retail enterprise operated with a uniform commercial strategy, distributing generic discounts and promotional materials equally across all accounts. This untargeted approach led to several critical inefficiencies:
* **Promotional Margin Erosion:** Offering unnecessary 10%–20% discounts to habitual, price-insensitive buyers who would have purchased at standard pricing.
* **Undetected Customer Churn:** High-value accounts quietly lapsed into inactivity without triggering alerts or intervention from sales managers.
* **Wasted Marketing Capital:** Continued direct mail and advertising spend directed toward dormant accounts with near-zero conversion probability.

---

## 4. 🚀 Project Objectives
1. **Centralize Disparate Logs:** Consolidate 12 monthly transactional partitions into an indexed analytical fact table.
2. **Quantify Behavioral Metrics:** Calculate precise Recency (days since last purchase), Frequency (order count), and Monetary (total spend) values per customer.
3. **Statistical Scoring:** Assign standardized 1–5 quintile scores using statistical distribution functions.
4. **Behavioral Cohort Classification:** Group 287 active commercial accounts into 6 distinct tiers (*Champions, Loyal Customers, Potential Loyalists, New Customers, At-Risk, Hibernating*).
5. **Actionable Commercial Strategy:** Deliver an executive dashboard and playbook outlining targeted retention and revenue-growth tactics for each segment.

---

## 5. 📂 Dataset Description and Source
* **Data Source:** Enterprise transactional sales logs partitioned across 12 monthly database tables (`dbo.[202501]` through `dbo.[202512]`).
* **Timeframe:** Full fiscal year 2025 (January 1, 2025 – December 31, 2025).
* **Scope:** 287 unique customer accounts with multi-thousand transactional line items.
* **Key Attributes:**
  * `CustomerID`: Unique customer identifier.
  * `OrderDate`: Timestamp of order fulfillment.
  * `OrderValue`: Gross monetary revenue per order.
* **Cleaning & Assumptions:**
  * Fixed analysis cutoff anchor set to **`2025-12-31`** via Common Table Expressions (CTEs) to ensure standardized recency calculation across all customer records.
  * Handled multi-month reconciliation via `UNION ALL` with non-clustered indexing on `(CustomerID, OrderDate)` for performance optimization.

---

## 6. 🛠️ Tools and Technologies
* **Database & Transformation:** Microsoft SQL Server 2022, T-SQL (Common Table Expressions, `UNION ALL`, `NTILE(5)` Window Functions, Analytical Views).
* **Business Intelligence & Reporting:** Microsoft Power BI Desktop, DAX (Data Analysis Expressions).
* **Data Modeling:** Relational Star Schema semantic layer.
* **Version Control:** Git & GitHub.

---

## 7. 🔄 Project Workflow

```text
┌────────────────────────┐      ┌────────────────────────┐      ┌────────────────────────┐
│  12 Monthly Tables     │      │   Base RFM Metrics     │      │  Quintile Scoring      │
│  (dbo.[202501..202512])│ ──►  │   (DATEDIFF, COUNT,    │ ──►  │  (NTILE(5) Scoring     │
│  UNION ALL Pipeline    │      │    SUM OrderValue)     │      │   R, F, M: 1 to 5)     │
└────────────────────────┘      └────────────────────────┘      └────────────────────────┘
                                                                             │
┌────────────────────────┐      ┌────────────────────────┐                   ▼
│   Power BI Dashboard   │      │  At-Risk Watchlist     │      ┌────────────────────────┐
│   Interactive Slicers  │ ◄──  │  (Recency 1-2 &        │ ◄──  │  Behavioral Cohorts    │
│   & Executive Visuals  │      │   Monetary 4-5)        │      │  (CASE WHEN Logic)     │
└────────────────────────┘      └────────────────────────┘      └────────────────────────┘
```

---

## 8. 📁 Repository Structure

```text
rfm-customer-segmentation/
├── README.md                           # Executive business documentation
├── .gitignore                          # Standard git exclusions (temporary and cache files)
├── sql/
│   └── rfm_customer_segmentation.sql   # Production-ready T-SQL pipeline script
├── dashboards/
│   └── RFM Dashboard.pbix              # Interactive Power BI report file
└── images/
    ├── rfm_dashboard_hero.png          # High-resolution executive dashboard preview
    └── rfm_dashboard_overview.png      # Segmentation matrix and distribution view
```

---

## 9. 🔬 Analysis and Methodology

The segmentation methodology relies on statistical quintile scoring:
1. **Recency Metric:** Days elapsed between the customer's most recent transaction and `2025-12-31`.
2. **Frequency Metric:** Total number of distinct completed orders within the 12-month window.
3. **Monetary Metric:** Total net revenue generated by the customer.
4. **Scoring via `NTILE(5)`:**
   * Recency scored in reverse (`ORDER BY recency DESC`) so recent shoppers receive Score 5.
   * Frequency and Monetary scored ascending (`ORDER BY frequency ASC`, `ORDER BY monetary ASC`) where high activity receives Score 5.
5. **Cohort Assignment Logic:**
   * **Champions:** `R >= 4 AND F >= 4` (Recent, frequent, high-spend accounts).
   * **Loyal Customers:** `R >= 3 AND F >= 4` (Steady recurring purchasers).
   * **Potential Loyalists:** `R >= 3 AND F BETWEEN 2 AND 3` (Growing engagement).
   * **New Customers:** `R >= 4 AND F <= 2` (Recent first-time or second-time buyers).
   * **At Risk:** `R <= 2 AND F >= 3` (Former regulars who have stopped ordering).
   * **Hibernating:** `R <= 2 AND F <= 2` (Lapsed, low-frequency, low-spend accounts).

---

## 10. 📊 Key KPIs & Metrics
* **Total Customers Analyzed:** **287 Accounts**
* **Time Horizon:** **12 Months (Fiscal Year 2025)**
* **Champions & Loyal Volume Share:** **~35% of total customer base**
* **Champions & Loyal Revenue Contribution:** **~62% of gross company revenue**
* **At-Risk High-Value Accounts Identified:** Accounts with Monetary Scores 4–5 and Recency Scores 1–2 (targeted for emergency intervention).

---

## 11. 💡 Key Findings and Business Insights

### 🔍 Finding 1: Top 35% of Accounts Account for 62% of Enterprise Gross Revenue
![RFM Overview](images/rfm_dashboard_overview.png)
* **Observation:** The top tiers (*Champions* and *Loyal Customers*) represent slightly more than a third of accounts but generate nearly two-thirds of all revenue.
* **Root Cause:** Operational reliability and high satisfaction create strong habitual reordering patterns.
* **Business Impact:** Offering indiscriminate price discounts to this group unnecessarily erodes company gross margin without stimulating new demand.

---

### ⚠️ Finding 2: High-Value "At Risk" Defection Represents a Significant Revenue Hazard
![RFM Dashboard Hero](images/rfm_dashboard_hero.png)
* **Observation:** Multiple accounts with historical order values exceeding $150–$200+ have surpassed 90–120 days without placing an order.
* **Root Cause:** Post-purchase disengagement, unaddressed service friction, or aggressive competitor outreach.
* **Business Impact:** Losing even 5–10 of these top-tier accounts causes far greater revenue decline than losing dozens of one-time shoppers.

---

### 💤 Finding 3: Dormant "Hibernating" Accounts Siphon Performance Marketing Spend
* **Observation:** Accounts with Recency ≤ 2 and Frequency ≤ 2 have been inactive for over 6 months with only a single historical order.
* **Root Cause:** Opportunistic buyers attracted by historical clearance sales with zero brand commitment.
* **Business Impact:** Continued paid retargeting produces a negative marketing ROI.

---

## 12. 🎯 Business Recommendations & Playbook

| Customer Cohort | Strategic Goal | Tactical Playbook | Lead Owner | Expected Business ROI |
| :--- | :--- | :--- | :--- | :--- |
| **🏆 Champions** | Retain & Maximize LTV | Enroll in VIP advisory circle; exclusive previews; zero discount dilution. | Commercial Sales / VIP Lead | +10% increase in annual order frequency. |
| **🤝 Loyal Customers** | Cross-Category Expansion | Targeted cross-sell promotions based on historical category affinity. | Merchandising & Marketing | +15% expansion in product category penetration. |
| **⚠️ At Risk (High Value)** | Emergency Churn Intervention | Personal outreach by dedicated Account Executive; customer satisfaction audit; tailored re-engagement bundle. | Sales Director & Customer Success | Prevent 25% of imminent customer defections. |
| **🌱 New Customers** | Accelerate 2nd Order Velocity | Automated 3-part email welcome workflow triggered within 14 days of first delivery. | Lifecycle Marketing Team | +22% conversion from 1st-time to 2nd-time buyer. |
| **💤 Hibernating** | Low-Cost Automation or Pruning | Transition to low-cost quarterly email newsletter; suppress from paid ad lists. | Performance Marketing | -30% reduction in wasted ad spend. |

---

## 13. 🖼️ Dashboard Preview

### Executive Overview & Cohort Matrix
![RFM Dashboard Overview](images/rfm_dashboard_overview.png)

### Cohort Distribution & Metric Cards
![RFM Dashboard Hero](images/rfm_dashboard_hero.png)

---

## 14. 🚀 How to Run the Project

### Prerequisites
* Microsoft SQL Server 2017+ (or Azure SQL Database)
* SQL Server Management Studio (SSMS) or Azure Data Studio
* Microsoft Power BI Desktop

### Execution Steps
1. **Database Setup:**
   * Open SSMS and connect to your SQL Server instance.
   * Verify that monthly transaction tables (`202501` through `202512`) are loaded in your database.
2. **Run Pipeline Script:**
   * Open and execute [`sql/rfm_customer_segmentation.sql`](sql/rfm_customer_segmentation.sql).
   * The script builds the unified `dbo.sales` table, calculation views, and final `dbo.rfm_segments_final` table.
3. **Launch Power BI Dashboard:**
   * Open [`dashboards/RFM Dashboard.pbix`](dashboards/RFM%20Dashboard.pbix) in Power BI Desktop.
   * Under `Home -> Transform Data -> Data Source Settings`, update the server name to point to your local SQL Server instance.
   * Click **Close & Apply** to refresh the visual dashboard with your live data.

---

## 15. ⚠️ Limitations
* **Historical Time Horizon:** Analysis is bounded to a 12-month period (2025); multi-year macroeconomic seasonality is not captured.
* **Lack of Qualitative Feedback:** Transactional data does not include customer sentiment, Net Promoter Score (NPS), or service ticket logs.
* **Simulated Environment:** Dataset is structured for demonstration purposes based on simulated retail transaction patterns.

---

## 👤 Author & Contact

**Ahmed Rasmy**  
*Data & Business Intelligence Analyst*  
- 🌐 **Interactive Portfolio:** [ahmedrasmyabdelrheem.github.io](https://ahmedrasmyabdelrheem.github.io/)  
- 💼 **LinkedIn:** [linkedin.com/in/ahmedrasmyabdelrheem](https://www.linkedin.com/in/ahmedrasmyabdelrheem)  
- ✉️ **Email:** [ahmed.rasmy.abdelrheem@gmail.com](mailto:ahmed.rasmy.abdelrheem@gmail.com)  
- 📄 **Resume / CV:** [Download CV](https://ahmedrasmyabdelrheem.github.io/assets/Ahmed_Rasmy_CV.pdf)
