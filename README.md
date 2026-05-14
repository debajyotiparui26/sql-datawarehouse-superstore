# sql-datawarehouse-superstore
Superstore Sales Data Warehouse built with Microsoft SQL Server using Medallion Architecture (Bronze → Silver → Gold layers) and Star Schema. Includes data cleaning, type conversion, and surrogate keys. Dataset from Kaggle.
🏗️ Medallion Architecture
🥉 Bronze Layer — Raw Data

The Bronze layer stores the CSV exactly as received.

Features
All columns stored as NVARCHAR
No transformations
Permanent backup of source data
Loaded using BULK INSERT
Bronze Table
Table	Description
bronze.raw_superstore	Raw CSV data
🥈 Silver Layer — Cleaned Data

The Silver layer performs:

Data cleaning
Type conversion
Deduplication
Splitting into logical tables
Silver Tables
Table	Purpose
silver.customers	Customer dimension source
silver.products	Product dimension source
silver.orders	Clean transactional orders
silver.regions	Geographic locations
silver.dates	Calendar date table
Key Concepts Used
TRY_CAST()
TRY_CONVERT()
GROUP BY + MIN()
TRIM()
ISNULL()

🥇 Gold Layer — Star Schema

The Gold layer creates a reporting-ready Star Schema.

Dimension Tables
Table	Description
gold.Dim_Customer	Customer information
gold.Dim_Product	Product information
gold.Dim_Date	Calendar dimension
gold.Dim_Region	Geography dimension
Fact Table
Table	Description
gold.Fact_Sales	Central transaction table
Key Concepts Used
IDENTITY(1,1) surrogate keys
Primary keys
Foreign keys
Fact & Dimension modeling
Star Schema design
⭐ Star Schema Design

The Gold layer follows a classic Star Schema model where:

Fact_Sales is the central fact table
Dimension tables provide descriptive attributes
Foreign keys connect facts to dimensions
Optimized for Power BI and analytics reporting
⚙️ Requirements
Tool	Version
Microsoft SQL Server	2019 or 2022
SQL Server Management Studio	19+
Power BI Desktop	Latest
Downloads
SQL Server: https://www.microsoft.com/sql-server/sql-server-downloads
SSMS: https://learn.microsoft.com/sql/ssms/download-sql-server-management-studio-ssms
🚀 Process Flow
Download the Superstore CSV dataset from Kaggle.
Create the database and schemas in SQL Server.
Load raw CSV data into the Bronze layer using BULK INSERT.
Clean and transform the data in the Silver layer.
Build dimension and fact tables in the Gold layer.
Run analytical SQL queries on the Star Schema.
Connect the Gold layer to Power BI for reporting and dashboards.
🔧 Common Errors and Fixes
Error	Cause	Fix
Cannot bulk load — access denied	SSMS not admin	Run SSMS as Administrator
File not found	Wrong path	Check CSV path carefully
Duplicate key error	Duplicate rows	Use GROUP BY + MIN()
NVARCHAR to numeric conversion failed	Dirty numeric data	Use TRY_CAST()
Red underlines in SSMS	IntelliSense cache	Press Ctrl + Shift + R
Wrong row count	CSV line endings	Change ROWTERMINATOR
📚 Concepts Learned

This project helps you learn:

Medallion Architecture
SQL Server Schemas
BULK INSERT
ETL Pipelines
Data Cleaning
TRY_CAST / TRY_CONVERT
Star Schema Design
Fact & Dimension Tables
Surrogate Keys
Foreign Keys
Data Quality Checks
Power BI Integration
📈 Project Summary
Layer	Tables	Purpose
Bronze	1	Raw backup data
Silver	5	Cleaned and transformed data
Gold	5	Analytics-ready star schema
Total	11	Complete warehouse
🧠 Future Improvements

You can extend this project by adding:

Incremental loading
Stored procedures
SQL Server Agent scheduling
Slowly Changing Dimensions (SCD)
Data validation logging
Power BI dashboards
SSIS pipelines
Azure Data Factory integration
