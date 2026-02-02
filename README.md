# Marketing & E-Commerce Analytics  
*(SQL + Power BI | Funnel, Campaign, A/B Testing, Customer Insights)*

## Overview
This project analyzes how users behave across the e-commerce journey, where revenue leaks happen, and what actually drives conversion.  
Instead of just reporting KPIs, the focus is on **diagnosing business problems and translating data into clear, actionable decisions** for marketing, product, and growth teams.

---

## Business Questions Solved
- Where exactly are users dropping off in the purchase funnel — and why?
- Which traffic sources look strong on volume but weak on conversion or value?
- Do A/B experiments genuinely improve conversion and revenue?
- Which customers and product categories drive long-term business value?

---

## Dataset Snapshot
- Simulated multi-table e-commerce dataset  
- ~100K+ orders | ~100K customers  
- Tables: users, sessions, orders, campaigns, products, experiments

---

## Tools & Skills Used
- **SQL (MySQL):** joins, CTEs, window functions, funnel logic, cohort-style analysis  
- **Power BI:** data modeling, DAX measures, interactive dashboards  
- **Analytics:** funnel analysis, campaign performance, A/B testing, customer segmentation

---

## Key Insights (Problem-Solver View)

### 🔻 Funnel & Drop-off Analysis
- Only **~10% of users who viewed products completed a purchase**, with the largest drop occurring between **Add-to-Cart and Purchase**.
- **Mobile users drove the highest traffic** but showed lower purchase completion, indicating checkout or UX friction on mobile.
- Bounce rate remained low (~11%), suggesting **interest exists — conversion friction is the real bottleneck**, not traffic quality.

**Insight:** Improving checkout experience would likely generate higher ROI than increasing acquisition spend.

---

### 📣 Campaign & Traffic Performance
- **Organic and Paid Search drove the most traffic**, but **Direct traffic converted at the highest rate**, indicating stronger user intent.
- Paid channels delivered volume but **underperformed on conversion efficiency** compared to Email and Affiliate channels.
- Some channels appeared successful on order count but **failed on AOV and retention contribution**.

**Insight:** Channel performance should be evaluated on **conversion quality and value**, not traffic volume alone.

---

### 🧪 A/B Test Performance
- **Variant B showed a clear conversion uplift** (0.72 vs 0.63 control).
- Revenue per user improved across variants, with **Variant B consistently outperforming across devices**.
- Mobile users experienced the most noticeable improvement from experiment changes.

**Insight:** The experiment delivered measurable impact and is **safe to roll out**, particularly for mobile users.

---

### 👥 Customer & Product Insights
- **Bronze-tier users formed the largest customer base**, but **Gold and Platinum users generated significantly higher revenue per user**.
- Electronics dominated total revenue, while categories like Beauty and Grocery showed **low revenue but high discount sensitivity**.
- Loyalty upgrades strongly correlated with **higher AOV and repeat purchases**.

**Insight:** Retention and loyalty optimization will outperform aggressive discounting strategies.

---

## Business Recommendations
- Prioritize **checkout optimization**, especially for mobile users (payment flow, form friction).
- Shift marketing focus from pure acquisition to **hig**
