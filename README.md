Marketing & E-Commerce Analytics

(SQL + Power BI | Funnel, Campaign, A/B Testing, Customer Insights)

Overview

This project dives into how users behave, where revenue leaks happen, and what actually moves conversion in an e-commerce setup.
Instead of just tracking KPIs, the focus was on diagnosing problems and translating data into actions across marketing, product, and growth teams.

Business Questions I Solved

Where exactly are users dropping off in the funnel — and why?

Which traffic sources look good on volume but fail on conversion or value?

Do A/B experiments genuinely improve business outcomes?

Which customers and product categories drive long-term revenue?

Dataset Snapshot

Simulated multi-table e-commerce dataset

100K+ orders | 100K customers

Tables: users, sessions, orders, campaigns, products, experiments

Tools & Skills Used

SQL (MySQL): joins, CTEs, window functions, funnel logic, cohort-style analysis

Power BI: data modeling, DAX measures, interactive dashboards

Analytics: funnel analysis, campaign performance, A/B testing, customer segmentation

Key Insights (Problem-Solver View 🚀)
🔻 Funnel & Drop-off Analysis

Only ~10% of users who viewed products ended up purchasing, with the largest drop happening between Add-to-Cart and Purchase.

Mobile users generated the highest traffic but showed lower purchase completion, pointing to possible UX or checkout friction on mobile.

Bounce rate stayed low (~11%), meaning interest exists — conversion is the real bottleneck, not acquisition.

👉 Insight: Fixing checkout friction would likely unlock more revenue than increasing traffic.

📣 Campaign & Traffic Performance

Organic and Paid Search drove the highest traffic, but Direct traffic converted best, indicating stronger intent.

Paid channels brought volume but underperformed on conversion efficiency, especially when compared to Email and Affiliate channels.

Some channels looked “successful” on orders but failed on AOV and retention contribution.

👉 Insight: Channel performance should be judged on value and conversion quality, not just traffic.

🧪 A/B Test Performance

Variant B showed a clear uplift in conversion rate (0.72 vs 0.63 control).

Revenue per user improved for both variants, but Variant B consistently outperformed across devices.

Mobile users benefited the most from experiment changes.

👉 Insight: The experiment delivered real impact and is safe to roll out, especially for mobile users.

👥 Customer & Product Insights

Bronze tier customers formed the largest base, but Gold & Platinum users generated significantly higher revenue per user.

Electronics dominated revenue, while categories like Beauty and Grocery showed low revenue but high discount sensitivity.

Loyalty upgrades correlated strongly with higher AOV and repeat purchases.

👉 Insight: Retention and loyalty optimization will outperform aggressive discounting.

Business Recommendations

Prioritize checkout optimization, especially on mobile (payment flow, form friction).

Shift marketing focus from pure acquisition to high-intent channels (Email, Direct).

Roll out Experiment Variant B, with special focus on mobile UX.

Design loyalty nudges to move Bronze → Silver, instead of chasing new low-value users.
