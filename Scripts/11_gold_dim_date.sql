USE SuperstoreDW;
GO
 
-- ── STEP 1 : Drop table if it already exists
IF OBJECT_ID('gold.Dim_Date', 'U') IS NOT NULL
BEGIN
    DROP TABLE gold.Dim_Date;
    PRINT '>> Old gold.Dim_Date dropped';
END
GO
-- STEP 2 : Create Dim_Date
CREATE TABLE gold.Dim_Date
(
    DateKey         INT             NOT NULL,   
    FullDate        DATE            NOT NULL,   
    Year            INT             NOT NULL,   
    Quarter         INT             NOT NULL,   
    QuarterLabel    NVARCHAR(10)    NOT NULL,   
    MonthNum        INT             NOT NULL,   
    MonthName       NVARCHAR(20)    NOT NULL,   
    DayNum          INT             NOT NULL,   
    DayName         NVARCHAR(20)    NOT NULL,   
    WeekNum         INT             NOT NULL,   
    IsWeekend       TINYINT         NOT NULL,   
    YearMonth       NVARCHAR(10)    NOT NULL,   
    YearQuarter     NVARCHAR(10)    NOT NULL,   
    DWLoadDate      DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_Dim_Date PRIMARY KEY (DateKey)
);
GO
 
PRINT '>> gold.Dim_Date table created (empty)';
GO
INSERT INTO gold.Dim_Date
(
    DateKey,
    FullDate,
    Year,
    Quarter,
    QuarterLabel,
    MonthNum,
    MonthName,
    DayNum,
    DayName,
    WeekNum,
    IsWeekend,
    YearMonth,
    YearQuarter
)
SELECT
    -- DateKey: convert date to YYYYMMDD integer
    CAST(FORMAT(FullDate, 'yyyyMMdd') AS INT)           AS DateKey,
 
    FullDate,
    Year,
    Quarter,
 
    -- e.g. "Q1-2017"
    'Q' + CAST(Quarter AS NVARCHAR(1))
    + '-' + CAST(Year AS NVARCHAR(4))                   AS QuarterLabel,
 
    MonthNum,
    MonthName,
    DayNum,
    DayName,
    WeekNum,
    IsWeekend,
    YearMonth,
 
    -- e.g. "2017-Q1"
    CAST(Year AS NVARCHAR(4))
    + '-Q' + CAST(Quarter AS NVARCHAR(1))               AS YearQuarter
 
FROM silver.dates;
GO
 
PRINT '>> gold.Dim_Date loaded from silver.dates';
GO
 


 -- ── STEP 3 : Load data from Silve
 INSERT INTO gold.Dim_Date
(
    DateKey,
    FullDate,
    Year,
    Quarter,
    QuarterLabel,
    MonthNum,
    MonthName,
    DayNum,
    DayName,
    WeekNum,
    IsWeekend,
    YearMonth,
    YearQuarter
)
SELECT
    CAST(FORMAT(FullDate, 'yyyyMMdd') AS INT) AS DateKey,

    FullDate,
    Year,
    Quarter,

    CONCAT('Q', Quarter, '-', Year) AS QuarterLabel,

    MonthNum,
    MonthName,
    DayNum,
    DayName,
    WeekNum,
    IsWeekend,
    YearMonth,

    CONCAT(Year, '-Q', Quarter) AS YearQuarter

FROM silver.dates;
GO

PRINT '>> gold.Dim_Date loaded from silver.dates';
GO

-- ── STEP 4 : Quality Checks
 
-- 4.1  Row count
SELECT COUNT(*) AS Dim_Date_Rows   FROM gold.Dim_Date;
SELECT COUNT(*) AS Silver_Date_Rows FROM silver.dates;
-- Both must be equal
 
-- 4.2  Preview
SELECT TOP 10 *
FROM gold.Dim_Date
ORDER BY DateKey;
 
-- 4.3  DateKey format check (must be 8 digits)
SELECT TOP 5
    DateKey,
    LEN(CAST(DateKey AS NVARCHAR(10))) AS KeyLength
FROM gold.Dim_Date
ORDER BY DateKey;
-- KeyLength must always be 8
 
-- 4.4  Date range
SELECT
    MIN(FullDate) AS Earliest,
    MAX(FullDate) AS Latest
FROM gold.Dim_Date;
-- Expected: 2014 to 2017