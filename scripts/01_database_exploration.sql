SELECT 
DISTINCT country
FROM gold.dim_customers;

SELECT 
DISTINCT category, subcategory, product_name
FROM gold.dim_products
ORDER BY 1,2,3;

SELECT 
MAX(order_date) AS last_order_date,
MIN(order_date) AS first_order_date,
DATEDIFF(year,MIN(order_date), MAX(order_date)) as order_range_years
FROM gold.fact_sales;

SELECT 
MIN(birthdate) Oldest_Customer,
MAX(birthdate) Youngest_Customer,
DATEDIFF(YEAR,MIN(birthdate), GETDATE())  Oldest_Customer_age,
DATEDIFF(YEAR,MAX(birthdate), GETDATE())  Youngest_Customer_age
FROM gold.dim_customers
