/*Group customers into three segments based on their spending behavior:
    - VIP: Customers with at least 12 months of history and spending more than €5,000.
    - Regular: Customers with at least 12 months of history but spending €5,000 or less.
    - New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH NEW_CTE AS(
SELECT 
	c.customer_key,
	SUM(f.sales_amount) AS total_Sales,
	MAX(f.order_date) AS new_order,
	MIN(f.order_date) AS old_order,
	DATEDIFF(MONTH,MIN(f.order_date),MAX(f.order_date)) AS date_diff
FROM gold.fact_sales as f
LEFT JOIN gold.dim_customers as c
ON f.customer_key = c.customer_key
GROUP BY 
	c.customer_key)

, CTE_2 AS
(SELECT 
	customer_key,
	CASE
		WHEN date_diff > = 12 AND total_Sales > 5000 THEN 'VIP'
		WHEN date_diff > =12 AND total_Sales < = 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment
FROM NEW_CTE)

SELECT 
	COUNT(customer_key) AS total_no_customers,
	customer_segment
FROM CTE_2
GROUP BY customer_segment
ORDER BY total_no_customers DESC

