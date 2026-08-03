/*
================================================================================
Product Report
================================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders 
       - total sales 
       - total quantity sold 
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
================================================================================
*/
CREATE VIEW gold.report_product AS 

WITH base_query AS
(
	SELECT 
		p.product_key,
		p.product_name,
		p.category,
		p.subcategory,
		p.cost,
		f.order_number,
		f.sales_amount,
		f.quantity,
		f.customer_key,
		f.order_date
	FROM gold.fact_sales AS f

	LEFT JOIN gold.dim_products AS p
	ON f.product_key = p.product_key

	WHERE f.order_date IS NOT NULL
)
,product_metrics AS
(
	SELECT
		product_key,
		product_name,
		category,
		subcategory,
		cost,

		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT customer_key) AS unique_customers,

		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,

		MAX(order_date) AS last_order

	FROM base_query

	GROUP BY
		product_key,
		product_name,
		category,
		subcategory,
		cost
)

SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_order,
	DATEDIFF(MONTH,last_order, GETDATE()) AS rescency,
	
	--Product segment --

	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	unique_customers,

	--Average selling price--

	ROUND(CAST(total_sales AS FLOAT) / NULLIF(total_quantity,0),1) AS avg_selling_price,

	--Average Order revenue(AOR)--
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales/total_orders 
	END AS avg_order_revenue,
	
	--Average Montly revenue--
	CASE 
		WHEN lifespan= 0 THEN total_sales
		ELSE total_sales/lifespan
	END AS avg_montly_revenue
FROM product_metrics
