/*
===========================================================================================================
Quality Checks
===========================================================================================================
Script Purpose:
	This script performs various quality checks for data consistency, accuracy,
	and standardization across the 'silver' schema. It incudes checks for:
		- Null or duplicate primary keys.
		- Unwanted spaces in string fileds.
		- Data standardization and consistency.
		- Invalid data ranges and orders.
		- Data consistency between related fields.

Usage Notes:
	- Run these checks after data loading silver layer.
	- Investigate and resolve any discrepancies found during the checks.

===========================================================================================================
*/

------------------------------------------------
	  -- Checking 'silver.crm_cust_info' --
------------------------------------------------

-- Check for nulls or duplicates in Primary Keys
-- Expectation: No Results

SELECT 
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;  -- none


-- Check for unwanted spaces
-- Expectation: No result
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname); -- none

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname); -- none

SELECT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr); -- none

SELECT cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key); -- none


-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;


-- Final Check
SELECT * FROM silver.crm_cust_info;



--------------------------------------------------
	  -- Checking 'silver.crm_prd_info' --
--------------------------------------------------

-- Check for nulls or duplicates in Primary Keys
-- Expectation: No Results

SELECT 
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- Check for unwanted spaces
-- Expectation: No result
SELECT prd_key
FROM silver.crm_prd_info
WHERE prd_key != TRIM(prd_key);  -- none

SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);  -- none


-- Check for nulls or negative numbers
-- Expectation: No Results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;


-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;


-- Check for invalid date orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


-- Final Check
SELECT *
FROM silver.crm_prd_info;



-----------------------------------------------------
	  -- Checking 'silver.crm_sales_details' --
-----------------------------------------------------

-- Check for Invalid Date Orders
SELECT
*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt


-- Check Data Consistency: Between Sales, Quantity, and Price
-- >>> Sales = Quantity * Price
-- >>> Values must not be NULL, Zero, or Negative

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

-- Final Check
SELECT * 
FROM silver.crm_sales_details



-----------------------------------------------------
	  -- Checking 'silver.erp_cust_az12' --
-----------------------------------------------------

-- Identifying out-of-range Dates
SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Data Standardization & Consistency
SELECT DISTINCT 
gen
FROM silver.erp_cust_az12

-- Final Check
SELECT * FROM silver.erp_cust_az12



-----------------------------------------------------
	  -- Checking 'silver.erp_loc_a101' --
-----------------------------------------------------

-- For Double Checking the results
SELECT DISTINCT cntry 
FROM silver.erp_loc_a101
ORDER BY cntry

-- Final Check
SELECT * FROM silver.erp_loc_a101



