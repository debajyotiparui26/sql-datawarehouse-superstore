USE SuperstoreDW;
GO
 
-- ── STEP 1 : Drop table if it already exists
IF OBJECT_ID('silver.orders', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.orders;
    PRINT '>> Old silver.orders dropped';
END
GO
--Create silver.orders
SELECT
    -- ── Identifiers ───────────────────────────────────────────
    TRIM(Row_ID)                                            AS RowID,
    TRIM(Order_ID)                                          AS OrderID,
    TRIM(Customer_ID)                                       AS CustomerID,
    TRIM(Product_ID)                                        AS ProductID,
 
    -- ── Dates: TRY_CONVERT handles bad date strings safely ────
    TRY_CONVERT(DATE, TRIM(Order_Date), 101)                AS OrderDate,
    TRY_CONVERT(DATE, TRIM(Ship_Date),  101)                AS ShipDate,
 
    -- ── DaysToShip: only calculate when both dates are valid ──
    CASE
        WHEN TRY_CONVERT(DATE, TRIM(Order_Date), 101) IS NOT NULL
         AND TRY_CONVERT(DATE, TRIM(Ship_Date),  101) IS NOT NULL
        THEN DATEDIFF(
                DAY,
                TRY_CONVERT(DATE, TRIM(Order_Date), 101),
                TRY_CONVERT(DATE, TRIM(Ship_Date),  101)
             )
        ELSE NULL
    END                                                     AS DaysToShip,
 
    -- ── Shipping 
    TRIM(Ship_Mode)                                         AS ShipMode,
 
    -- ── Location 
    TRIM(Region)                                            AS Region,
    TRIM(State)                                             AS State,
    TRIM(City)                                              AS City,
    TRIM(Postal_Code)                                       AS PostalCode,
 
    -- ── Metrics: TRY_CAST + ISNULL = safe conversion
    -- If a value cannot convert, it becomes 0 (not a crash)
    ISNULL(TRY_CAST(TRIM(Sales)    AS DECIMAL(10,2)), 0)    AS Sales,
    ISNULL(TRY_CAST(TRIM(Quantity) AS INT),           0)    AS Quantity,
    ISNULL(TRY_CAST(TRIM(Discount) AS DECIMAL(5,4)),  0)    AS Discount,
    ISNULL(TRY_CAST(TRIM(Profit)   AS DECIMAL(10,2)), 0)    AS Profit
 
INTO silver.orders
 
FROM bronze.raw_superstore
 
WHERE Order_ID IS NOT NULL
  AND TRIM(Order_ID) <> '';
GO
 
PRINT '>> silver.orders created';
GO
--  STEP 4 : Make RowID NOT NULL then add Primary Key
 
ALTER TABLE silver.orders
    ALTER COLUMN RowID NVARCHAR(10) NOT NULL;
GO
 
ALTER TABLE silver.orders
    ADD CONSTRAINT PK_silver_orders
    PRIMARY KEY (RowID);
GO
 
PRINT '>> Primary key added on RowID';
GO

--  STEP 5 : QUALITY CHECKS
 
-- 5.1  Row count must match Bronze exactly
SELECT COUNT(*) AS Total_Rows
FROM silver.orders;
-- Expected: 9994
 
-- 5.2  Preview with correct types
SELECT TOP 10
    OrderID, OrderDate, ShipDate, DaysToShip,
    ShipMode, Sales, Quantity, Discount, Profit
FROM silver.orders
ORDER BY OrderDate;
 
-- 5.3  Null check on critical columns
SELECT
    SUM(CASE WHEN OrderID    IS NULL THEN 1 ELSE 0 END) AS Null_OrderID,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS Null_CustomerID,
    SUM(CASE WHEN ProductID  IS NULL THEN 1 ELSE 0 END) AS Null_ProductID,
    SUM(CASE WHEN OrderDate  IS NULL THEN 1 ELSE 0 END) AS Null_OrderDate,
    SUM(CASE WHEN Sales      IS NULL THEN 1 ELSE 0 END) AS Null_Sales
FROM silver.orders;
-- Expected: all zeros
 
-- 5.4  Check if any rows landed with Sales = 0 due to bad data
SELECT COUNT(*) AS Suspicious_Zero_Sales
FROM silver.orders
WHERE Sales = 0;
-- If this is more than a handful, go back to Step 1 diagnostics
 
-- 5.5  Date range check
SELECT
    MIN(OrderDate) AS Earliest_Order,
    MAX(OrderDate) AS Latest_Order
FROM silver.orders;
-- Expected: 2016 to 2019
 
-- 5.6  Sales and Profit totals
SELECT
    ROUND(SUM(Sales),  2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM silver.orders;
 
 
 
