🏪 Superstore Data Warehouse
SQL Server · Medallion Architecture · Bronze → Silver → Gold

A beginner-friendly Data Warehouse project built using Superstore Sales Dataset and Microsoft SQL Server.

This project implements the industry-standard Medallion Architecture:

🥉 Bronze Layer → Raw CSV data
🥈 Silver Layer → Cleaned & transformed data
🥇 Gold Layer → Star Schema for analytics & Power BI reporting

Perfect for beginners learning:

Data Warehousing
SQL Server
ETL Pipelines
Star Schema Design
Power BI Integration

🏗️ Three Layers
🥉 Bronze Layer
Purpose
Stores raw CSV data
No transformation applied
Used as source backup layer
Table
bronze.raw_superstore

🥈 Silver Layer
Purpose
Cleans and transforms data
Removes duplicates
Converts data types
Splits data into logical tables
Tables
silver.customers
silver.products
silver.orders
silver.regions
silver.dates

🥇 Gold Layer
Purpose
Creates reporting-ready star schema
Uses dimension and fact tables
Final analytics layer
Tables
gold.Dim_Customer
gold.Dim_Product
gold.Dim_Date
gold.Dim_Region
gold.Fact_Sales

🚀 Process Flow
Load CSV data into Bronze layer
Clean and transform data in Silver layer
Build dimension and fact tables in Gold layer
Run analytical queries on the final warehouse

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

Layer	  Tables	      Purpose
Bronze	  1	      Raw backup data
Silver	  5	      Cleaned and transformed data
Gold	    5	      Analytics-ready star schema
Total	    11	    Complete warehouse
