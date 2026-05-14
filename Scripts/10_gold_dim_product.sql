USE SuperstoreDW;
GO
 
-- STEP 1 : Drop table if it already exists
IF OBJECT_ID('gold.Dim_Product', 'U') IS NOT NULL
BEGIN
    DROP TABLE gold.Dim_Product;
    PRINT '>> Old gold.Dim_Product dropped';
END
GO
-- ── STEP 2 : Create Dim_Product
CREATE TABLE gold.Dim_Product
(
    -- Surrogate key
    ProductKey      INT             NOT NULL IDENTITY(1,1),
    ProductID       NVARCHAR(50)    NOT NULL,
    Category        NVARCHAR(50)    NOT NULL, 
    SubCategory     NVARCHAR(50)    NOT NULL, 
    ProductName     NVARCHAR(500)   NOT NULL,  
    DWLoadDate      DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_Dim_Product PRIMARY KEY (ProductKey)
);
GO
 
PRINT '>> gold.Dim_Product table created (empty)';
GO
 --STEP 3 : Load data from Silver
INSERT INTO gold.Dim_Product
(
    ProductID,
    Category,
    SubCategory,
    ProductName
)
SELECT
    ProductID,
    Category,
    SubCategory,
    ProductName
FROM silver.products;
GO
 
PRINT '>> gold.Dim_Product loaded from silver.products';
GO

-- ── STEP 4 : Quality Checks
 
-- 4.1  Row count must match silver.products
SELECT COUNT(*) AS Dim_Product_Rows   FROM gold.Dim_Product;
SELECT COUNT(*) AS Silver_Product_Rows FROM silver.products;
-- Both must be equal
 
-- 4.2  Preview
SELECT TOP 10 *
FROM gold.Dim_Product
ORDER BY Category, SubCategory;
 
-- 4.3  Key range check
SELECT
    MIN(ProductKey) AS First_Key,
    MAX(ProductKey) AS Last_Key,
    COUNT(*)        AS Total_Rows
FROM gold.Dim_Product;
 
-- 4.4  No duplicate ProductIDs
SELECT ProductID, COUNT(*) AS Cnt
FROM gold.Dim_Product
GROUP BY ProductID
HAVING COUNT(*) > 1;
-- Expected: 0 rows
 