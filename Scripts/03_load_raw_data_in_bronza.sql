USE SuperstoreDW;
GO


-- STEP 1 : CLEAN TABLE
TRUNCATE TABLE bronze.raw_superstore;
GO

PRINT '>> Table truncated';
GO


BULK INSERT bronze.raw_superstore
FROM 'D:\SQL Exam\superstore_db_warehousing_project\SQL Server Scripts1\SQL Server Scripts1\Sample - Superstore.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = 'ACP',
    TABLOCK
);
GO

PRINT '>> BULK INSERT complete';
GO


--  STEP 3 : VALIDATE THE LOAD

 
-- ── 3.1  Total row count  
SELECT COUNT(*) AS Total_Rows_Loaded
FROM bronze.raw_superstore;
-- Expected result: 9994
 
-- ── 3.2  Preview first 10 rows 
SELECT TOP 10 *
FROM bronze.raw_superstore;
 
-- ── 3.3  Check for any completely empty rows 
SELECT COUNT(*) AS Empty_Order_ID_Rows
FROM bronze.raw_superstore
WHERE Order_ID IS NULL
   OR Order_ID = '';
 
-- ── 3.4  Check distinct values in key columns 
SELECT DISTINCT Segment  FROM bronze.raw_superstore;  
SELECT DISTINCT Region   FROM bronze.raw_superstore;  
SELECT DISTINCT Category FROM bronze.raw_superstore;  
 
-- ── 3.5  Check min and max order dates 
   SELECT MIN(Order_Date) AS Earliest_Order,
    MAX(Order_Date) AS Latest_Order
FROM bronze.raw_superstore;
-- Expected: 2016 to 2019 range
 
-- ── 3.6  Spot check one customer 
SELECT *
FROM bronze.raw_superstore
WHERE Customer_Name = 'Claire Gute';
 
GO
PRINT '>> Bronze validation complete. Check row counts above.';
GO
 