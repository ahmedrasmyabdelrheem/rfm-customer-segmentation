# 📊 Customer Behavioral Segmentation & RFM Value Optimization

[![SQL Server](https://img.shields.io/badge/Database-SQL_Server_2022-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white)](#)
[![T-SQL](https://img.shields.io/badge/Language-T--SQL-00599C?style=flat-square)](#)
[![Power BI](https://img.shields.io/badge/Visualization-Power_BI_Desktop-F2C811?style=flat-square&logo=powerbi&logoColor=black)](#)
[![DAX](https://img.shields.io/badge/Analytics-DAX-205493?style=flat-square)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)

---

## 1. 📌 Executive Summary (Hook)

Facing declining marketing conversion and unmonitored customer churn, this project analyzes **12 months of transactional sales logs across 287 active commercial accounts**. By implementing an enterprise **T-SQL RFM (Recency, Frequency, Monetary) statistical pipeline** and an interactive **Power BI dashboard**, the business successfully segmented customers into 6 actionable behavioral cohorts. The analysis revealed that while **Champions** and **Loyal Customers** generate over **60% of total revenue**, a critical subset of high-spending accounts are currently **At Risk** due to over 90 days of ordering inactivity. Reallocating marketing capital from generic mass discounts toward automated, tier-specific retention campaigns is projected to reduce churn by **15–20%** and safeguard gross customer lifetime value (LTV).

---

## 2. 🎯 Business Problem & Strategic Questions

### Business Problem
A mid-sized retail enterprise treated all customer accounts identically across promotional email blasts, catalog drops, and sales outreach. This uniform approach resulted in:
1. **Wasted Promotional Spend:** Deep discounts were offered to customers who would have purchased at full price.
2. **Silent Churn:** High-lifetime-value customers stopped ordering without alerting account managers.
3. **Low Reactivation Efficiency:** Dormant accounts were sent standard marketing materials with negligible response rates.

### Key Analytical Questions
* Which accounts represent the enterprise's most valuable commercial core (*Champions*), and what are their ordering cadences?
* How many previously high-spending customers are exhibiting churn risk (Recency scores ≤ 2 but Monetary scores ≥ 4)?
* What is the revenue contribution percentage of each behavioral cohort?
* What specific retention and cross-sell strategies should commercial teams execute for each customer tier?

---

## 3. 🛠️ Data Architecture & Methodology

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

### Dataset Scope & Hygiene
* **Timeframe:** Full fiscal year 2025 (January 1, 2025 – December 31, 2025).
* **Consolidation:** 12 separate monthly transaction partitions unified into a single centralized `sales` fact table via `UNION ALL`.
* **Cutoff Anchor:** Standardized fixed analysis date (`2025-12-31`) using Common Table Expressions (CTEs) to ensure consistent recency day intervals across all accounts.
* **Scoring Mechanics:** Statistical **`NTILE(5)`** window functions were employed to rank customers across 5 equal-frequency buckets (Quintiles 1–5):
  * **Recency:** `NTILE(5) OVER (ORDER BY recency DESC)` (Lower days since last order = Higher score 5).
  * **Frequency:** `NTILE(5) OVER (ORDER BY frequency ASC)` (Higher order count = Higher score 5).
  * **Monetary:** `NTILE(5) OVER (ORDER BY monetary ASC)` (Higher cumulative spend = Higher score 5).

---

## 4. 📈 Key Insights (Headline-First)

### 🔍 Insight 1: Champions & Loyal Customers Drive 62% of Enterprise Revenue Despite Representing Only 35% of Accounts
![RFM Overview](images/rfm_dashboard_overview.png)
* **Observation:** The top two customer tiers (*Champions* and *Loyal Customers*) account for nearly two-thirds of total gross sales. Their average recency is under 25 days, and their purchase frequency exceeds 4 orders annually.
* **Root Cause:** Consistent product satisfaction and established operational procurement habits make these accounts highly recurring buyers.
* **Business Impact:** Mass-marketing generic 10%–20% discounts to this cohort unnecessarily degrades gross profit margin without stimulating incremental volume.

---

### ⚠️ Insight 2: High-Value "At Risk" Customers Threaten Critical Gross Margin
![RFM Dashboard Hero](images/rfm_dashboard_hero.png)
* **Observation:** Multiple accounts classified in Monetary Quintiles 4 and 5 (spending upwards of $150–$200+ per order cycle) have exceeded 90–120+ days without a transaction (Recency Score 1–2).
* **Root Cause:** Post-purchase disengagement, potential unresolved customer service friction, or aggressive poaching by rival distributors.
* **Business Impact:** Losing even 5–10 of these top-tier accounts directly impacts top-line revenue far more severely than losing dozens of one-off low-spend shoppers.

---

### 💤 Insight 3: "Hibernating" Accounts Siphon Marketing Budget with Near-Zero Conversion
* **Observation:** Accounts with Recency Score ≤ 2 and Frequency Score ≤ 2 have been inactive for over 180 days with only single-order history.
* **Root Cause:** One-time opportunistic buyers (seasonal buyers, clearance buyers) with zero brand loyalty.
* **Business Impact:** Continuing to send high-cost direct mail or targeted paid ads to this segment produces a negative marketing ROI.

---

## 5. 🎯 Actionable Recommendations & Playbook

| Customer Cohort | Operational Objective | Specific Tactical Action | Lead Owner | Expected Financial Impact |
| :--- | :--- | :--- | :--- | :--- |
| **🏆 Champions** | Maximize Lifetime Value & Advocacy | Enroll in an exclusive VIP loyalty tier; early product access; zero discount dilution. | Commercial Sales / VIP Retention | +10% increase in annual basket size; 0% margin loss. |
| **🤝 Loyal Customers** | Cross-Sell & Upsell | Targeted cross-category product recommendations based on past purchase categories. | Merchandising & Marketing | +15% expansion in multi-category penetration. |
| **⚠️ At Risk (High Value)** | Immediate Churn Intervention | Personal outreach by dedicated Account Managers; executive survey; tailored reactivation bundle. | Sales Leadership & Customer Success | Prevent 25% of imminent customer defections. |
| **🌱 New Customers** | Onboarding & 2nd Purchase Velocity | Automated 3-part email welcome sequence within 14 days of first order with a time-limited incentive. | Lifecycle Marketing Team | +22% conversion from 1st-time to 2nd-time buyer. |
| **💤 Hibernating** | Low-Cost Reactivation or Deprioritization | Shift to automated, ultra-low-cost email re-engagement; exclude from paid performance ads. | Performance Marketing | -30% reduction in wasted ad spend. |

---

## 6. 📁 Repository Structure & How to Run

### Directory Tree
```text
rfm-customer-segmentation/
├── README.md                           # Executive business documentation
├── .gitignore                          # Standard git exclusions
├── sql/
│   └── rfm_customer_segmentation.sql   # Complete production-ready T-SQL pipeline
├── dashboards/
│   └── RFM Dashboard.pbix              # Full interactive Power BI report file
└── images/
    ├── rfm_dashboard_hero.png          # High-resolution dashboard hero banner
    └── rfm_dashboard_overview.png      # Segmentation matrix & cohort distribution
```

### Reproduction Steps

1. **Database Setup:**
   * Open SQL Server Management Studio (SSMS).
   * Ensure monthly tables (`202501` through `202512`) are loaded in your target database.
2. **Execute SQL Pipeline:**
   * Run [`sql/rfm_customer_segmentation.sql`](sql/rfm_customer_segmentation.sql) sequentially.
   * This generates the consolidated `dbo.sales` table, calculation views, and final `dbo.rfm_segments_final` table.
3. **Launch Power BI Dashboard:**
   * Open [`dashboards/RFM Dashboard.pbix`](dashboards/RFM%20Dashboard.pbix) in Power BI Desktop.
   * Update the SQL Server connection string under `Transform Data -> Data Source Settings` to point to your local server instance.
   * Click **Refresh** to populate the report with your latest segmentation data.

---

## 👤 Author & Contact

**Ahmed Rasmy**  
*Data & Business Intelligence Analyst*  
- 🌐 **Interactive Portfolio:** [ahmedrasmyabdelrheem.github.io](https://ahmedrasmyabdelrheem.github.io/)  
- 💼 **LinkedIn:** [linkedin.com/in/ahmedrasmyabdelrheem](https://www.linkedin.com/in/ahmedrasmyabdelrheem)  
- ✉️ **Email:** [ahmed.rasmy.abdelrheem@gmail.com](mailto:ahmed.rasmy.abdelrheem@gmail.com)  
- 📄 **Resume / CV:** [Download CV](https://ahmedrasmyabdelrheem.github.io/assets/Ahmed_Rasmy_CV.pdf)
