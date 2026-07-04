-- 1) For crm_cust_info
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result
SELECT
cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

-- Check for Data Standardization and Consistency
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info

-- 2) FOR crm_prd_info
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result
SELECT
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for NULLS or Negative Numbers
-- Expectation: No Results
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- Check for Invalid Date Orders
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- 3) For crm_sales_details
-- Check for Invalid Dates
SELECT
sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
OR LEN(sls_order_dt) != 8 
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101

-- Check for Invalid Date Orders
SELECT
*
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_order_dt

-- Check Data Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- Values must not be NULL, zero or negative

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

-- 4) For erp_cust_az12
-- Identify Out-of-Range Dates

SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > getdate()

-- Data Standardization & Consistency
SELECT DISTINCT gen
FROM bronze.erp_cust_az12

-- 5) For erp_loc_a101
-- Data Standardization & Consistency
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101

-- 6) For erp_px_cat_g1v2
-- Check for unwanted spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- Data Standardization & Consistency
SELECT DISTINCT
cat
FROM bronze.erp_px_cat_g1v2
