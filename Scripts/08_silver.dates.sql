USE SuperstoreDW;
GO
 
-- ── STEP 1 : Drop table if it already exists 
IF OBJECT_ID('silver.dates', 'U') IS NOT NULL
BEGIN
    DROP TABLE silver.dates;
    PRINT '>> Old silver.dates dropped';
END
GO
--STEP 2 : Create silver.dates using GROUP BY
SELECT DISTINCT

    CONVERT(DATE, TRIM(Order_Date), 101) AS FullDate,
    YEAR(CONVERT(DATE, TRIM(Order_Date), 101)) AS Year,
    DATEPART(QUARTER, CONVERT(DATE, TRIM(Order_Date), 101)) AS Quarter,
    MONTH(CONVERT(DATE, TRIM(Order_Date), 101)) AS MonthNum,
    DATENAME(MONTH, CONVERT(DATE, TRIM(Order_Date), 101)) AS MonthName,
    DAY(CONVERT(DATE, TRIM(Order_Date), 101)) AS DayNum,
    DATENAME(WEEKDAY, CONVERT(DATE, TRIM(Order_Date), 101)) AS DayName,
    DATEPART(WEEK, CONVERT(DATE, TRIM(Order_Date), 101)) AS WeekNum,

    -- Weekend Check
    CASE
        WHEN DATEPART(WEEKDAY, CONVERT(DATE, TRIM(Order_Date), 101))
             IN (1, 7)
        THEN 1
        ELSE 0
    END AS IsWeekend,

    -- Year-Month Label
    FORMAT(CONVERT(DATE, TRIM(Order_Date), 101), 'yyyy-MMM') AS YearMonth

INTO silver.dates

FROM bronze.raw_superstore

WHERE Order_Date IS NOT NULL
      AND TRIM(Order_Date) <> '';

GO

PRINT '>> silver.dates created';

GO
 
-- ── STEP 3 : Make FullDate NOT NULL then add Primary Key ──────
ALTER TABLE silver.dates
    ALTER COLUMN FullDate DATE NOT NULL;
GO
 
ALTER TABLE silver.dates
    ADD CONSTRAINT PK_silver_dates
    PRIMARY KEY (FullDate);
GO
 
-- ── STEP 4 : Quality Checks
 
-- 4.1  Total unique dates
SELECT COUNT(*) AS Total_Unique_Dates
FROM silver.dates;
-- Expected: around 1236 unique order dates
 
-- 4.2  Preview
SELECT TOP 15 *
FROM silver.dates
ORDER BY FullDate;
 
-- 4.3  Date range
SELECT
    MIN(FullDate) AS Earliest_Date,
    MAX(FullDate) AS Latest_Date
FROM silver.dates;
-- Expected: 2014 to 2017
 
-- 4.4  Rows per year
SELECT Year, COUNT(*) AS DateCount
FROM silver.dates
GROUP BY Year
ORDER BY Year;
 



 
