USE SuperstoreDW;
GO
 
-- ── STEP 1 : Drop table if it already exists
IF OBJECT_ID('silver.regions', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.regions;
    PRINT '>> Old silver.regions dropped';
END
GO
-- ── STEP 2 : Create silver.regions using GROUP BY
SELECT
    TRIM(Region)                         AS Region,
    TRIM(State)                          AS State,
    TRIM(City)                           AS City,
    MIN(TRIM(Postal_Code))               AS PostalCode
 
INTO silver.regions
 
FROM bronze.raw_superstore
 
WHERE Region IS NOT NULL
  AND TRIM(Region) <> ''
  AND State  IS NOT NULL
  AND TRIM(State)  <> ''
  AND City   IS NOT NULL
  AND TRIM(City)   <> ''
 
GROUP BY
    TRIM(Region),
    TRIM(State),
    TRIM(City);
GO
 
PRINT '>> silver.regions created';
GO
ALTER TABLE silver.regions
    ALTER COLUMN Region NVARCHAR(50)  NOT NULL;
GO
ALTER TABLE silver.regions
    ALTER COLUMN State  NVARCHAR(100) NOT NULL;
GO
ALTER TABLE silver.regions
    ALTER COLUMN City   NVARCHAR(100) NOT NULL;
GO
 
ALTER TABLE silver.regions
    ADD CONSTRAINT PK_silver_regions
    PRIMARY KEY (Region, State, City);
GO
 
PRINT '>> Composite primary key added on Region + State + City';
GO

-- ── STEP 4 : Quality Checks
 
-- 4.1  Total unique location rows
SELECT COUNT(*) AS Total_Region_Rows
FROM silver.regions;
 
-- 4.2  Preview
SELECT TOP 15 *
FROM silver.regions
ORDER BY Region, State, City;
 
-- 4.3  Null check
SELECT
    SUM(CASE WHEN Region     IS NULL OR Region     = '' THEN 1 ELSE 0 END) AS Null_Region,
    SUM(CASE WHEN State      IS NULL OR State      = '' THEN 1 ELSE 0 END) AS Null_State,
    SUM(CASE WHEN City       IS NULL OR City       = '' THEN 1 ELSE 0 END) AS Null_City
FROM silver.regions;
-- Expected: all zeros
 
-- 4.4  Distinct Regions (should be exactly 4)
SELECT Region, COUNT(*) AS CityCount
FROM silver.regions
GROUP BY Region
ORDER BY Region;
-- Expected: Central, East, South, West
 
-- 4.5  Distinct States count
SELECT COUNT(DISTINCT State) AS Total_States
FROM silver.regions;
 
-- 4.6  No duplicate composite key
SELECT Region, State, City, COUNT(*) AS Cnt
FROM silver.regions
GROUP BY Region, State, City
HAVING COUNT(*) > 1;
-- Expected: 0 rows
 
GO
PRINT '>> silver.regions complete. Next: 10_silver_dates.sql';
GO
 