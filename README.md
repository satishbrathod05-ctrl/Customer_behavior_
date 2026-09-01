# Customer Shopping Behavior Analytics — Data Analyst Portfolio Project

## Business Problem
A retail business wants to understand customer purchasing behavior, product performance, subscription engagement, discount usage, and customer loyalty so it can improve revenue and retention decisions.

## Objective
Analyze transaction-level customer data using Python, PostgreSQL/SQL, and Power BI; create business KPIs; identify high-value customer and product segments; and translate findings into actionable recommendations.

## Dataset
**3,900 transaction/customer records, 18 source columns.** The source dataset contains customer demographics, purchased item/category, purchase amount, location, season, review rating, subscription status, shipping type, discounts, previous purchases, payment method, and purchase frequency.

### Data quality
- Missing Review Rating values before cleaning: **37**
- Missing values after cleaning: **0**
- Review ratings were imputed with the median rating within the product category.
- Standardized column names to snake_case.
- Added age_group, purchase_frequency_days, customer_segment, discount_flag, and subscription_flag.

## Tools
- Python / Pandas / NumPy
- Matplotlib / Seaborn
- PostgreSQL / SQL
- Power BI / DAX

## Project Workflow
`Raw CSV → Data Quality Checks → Python Cleaning & EDA → PostgreSQL → SQL Business Analysis → Power BI Dashboard → Insights → Recommendations`

## Core KPIs
| KPI | Value |
|---|---:|
| Total Customers | 3,900 |
| Total Revenue | $233,081.00 |
| Average Purchase | $59.76 |
| Average Review Rating | 3.75 |
| Subscription Rate | 27.00% |
| Discount Usage Rate | 43.00% |

## SQL Analysis
`sql/customer_behavior_analysis.sql` contains 25+ business queries covering aggregation, CASE expressions, CTEs, subqueries, conditional aggregation, and window functions.

## Power BI
The supplied `.pbix` dashboard from the reference project is retained in `powerbi/reference_customer_behavior_dashboard.pbix`. `powerbi/POWER_BI_BUILD_GUIDE.md` documents the recommended model, DAX measures, pages, slicers, and validation checks.

> Power BI Desktop is required to open/edit the PBIX file.

## Key Questions
1. Which categories and products drive revenue?
2. Do subscribers spend more than non-subscribers?
3. How much revenue comes from loyal customers?
4. Which products have high sales and high ratings?
5. How widely are discounts used, and where?
6. Which age groups and locations contribute the most revenue?
7. Which purchasing frequencies are associated with higher spend?

## Recommendations Framework
Recommendations should be based on the calculated outputs in `reports/`, not assumed results. Prioritize:
- Loyalty programs for high-value repeat customers.
- Subscription offers where subscribers show higher observed value.
- Targeted rather than blanket discounts where discount usage is concentrated.
- Product assortment decisions using both revenue and review rating.
- Segment-specific campaigns based on age, purchase frequency, and prior purchase behavior.

## Interview Pitch
“I analyzed 3,900 customer shopping records to understand revenue drivers, loyalty, subscription behavior, discounts, and product performance. I cleaned missing review ratings in Python, engineered customer and frequency segments, used PostgreSQL for business-focused SQL analysis including CTEs and window functions, and designed a Power BI dashboard around revenue, customers, products, subscriptions, and discounts. The final step was translating the measured patterns into targeted commercial recommendations.”

## Files
- `data/raw/` — original dataset
- `data/processed/` — cleaned dataset
- `python/Customer_Shopping_Behavior_Analysis.ipynb` — reproducible analysis
- `sql/customer_behavior_analysis.sql` — SQL analysis
- `powerbi/` — PBIX reference + build guide
- `reports/` — calculated summary tables
- `presentation/` — interview presentation outline
