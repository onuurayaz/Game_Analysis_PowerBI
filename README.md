# Mobile Game Analysis – Power BI Project

An interactive data analytics project designed to analyze **player behavior**, **engagement patterns**, and **revenue performance** in a mobile game environment.  
Developed using **Power BI** and **SQL**, this project transforms raw gameplay data into actionable insights on user retention, monetization, and marketing efficiency.

---

# Project Overview
This project explores how different game dynamics influence player engagement and purchasing behavior.  
The dataset captures key metrics including **installs, sessions, revenue, costs, and level progression** — enabling deep analysis of user activity, ad network performance, and in-app monetization.

---

# Dataset Structure
A synthetic dataset was created for 500 users from 5 countries and 4 ad networks over a 30-day gameplay period.  
It includes the following relational tables:

| Table | Description |
|--------|--------------|
| **Install** | User installation data (User ID, platform, country, network) |
| **Session** | Session start and end times, duration, and player actions |
| **Revenue** | In-app purchases, ad revenue, and total income |
| **Cost** | Marketing spend and campaign data per network |
| **Level** | Level structure, difficulty, and player progress |
| **Level_Attempt** | Attempts and completions per level |
| **Player_Action** | Detailed user actions such as purchases and engagement scores |

---

# Analysis Components

## 1. User Engagement Analysis
- **KPIs:** Daily Active Users (DAU), Churn Rate  
- **Visualization:** Line Chart (DAU trends), Heatmap (peak play hours)

## 2. Revenue Analysis
- **KPIs:** ARPDAU (Average Revenue Per Daily Active User), LTV, Revenue per Network  
- **Visualization:** Bar Chart (network revenue), Time Series (ARPDAU trend)

## 3. Retention Analysis
- **KPIs:** Day 1, Day 7, and Day 30 Retention  
- **Visualization:** Cohort Chart (retention by acquisition date), Funnel Chart (drop-off from install to purchase)

## 4. Level Progression Analysis
- **KPIs:** Level Completion Rate, Avg. Time per Level  
- **Visualization:** Stacked Bar Chart (completion rate by engagement), Heatmap (progression time)

## 5. Cost vs Revenue Analysis
- **KPIs:** CPA, ROI per Network  
- **Visualization:** Dual Axis Line Chart (marketing spend vs revenue), Pie Chart (cost distribution)

## 6. Segmentation Analysis
- **KPIs:** Revenue by Engagement Segment (Low, Medium, High, Whale), Churn Rate by Segment  
- **Visualization:** Scatter Plot (revenue vs engagement), Cluster Chart (behavior patterns)

---

## Tools & Technologies
- **Data Processing:** SQL  
- **Visualization:** Power BI  
- **Data Modeling:** Relational schema with DAX calculations  
- **Reporting:** Interactive dashboards & KPI summaries  

---


##  Insights & Recommendations
- Identify which ad networks deliver the most engaged and profitable users  
- Highlight levels where users struggle most  
- Correlate engagement and monetization patterns to optimize design decisions  

---


##  Contact
**Onur Ayaz**  
📧 [onuurayaz@gmail.com] 
🔗 [LinkedIn](https://www.linkedin.com/in/onur-ayaz-/)
