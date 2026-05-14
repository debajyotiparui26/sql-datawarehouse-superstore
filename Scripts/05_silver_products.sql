USE SuperstoreDW;
GO
 
 
-- ── STEP 1 : Drop table if it already exists
IF OBJECT_ID('silver.products', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.products;
    PRINT '>> Old silver.products dropped';
END
GO
 
 -- ── STEP 3 : Create silver.products using GROUP BY
 
SELECT
    TRIM(Product_ID)                     AS ProductID,
    MIN(TRIM(Category))                  AS Category,
    MIN(TRIM(Sub_Category))              AS SubCategory,
    MIN(TRIM(Product_Name))              AS ProductName
 
INTO silver.products
 
FROM bronze.raw_superstore
 
WHERE Product_ID IS NOT NULL
  AND TRIM(Product_ID) <> ''
 
GROUP BY TRIM(Product_ID);
GO
 
PRINT '>> silver.products created';
GO

-- ── STEP 4 : Make ProductID NOT NULL then add Primary Key
ALTER TABLE silver.products
    ALTER COLUMN ProductID NVARCHAR(50) NOT NULL;
GO
 
ALTER TABLE silver.products
    ADD CONSTRAINT PK_silver_products
    PRIMARY KEY (ProductID);
GO
 
PRINT '>> Primary key added on ProductID';
GO
-- ── STEP 5 : Quality Checks
 
-- 5.1  Total unique products
SELECT COUNT(*) AS Total_Products
FROM silver.products;
-- Expected: around 1850
 
-- 5.2  Preview
SELECT TOP 10 *
FROM silver.products
ORDER BY Category, SubCategory;
 
-- 5.3  Confirm FUR-BO-10002213 appears exactly once
SELECT * FROM silver.products
WHERE ProductID = 'FUR-BO-10002213';
-- Expected: exactly 1 row
 
-- 5.4  Null check
SELECT
    SUM(CASE WHEN ProductID   IS NULL OR ProductID   = '' THEN 1 ELSE 0 END) AS Null_ProductID,
    SUM(CASE WHEN Category    IS NULL OR Category    = '' THEN 1 ELSE 0 END) AS Null_Category,
    SUM(CASE WHEN SubCategory IS NULL OR SubCategory = '' THEN 1 ELSE 0 END) AS Null_SubCategory,
    SUM(CASE WHEN ProductName IS NULL OR ProductName = '' THEN 1 ELSE 0 END) AS Null_ProductName
FROM silver.products;
-- Expected: all zeros
 
-- 5.5  Distinct Category values
SELECT Category, COUNT(*) AS ProductCount
FROM silver.products
GROUP BY Category;
-- Expected: Furniture, Office Supplies, Technology
 
-- 5.6  No duplicate ProductIDs
SELECT ProductID, COUNT(*) AS Cnt
FROM silver.products
GROUP BY ProductID
HAVING COUNT(*) > 1;
-- Expected: 0 rows
