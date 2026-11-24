# 👥 Customer Behavioral Segmentation & RFM Value Optimization

[![Power BI](https://img.shields.io/badge/Power_BI-Desktop_%26_Service-F2C811?logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![SQL Server](https://img.shields.io/badge/Microsoft_SQL_Server-T--SQL-CC292B?logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server)
[![Live Dashboard](https://img.shields.io/badge/Live_Dashboard-Power_BI_Service-brightgreen?logo=powerbi&logoColor=white)](https://app.powerbi.com/view?r=eyJrIjoiOTNmNDQ0OTItM2YxMC00MTdhLWE0MGUtZmFmMGJjMDhlM2MzIiwidCI6ImVhZjYyNGM4LWEwYzQtNDE5NS04N2QyLTQ0M2U1ZDc1MTZjZCIsImMiOjh9)

---

## Project Overview
An end-to-end customer intelligence solution that cleans, aggregates, and scores 12 months of transactional sales data using T-SQL quintiles (`NTILE`), classifying 287 customer accounts into behavioral cohorts to prevent churn and maximize Customer Lifetime Value (LTV).

---

## Business Problem
A growing commercial enterprise treated all customer accounts identically in marketing and sales outreach, causing diminishing campaign ROI and margin erosion from blanket discounting. Management lacked visibility into early churn signals among high-spending clients, leaving lucrative accounts undetected until they permanently defected to competitors. This created an urgent need for data-driven customer behavioral segmentation.

---

## Solution
Engineered a 5-stage **T-SQL pipeline** consolidating 12 monthly transactional partitions, computing Recency, Frequency, and Monetary metrics, and assigning quintile scores (1–5) via window functions (`NTILE(5)`). Classified **287 customer accounts** into 7 actionable behavioral tiers, and deployed an interactive **Power BI** dashboard with dynamic segment cross-filtering and customer-level drill-throughs.

---

## Dashboard Preview

### 1. RFM Analysis & Customer Base Distribution
![RFM Analysis Overview](images/01_rfm_analysis_overview.png)
* **What it shows:** Macro-level distribution of all customer accounts across 7 behavioral tiers, granular RFM cell frequency patterns, and an account-level transactional ledger.
* **Business Value:** Provides sales and marketing directors with an instant diagnostic of customer portfolio health, revealing the proportion of active loyalists versus dormant buyers.

---

### 2. "At-Risk" Churn Prevention Deep Dive
![At-Risk Customer Deep Dive](images/02_rfm_at_risk_deepdive.png)
* **What it shows:** An isolated view of high-value accounts experiencing prolonged purchasing dormancy, detailing individual customer recency days, past order cadence, and total spend.
* **Business Value:** Empowers account managers with an actionable, prioritized target list for immediate commercial win-back campaigns before customer defection becomes irreversible.

---

## Key Insights

* **High-Profitability Customer Concentration:**
  * **Finding:** A focused core of Champions and Potential Loyalists drives the business's repeat revenue.
  * **Evidence:** **64 Champions (22.3%)** and **53 Potential Loyalists (18.5%)** comprise 40.8% of the customer base with peak recency and order frequency.
  * **Business Meaning:** High-value customers generate outsized margins and should receive VIP relationship perks rather than margin-eroding discount promotions.

* **Critical Churn Exposure in High-Value Accounts:**
  * **Finding:** A substantial cluster of historically lucrative accounts has stopped ordering and faces imminent churn.
  * **Evidence:** **42 accounts (14.6%)** classified as **"At Risk"** boast high monetary scores (4–5) but have gone dormant for **100 to 254 days**.
  * **Business Meaning:** Unmonitored account dormancy threatens customer lifetime value, requiring proactive intervention to protect top-line revenue.

* **Heavy Customer Base Dormancy (Hibernating):**
  * **Finding:** One-quarter of the customer portfolio is completely disengaged with minimal repeat purchasing intent.
  * **Evidence:** **74 accounts (25.8%)** fall into the **"Hibernating"** tier, clustered in bottom RFM score cells (`111` and `122`).
  * **Business Meaning:** High-touch manual sales outreach on dormant leads wastes rep capacity and should be replaced by low-cost automated workflows.

---

## Business Recommendations

* **Rapid 14-Day Reactivation Blitz for At-Risk Accounts:**
  * **Finding:** 42 high-value accounts have been dormant between 100–254 days, representing imminent revenue churn.
  * **Suggested Action:** Assign dedicated sales reps to execute personalized outreach and offer tailored reorder incentives within 14 days.
  * **Expected Benefit:** Recovers 20–25% of at-risk accounts, protecting high-margin recurring revenue before permanent brand defection.

* **VIP Loyalty Program for Champions (64 Accounts):**
  * **Finding:** Top-tier Champions were receiving standard promotional discounts despite high organic purchase intent.
  * **Suggested Action:** Transition Champions to non-discount privileges such as dedicated support, early catalog access, and annual volume rebates.
  * **Expected Benefit:** Safeguards product margins, eliminates discount dependency, and boosts long-term customer lifetime value.

* **Automated Low-Cost Drips for Hibernating Segment (74 Accounts):**
  * **Finding:** Manual follow-ups on 74 deeply dormant accounts yield negative ROI and distract commercial teams.
  * **Suggested Action:** Enroll hibernating contacts into automated low-cost email re-engagement drips and suppress expensive ad retargeting.
  * **Expected Benefit:** Maximizes sales rep productivity on high-potential buyers while maintaining a zero-marginal-cost win-back funnel.

---

## Interactive Dashboard

Experience the live, interactive Power BI report with full cross-filtering, segment selection, and account drill-throughs directly in your browser:

[![Launch Power BI Dashboard](https://img.shields.io/badge/Power_BI_Service-Launch_Interactive_Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://app.powerbi.com/view?r=eyJrIjoiOTNmNDQ0OTItM2YxMC00MTdhLWE0MGUtZmFmMGJjMDhlM2MzIiwidCI6ImVhZjYyNGM4LWEwYzQtNDE5NS04N2QyLTQ0M2U1ZDc1MTZjZCIsImMiOjh9)

👉 **[Click Here to Open the Live RFM Dashboard](https://app.powerbi.com/view?r=eyJrIjoiOTNmNDQ0OTItM2YxMC00MTdhLWE0MGUtZmFmMGJjMDhlM2MzIiwidCI6ImVhZjYyNGM4LWEwYzQtNDE5NS04N2QyLTQ0M2U1ZDc1MTZjZCIsImMiOjh9)**
