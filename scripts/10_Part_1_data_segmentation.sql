--Segment products into cost ranges 
--and count how many products fall into each segment.
SELECT 
	cost_range,
	COUNT(product_key) AS total_products,
	SUM(cost) AS total_cost
FROM
(SELECT 
	product_key,
	product_name,
	cost,
	CASE
		WHEN cost < 100 THEN 'Below 100'
		WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		ELSE 'Above 100'
	END AS cost_range
FROM gold.dim_products)t
GROUP BY cost_range
ORDER BY total_products DESC