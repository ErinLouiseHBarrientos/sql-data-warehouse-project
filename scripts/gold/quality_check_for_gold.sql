/*
================================================================
	QUALITY CHECK Script
================================================================
Script Purpose:
	This script performs quality checks to validate the 
	integrity, consistency, and accuracy of the Gold layer.
	These ensure that:
		- Uniqueness of surrogate keys in dimenstion tables.
		- Referential integrity between fact and dimension 
			tables.
		- Validity of relationships in the data model for 
			analytical purposes.

Usage Notes:
	- Run these after data loading Silver layer.
	- Investigate and resolve any discrepancies found during 
		the checks.

================================================================
*/

--------------------------------------------------------------
--	  	          CHECKING 'gold.customer_key'	    	    --
--------------------------------------------------------------
-- Check for uniquesness of Product Key in gold.dim_customers
-- Expectation: No results

SELECT	
	customer_key,
	COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


--------------------------------------------------------------
--	  	          CHECKING 'gold.product_key'	    	    --
--------------------------------------------------------------
-- Check for uniquesness of Product Key in gold.dim_products
-- Expectation: No results

SELECT
	product_key,
	COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


--------------------------------------------------------------
--	  	          CHECKING 'gold.fact_sales'	    	    --
--------------------------------------------------------------
-- Check for data model connectivity between fact and dimension

SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON		  c.customer_key = f.customer_key  -- dim_customers to fact_sales 
WHERE c.customer_key IS NULL;

SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON		  p.customer_key = f.customer_key   -- dim_customers to fact_sales
WHERE p.customer_key IS NULL;
