-- Customer Shopping Behavior Analysis | PostgreSQL
-- Load cleaned CSV into table: customer
-- Column names follow snake_case.

-- 01. Overall KPIs
SELECT COUNT(*) AS transactions, COUNT(DISTINCT customer_id) AS customers, SUM(purchase_amount) AS revenue, ROUND(AVG(purchase_amount),2) AS avg_purchase FROM customer;

-- 02. Revenue by gender
SELECT gender, COUNT(DISTINCT customer_id) AS customers, SUM(purchase_amount) AS revenue, ROUND(AVG(purchase_amount),2) AS avg_purchase FROM customer GROUP BY gender ORDER BY revenue DESC;

-- 03. Revenue by category
SELECT category, COUNT(*) AS orders, SUM(purchase_amount) AS revenue, ROUND(AVG(purchase_amount),2) AS avg_purchase FROM customer GROUP BY category ORDER BY revenue DESC;

-- 04. Top 10 products by revenue
SELECT item_purchased, COUNT(*) AS orders, SUM(purchase_amount) AS revenue, ROUND(AVG(review_rating::numeric),2) AS avg_rating FROM customer GROUP BY item_purchased ORDER BY revenue DESC LIMIT 10;

-- 05. Top 5 products by rating (minimum 20 orders)
SELECT item_purchased, COUNT(*) AS orders, ROUND(AVG(review_rating::numeric),2) AS avg_rating FROM customer GROUP BY item_purchased HAVING COUNT(*) >= 20 ORDER BY avg_rating DESC LIMIT 5;

-- 06. Subscription comparison
SELECT subscription_status, COUNT(DISTINCT customer_id) AS customers, SUM(purchase_amount) AS revenue, ROUND(AVG(purchase_amount),2) AS avg_purchase FROM customer GROUP BY subscription_status;

-- 07. Subscription rate among repeat buyers
SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE subscription_status='Yes') / COUNT(*),2) AS subscription_rate_pct FROM customer WHERE previous_purchases > 5;

-- 08. Discount usage by category
SELECT category, ROUND(100.0*AVG((discount_applied='Yes')::int),2) AS discount_rate_pct, SUM(purchase_amount) AS revenue FROM customer GROUP BY category ORDER BY discount_rate_pct DESC;

-- 09. Customers using discount but spending above overall average
SELECT customer_id, item_purchased, purchase_amount FROM customer WHERE discount_applied='Yes' AND purchase_amount > (SELECT AVG(purchase_amount) FROM customer) ORDER BY purchase_amount DESC;

-- 10. Customer segments based on previous purchases
WITH segmented AS (SELECT customer_id, CASE WHEN previous_purchases=1 THEN 'New' WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning' ELSE 'Loyal' END AS customer_segment, purchase_amount FROM customer) SELECT customer_segment, COUNT(DISTINCT customer_id) AS customers, SUM(purchase_amount) AS revenue, ROUND(AVG(purchase_amount),2) AS avg_purchase FROM segmented GROUP BY customer_segment ORDER BY revenue DESC;

-- 11. Revenue by age group
SELECT CASE WHEN age < 20 THEN 'Teen' WHEN age BETWEEN 20 AND 29 THEN '20-29' WHEN age BETWEEN 30 AND 39 THEN '30-39' WHEN age BETWEEN 40 AND 49 THEN '40-49' WHEN age BETWEEN 50 AND 59 THEN '50-59' ELSE '60+' END AS age_group, SUM(purchase_amount) AS revenue, COUNT(*) AS orders FROM customer GROUP BY 1 ORDER BY revenue DESC;

-- 12. Revenue by season
SELECT season, SUM(purchase_amount) AS revenue, COUNT(*) AS orders, ROUND(AVG(purchase_amount),2) AS avg_purchase FROM customer GROUP BY season ORDER BY revenue DESC;

-- 13. Shipping comparison
SELECT shipping_type, COUNT(*) AS orders, ROUND(AVG(purchase_amount),2) AS avg_purchase, SUM(purchase_amount) AS revenue FROM customer GROUP BY shipping_type ORDER BY avg_purchase DESC;

-- 14. Payment method mix
SELECT payment_method, COUNT(*) AS orders, ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER(),2) AS order_share_pct FROM customer GROUP BY payment_method ORDER BY orders DESC;

