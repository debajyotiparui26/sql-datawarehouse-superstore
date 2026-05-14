USE SuperstoreDW;
GO
 
--STEP 1 : Drop table if it already exists
IF OBJECT_ID('gold.Fact_Sales', 'U') IS NOT NULL
BEGIN
    DROP TABLE gold.Fact_Sales;
    PRINT '>> Old gold.Fact_Sales dropped';
END
GO
-- ── STEP 2 : Create Fact_Sales
CREATE TABLE gold.Fact_Sales
(
    
    SalesKey        INT             NOT NULL IDENTITY(1,1),
    OrderID         NVARCHAR(50)    NOT NULL,
    RowID           NVARCHAR(10)    NOT NULL,
    DateKey         INT             NOT NULL,   
    CustomerKey     INT             NOT NULL,   
    ProductKey      INT             NOT NULL,   
    RegionKey       INT             NOT NULL,   
    ShipMode        NVARCHAR(50)    NOT NULL,
    ShipDate        DATE                NULL,
    DaysToShip      INT                 NULL,
    Quantity        INT             NOT NULL,
    Sales           DECIMAL(10,2)   NOT NULL,
    Discount        DECIMAL(5,4)    NOT NULL,
    Profit          DECIMAL(10,2)   NOT NULL,
    DWLoadDate      DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_Fact_Sales PRIMARY KEY (SalesKey),
    CONSTRAINT FK_Fact_Sales_Date
        FOREIGN KEY (DateKey)
        REFERENCES gold.Dim_Date (DateKey),
 
    CONSTRAINT FK_Fact_Sales_Customer
        FOREIGN KEY (CustomerKey)
        REFERENCES gold.Dim_Customer (CustomerKey),
 
    CONSTRAINT FK_Fact_Sales_Product
        FOREIGN KEY (ProductKey)
        REFERENCES gold.Dim_Product (ProductKey),
 
    CONSTRAINT FK_Fact_Sales_Region
        FOREIGN KEY (RegionKey)
        REFERENCES gold.Dim_Region (RegionKey)
);
GO
 
PRINT '>> gold.Fact_Sales table created (empty)';
GO
-- STEP 3 : Load data from Silver + Dimension tables

INSERT INTO gold.Fact_Sales
(
    OrderID,
    RowID,
    DateKey,
    CustomerKey,
    ProductKey,
    RegionKey,
    ShipMode,
    ShipDate,
    DaysToShip,
    Quantity,
    Sales,
    Discount,
    Profit
)
SELECT
    o.OrderID,
    o.RowID,
    d.DateKey,
    c.CustomerKey,
    p.ProductKey,
    r.RegionKey,
 
    o.ShipMode,
    o.ShipDate,
    o.DaysToShip,
    o.Quantity,
    o.Sales,
    o.Discount,
    o.Profit
 
FROM silver.orders o
 
-- Join to Dim_Date: match on the YYYYMMDD integer key
INNER JOIN gold.Dim_Date d
    ON d.DateKey = CAST(FORMAT(o.OrderDate, 'yyyyMMdd') AS INT)
 
-- Join to Dim_Customer: match on the original CustomerID text
INNER JOIN gold.Dim_Customer c
    ON c.CustomerID = o.CustomerID
 
-- Join to Dim_Product: match on the original ProductID text
INNER JOIN gold.Dim_Product p
    ON p.ProductID = o.ProductID
 
-- Join to Dim_Region: match on Region + State + City combination
INNER JOIN gold.Dim_Region r
    ON  r.Region = o.Region
    AND r.State  = o.State
    AND r.City   = o.City;
GO
 
PRINT '>> gold.Fact_Sales loaded';
GO

-- ── STEP 4 : Quality Checks 
 
-- 4.1  Row count must match silver.orders exactly
SELECT COUNT(*) AS Fact_Sales_Rows  FROM gold.Fact_Sales;
SELECT COUNT(*) AS Silver_Order_Rows FROM silver.orders;
-- CRITICAL: both must be equal (9994)
 
-- 4.2  Preview the fact table with all foreign keys
SELECT TOP 10 *
FROM gold.Fact_Sales
ORDER BY SalesKey;
 
-- 4.3  NULL check on all foreign keys

SELECT
    SUM(CASE WHEN DateKey     IS NULL THEN 1 ELSE 0 END) AS Null_DateKey,
    SUM(CASE WHEN CustomerKey IS NULL THEN 1 ELSE 0 END) AS Null_CustomerKey,
    SUM(CASE WHEN ProductKey  IS NULL THEN 1 ELSE 0 END) AS Null_ProductKey,
    SUM(CASE WHEN RegionKey   IS NULL THEN 1 ELSE 0 END) AS Null_RegionKey
FROM gold.Fact_Sales;
-- Expected: all zeros
 
-- 4.4  Total Sales and Profit (should match silver.orders)
SELECT
    ROUND(SUM(Sales),  2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity)         AS Total_Quantity,
    COUNT(*)              AS Total_Rows
FROM gold.Fact_Sales;
 
-- Compare with silver:
SELECT
    ROUND(SUM(Sales),  2) AS Silver_Total_Sales,
    ROUND(SUM(Profit), 2) AS Silver_Total_Profit
FROM silver.orders;
