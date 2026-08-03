-- which 5 produts generate the highest revenue?
SELECT 
	TOP 5
	p.product_id,
	p.product_name,
	SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
 
--what are the 5 worst performance products in terms of sales?
SELECT 
	TOP 5
	p.product_id,
	p.product_name,
	SUM(s.sales_amount) AS total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
ON s.product_key = p.product_key
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue ASC

-- Find the top 10 customers who have generated the highest revenue.

SELECT 
	TOP 10
	c.customer_id,
	c.first_name,
	SUM(f.sales_amount) as total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON f.customer_key = c.customer_key
GROUP BY c.customer_id, c.first_name
ORDER BY total_revenue DESC


-- Find the top 10 customers who have generated the highest revenue [using rank function]

SELECT *
FROM 
	(SELECT 
		c.customer_id,
		c.first_name,
		SUM(f.sales_amount) as total_revenue,
		ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount)DESC) AS rnk
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_customers AS c
	ON f.customer_key = c.customer_key
	GROUP BY c.customer_id, c.first_name)t
WHERE rnk <= 10

--- 3 customers wuth the fewest order placed.
SELECT TOP 3
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT f.order_number) as order_placed
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY order_placed 

