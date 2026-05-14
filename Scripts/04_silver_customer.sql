USE SuperstoreDW;
GO
 
 
-- ── STEP 1 : Drop table if it already exists (safe re-run)
IF OBJECT_ID('silver.customers', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.customers;
    PRINT '>> Old silver.customers dropped';
END
GO
-- ── STEP 2 : Create silver.customers
SELECT
    TRIM(Customer_ID)                AS CustomerID,
    MIN(TRIM(Customer_Name))         AS CustomerName,
    MIN(TRIM(Segment))               AS Segment,
    MIN(TRIM(Country))               AS Country,
    MIN(TRIM(City))                  AS City,
    MIN(TRIM(State))                 AS State,
    MIN(TRIM(Postal_Code))           AS PostalCode,
    MIN(TRIM(Region))                AS Region
 
INTO silver.customers
 
FROM bronze.raw_superstore
 
WHERE Customer_ID IS NOT NULL
  AND TRIM(Customer_ID) <> ''
 
GROUP BY TRIM(Customer_ID);
GO
 
PRINT '>> silver.customers created';
GO
 --STEP 4 : Make CustomerID NOT NULL then add Primary Key
 
ALTER TABLE silver.customers
    ALTER COLUMN CustomerID NVARCHAR(20) NOT NULL;
GO
 
ALTER TABLE silver.customers
    ADD CONSTRAINT PK_silver_customers
    PRIMARY KEY (CustomerID);
GO
 
PRINT '>> Primary key added on CustomerID';
GO
-- ── STEP 5 : Quality Checks
 
-- 5.1  Total unique customers
SELECT COUNT(*) AS Total_Customers
FROM silver.customers;
-- Expected: 793 unique customers
 
-- 5.2  Preview the data
SELECT TOP 10 *
FROM silver.customers
ORDER BY CustomerID;
 
-- 5.3  Confirm AA-10315 now appears exactly once
SELECT *
FROM silver.customers
WHERE CustomerID = 'AA-10315';
-- Expected: exactly 1 row
 
-- 5.4  Null check on all columns
SELECT
    SUM(CASE WHEN CustomerID   IS NULL OR CustomerID   = '' THEN 1 ELSE 0 END) AS Null_CustomerID,
    SUM(CASE WHEN CustomerName IS NULL OR CustomerName = '' THEN 1 ELSE 0 END) AS Null_CustomerName,
    SUM(CASE WHEN Segment      IS NULL OR Segment      = '' THEN 1 ELSE 0 END) AS Null_Segment,
    SUM(CASE WHEN Region       IS NULL OR Region       = '' THEN 1 ELSE 0 END) AS Null_Region
FROM silver.customers;
-- Expected: all zeros
 
-- 5.5  Distinct Segment values
SELECT Segment, COUNT(*) AS CustomerCount
FROM silver.customers
GROUP BY Segment;
-- Expected: Consumer, Corporate, Home Office
 
-- 5.6  Distinct Region values
SELECT Region, COUNT(*) AS CustomerCount
FROM silver.customers
GROUP BY Region;
-- Expected: East, West, Central, South
 