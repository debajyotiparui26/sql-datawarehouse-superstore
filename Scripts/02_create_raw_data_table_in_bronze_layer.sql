USE SuperstoreDW;
GO


-- DROP OLD TABLE


IF OBJECT_ID('bronze.raw_superstore', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.raw_superstore;
    PRINT '>> Old bronze.raw_superstore dropped';
END
GO



-- CREATE BRONZE TABLE


CREATE TABLE bronze.raw_superstore
(
    -- Order Info
    Row_ID         NVARCHAR(20),
    Order_ID       NVARCHAR(50),
    Order_Date     NVARCHAR(50),
    Ship_Date      NVARCHAR(50),
    Ship_Mode      NVARCHAR(100),

    -- Customer Info
    Customer_ID    NVARCHAR(50),
    Customer_Name  NVARCHAR(200),
    Segment        NVARCHAR(100),

    -- Location Info
    Country        NVARCHAR(100),
    City           NVARCHAR(100),
    State          NVARCHAR(100),
    Postal_Code    NVARCHAR(20),
    Region         NVARCHAR(100),

    -- Product Info
    Product_ID     NVARCHAR(100),
    Category       NVARCHAR(100),
    Sub_Category   NVARCHAR(100),
    Product_Name   NVARCHAR(500),

    -- Sales Metrics
    Sales          NVARCHAR(50),
    Quantity       NVARCHAR(50),
    Discount       NVARCHAR(50),
    Profit         NVARCHAR(50)
);
GO

PRINT '>> bronze.raw_superstore table created successfully';
GO


-- =========================================
-- CHECK COLUMNS
-- =========================================

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'bronze'
AND TABLE_NAME = 'raw_superstore'
ORDER BY ORDINAL_POSITION;
GO