--1.Find the total sales.
	SELECT 
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales

--2.Find how many items are sold.
	SELECT 
		SUM(quantity) AS total_quantity
	FROM gold.fact_sales

--3.Find the average selling price.
	SELECT 
		AVG(price) AS Average_selling_price
	FROM gold.fact_sales

--4.Find the total number of Orders
	SELECT 
		COUNT(order_number) AS total_orders,
		COUNT(DISTINCT order_number) AS unqiue_total_orders
	FROM gold.fact_sales

--5.Find the total number of Products
	SELECT 
		COUNT(product_key) AS total_product
	FROM gold.dim_products

--6.Find the total number of customers
	SELECT 
		COUNT(customer_key) AS total_customers
	FROM gold.dim_customers

--7.Find the total number of customers that has placed an order.
	SELECT 
		COUNT(DISTINCT customer_key) AS total_customers
	FROM gold.fact_sales

---Generate Report
	SELECT 
		'Total Sales' AS measure_name,
		SUM(sales_amount) AS measure_value
	FROM gold.fact_sales
	
	UNION ALL

	SELECT 
		'Total Quantity',
		SUM(quantity)
	FROM gold.fact_sales

	UNION ALL

	SELECT 
		'Average Price',
		AVG(price)  
	FROM gold.fact_sales

	UNION ALL

	SELECT 
		'Total Nr. Orders',
		COUNT(DISTINCT order_number) 
	FROM gold.fact_sales
	
	UNION ALL

	SELECT 
		'Total Nr.Product',
		COUNT(product_key)  
	FROM gold.dim_products

	UNION ALL

	SELECT 
	 'Total Nr.Customers',
	 COUNT(customer_key) 
	FROM gold.dim_customers

	UNION ALL

	SELECT 
		'Total customers ordered',
		COUNT(DISTINCT customer_key) 
	FROM gold.fact_sales