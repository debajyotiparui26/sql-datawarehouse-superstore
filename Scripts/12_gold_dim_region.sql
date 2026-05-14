USE SuperstoreDW;
GO
 
-- ── STEP 1 : Drop table if it already exists
IF OBJECT_ID('gold.Dim_Region', 'U') IS NOT NULL
BEGIN
    DROP TABLE gold.Dim_Region;
    PRINT '>> Old gold.Dim_Region dropped';
END
GO
--STEP 2 : Create Dim_Region
CREATE TABLE gold.Dim_Region
(
    RegionKey       INT             NOT NULL IDENTITY(1,1),
    Region          NVARCHAR(50)    NOT NULL,   
    State           NVARCHAR(100)   NOT NULL,   
    City            NVARCHAR(100)   NOT NULL,   
    PostalCode      NVARCHAR(20)        NULL,   
    DWLoadDate      DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_Dim_Region PRIMARY KEY (RegionKey)
);
GO
 
PRINT '>> gold.Dim_Region table created (empty)';
GO

 --STEP 3 : Load data from Silver
INSERT INTO gold.Dim_Region
(
    Region,
    State,
    City,
    PostalCode
)
SELECT
    Region,
    State,
    City,
    PostalCode
FROM silver.regions;
GO
 
PRINT '>> gold.Dim_Region loaded from silver.regions';
GO

-- ── STEP 4 : Quality Checks
 
-- 4.1  Row count
SELECT COUNT(*) AS Dim_Region_Rows   FROM gold.Dim_Region;
SELECT COUNT(*) AS Silver_Region_Rows FROM silver.regions;
-- Both must be equal
 
-- 4.2  Preview
SELECT TOP 10 *
FROM gold.Dim_Region
ORDER BY Region, State, City;
 
-- 4.3  Key range check
SELECT
    MIN(RegionKey) AS First_Key,
    MAX(RegionKey) AS Last_Key,
    COUNT(*)       AS Total_Rows
FROM gold.Dim_Region;
 
-- 4.4  Region breakdown
SELECT Region, COUNT(*) AS CityCount
FROM gold.Dim_Region
GROUP BY Region
ORDER BY Region;
-- Expected: Central, East, South, West
 