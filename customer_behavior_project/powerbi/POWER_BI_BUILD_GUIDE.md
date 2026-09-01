# Power BI Build Guide

## Data source
Use `data/processed/customer_shopping_behavior_clean.csv`. Load it into Power BI Desktop.

## Model
For this single-table project, a star schema is not required. Keep the cleaned table as the central fact table for the portfolio version. If expanding the project, create dimension tables for Date, Customer, Product, Geography, and Promotion.

## Core DAX measures
```DAX
Total Revenue = SUM(customer[purchase_amount])
Total Customers = DISTINCTCOUNT(customer[customer_id])
Average Purchase = AVERAGE(customer[purchase_amount])
Average Rating = AVERAGE(customer[review_rating])
Orders = COUNTROWS(customer)
Subscription Rate = DIVIDE(CALCULATE([Orders], customer[subscription_status] = "Yes"), [Orders])
Discount Usage Rate = DIVIDE(CALCULATE([Orders], customer[discount_applied] = "Yes"), [Orders])

Revenue per Customer = DIVIDE([Total Revenue], [Total Customers])

Loyal Customer Revenue = CALCULATE([Total Revenue], customer[customer_segment] = "Loyal")

Loyal Customer % Revenue = DIVIDE([Loyal Customer Revenue], [Total Revenue])
```

## Page 1 — Executive Overview
KPI cards: Total Revenue, Total Customers, Average Purchase, Average Rating, Subscription Rate, Discount Usage Rate.
Charts: Revenue by Category, Revenue by Age Group, Revenue by Customer Segment, Revenue by Season.
Slicers: Gender, Category, Subscription Status, Discount Applied, Season, Location.

## Page 2 — Customer Analysis
Show customer segments, revenue by age group, previous purchases distribution, purchase frequency, and subscription status.

## Page 3 — Product Analysis
Show top products by revenue, orders, rating, and category. Use a matrix for Product × Category with Revenue, Orders, Average Rating, and Discount Usage Rate.

## Page 4 — Subscription & Discount
Compare subscribers vs non-subscribers and discount vs non-discount orders. Explicitly label comparisons as descriptive/associational rather than causal.

## Validation checklist
1. Total Revenue in Power BI must equal the Python total.
2. Total Customers must equal the unique customer count.
3. Average Rating must match the cleaned dataset.
4. Subscription and discount percentages must use the same denominator as documented.
5. Test every slicer against at least three visuals.
