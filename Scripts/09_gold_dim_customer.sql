USE SuperstoreDW;
GO
 
-- ── STEP 1 : Drop table if it already exists
IF OBJECT_ID('gold.Dim_Customer', 'U') IS NOT NULL
BEGIN
    DROP TABLE gold.Dim_Customer;
    PRINT '>> Old gold.Dim_Customer dropped';
END
GO

-- ── STEP 2 : Create Dim_Customer
CREATE TABLE gold.Dim_Customer
(
    -- Surrogate key
    CustomerKey     INT             NOT NULL IDENTITY(1,1),
    CustomerID      NVARCHAR(20)    NOT NULL,
 
    CustomerName    NVARCHAR(100)   NOT NULL,
    Segment         NVARCHAR(50)    NOT NULL,   
    City            NVARCHAR(100)   NOT NULL,
    State           NVARCHAR(100)   NOT NULL,
    Region          NVARCHAR(50)    NOT NULL,  
    Country         NVARCHAR(50)    NOT NULL,
    PostalCode      NVARCHAR(20)        NULL,
    DWLoadDate      DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_Dim_Customer PRIMARY KEY (CustomerKey)
);
GO
 
PRINT '>> gold.Dim_Customer table created (empty)';
GO
 
 -- STEP 3 : Load data from Silver
INSERT INTO gold.Dim_Customer
(
    CustomerID,
    CustomerName,
    Segment,
    City,
    State,
    Region,
    Country,
    PostalCode
)
SELECT
    CustomerID,
    CustomerName,
    Segment,
    City,
    State,
    Region,
    Country,
    PostalCode
FROM silver.customers;
GO
 
PRINT '>> gold.Dim_Customer loaded from silver.customers';
GO
 
 -- ── STEP 4 : Quality Checks
 
-- 4.1  Row count must match silver.customers
SELECT COUNT(*) AS Dim_Customer_Rows FROM gold.Dim_Customer;
SELECT COUNT(*) AS Silver_Customer_Rows FROM silver.customers;
-- Both numbers must be equal
 
-- 4.2  Preview with surrogate key
SELECT TOP 10 *
FROM gold.Dim_Customer
ORDER BY CustomerKey;
 
-- 4.3  CustomerKey must start at 1 and have no gaps
SELECT
    MIN(CustomerKey) AS First_Key,
    MAX(CustomerKey) AS Last_Key,
    COUNT(*)         AS Total_Rows
FROM gold.Dim_Customer;
-- First_Key = 1, Last_Key = Total_Rows (no gaps)
 
-- 4.4  No duplicate CustomerIDs
SELECT CustomerID, COUNT(*) AS Cnt
FROM gold.Dim_Customer
GROUP BY CustomerID
HAVING COUNT(*) > 1;
-- Expected: 0 rows