-- 15. Purchase frequency mix
SELECT frequency_of_purchases, COUNT(*) AS orders, ROUND(AVG(purchase_amount),2) AS avg_purchase FROM customer GROUP BY frequency_of_purchases ORDER BY orders DESC;

-- 16. Top 3 products within each category using ROW_NUMBER
WITH ranked AS (SELECT category,item_purchased,COUNT(*) AS orders, ROW_NUMBER() OVER(PARTITION BY category ORDER BY COUNT(*) DESC, item_purchased) AS rn FROM customer GROUP BY category,item_purchased) SELECT * FROM ranked WHERE rn<=3 ORDER BY category,rn;

-- 17. Rank products by revenue within category
WITH p AS (SELECT category,item_purchased,SUM(purchase_amount) AS revenue FROM customer GROUP BY category,item_purchased) SELECT *, DENSE_RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS revenue_rank FROM p ORDER BY category,revenue_rank;

-- 18. Product revenue share
WITH p AS (SELECT item_purchased,SUM(purchase_amount) AS revenue FROM customer GROUP BY item_purchased) SELECT item_purchased,revenue,ROUND(100.0*revenue/SUM(revenue) OVER(),2) AS revenue_share_pct FROM p ORDER BY revenue DESC;

-- 19. Customer value bands
WITH x AS (SELECT customer_id,SUM(purchase_amount) AS customer_revenue FROM customer GROUP BY customer_id) SELECT CASE WHEN customer_revenue>=100 THEN 'High Value' WHEN customer_revenue>=50 THEN 'Medium Value' ELSE 'Low Value' END AS value_band, COUNT(*) AS customers, SUM(customer_revenue) AS revenue FROM x GROUP BY 1 ORDER BY revenue DESC;

-- 20. High-value customers
SELECT customer_id,SUM(purchase_amount) AS revenue, COUNT(*) AS orders, MAX(previous_purchases) AS previous_purchases FROM customer GROUP BY customer_id HAVING SUM(purchase_amount) >= (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY customer_revenue) FROM (SELECT customer_id,SUM(purchase_amount) AS customer_revenue FROM customer GROUP BY customer_id) s) ORDER BY revenue DESC;

-- 21. Discount vs non-discount comparison
SELECT discount_applied, COUNT(*) AS orders, SUM(purchase_amount) AS revenue, ROUND(AVG(purchase_amount),2) AS avg_purchase FROM customer GROUP BY discount_applied;

-- 22. Promo-code consistency check
SELECT COUNT(*) AS mismatches FROM customer WHERE discount_applied <> promo_code_used;

-- 23. Location performance
SELECT location, COUNT(*) AS orders, SUM(purchase_amount) AS revenue, ROUND(AVG(purchase_amount),2) AS avg_purchase FROM customer GROUP BY location ORDER BY revenue DESC LIMIT 10;

-- 24. Category rating vs revenue
SELECT category, ROUND(AVG(review_rating::numeric),2) AS avg_rating, SUM(purchase_amount) AS revenue FROM customer GROUP BY category ORDER BY revenue DESC;

-- 25. Frequency and subscription cross-analysis
SELECT frequency_of_purchases, subscription_status, COUNT(*) AS orders, ROUND(AVG(purchase_amount),2) AS avg_purchase FROM customer GROUP BY frequency_of_purchases, subscription_status ORDER BY frequency_of_purchases, subscription_status;

-- 26. Above-average spenders by segment using CTE
WITH base AS (SELECT customer_id, CASE WHEN previous_purchases=1 THEN 'New' WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning' ELSE 'Loyal' END AS segment, purchase_amount FROM customer), avg_by_segment AS (SELECT segment,AVG(purchase_amount) AS segment_avg FROM base GROUP BY segment) SELECT b.segment, COUNT(*) AS above_avg_orders FROM base b JOIN avg_by_segment a USING(segment) WHERE b.purchase_amount>a.segment_avg GROUP BY b.segment ORDER BY above_avg_orders DESC;

-- 27. Cumulative revenue by product rank
WITH p AS (SELECT item_purchased,SUM(purchase_amount) AS revenue FROM customer GROUP BY item_purchased), r AS (SELECT *, ROW_NUMBER() OVER(ORDER BY revenue DESC) AS rn FROM p) SELECT rn,item_purchased,revenue,SUM(revenue) OVER(ORDER BY rn) AS cumulative_revenue FROM r ORDER BY rn;
