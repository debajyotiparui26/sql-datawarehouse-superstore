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


# Superstore Business Intelligence Suite 📊

An end-to-end Power BI intelligence application designed to simulate real-world enterprise reporting. This multi-page suite transforms raw transactional retail data into interconnected, actionable executive dashboards by mapping high-level financial goals down to granular inventory and regional supply chain logistics.

---

## 📝 Educational Project Disclaimer
This portfolio project was created solely for educational purposes to showcase Power BI data visualization and business intelligence engineering skills. It utilizes open-source sample data, is not affiliated with any commercial entity, and all trademarks belong to their respective owners.

---

## 🏗️ Data Architecture & Modeling
The foundation of this suite is built on a clean **Star Schema** dataset framework, maximizing query performance and filtering efficiency:
* **Fact Table:** `gold Fact_Sales` (Centralized transactional rows tracking quantities, sales, profit, discounts, and delivery timelines).
* **Dimension Tables:** 
  * `gold Dim_Customer` (Segment, Customer ID, Profile details)
  * `gold Dim_Product` (Category, SubCategory, Product Name hierarchy)
  * `gold Dim_Region` (Country, Region, State, City geography mapping)
  * `gold Dim_Date` (Fiscal calendar mapping for Year, Quarter, Month, and YearMonth granular timelines)
 
<img width="1002" height="781" alt="Screenshot 2026-06-15 185225" src="https://github.com/user-attachments/assets/5a87abaa-8ceb-4c7a-84d9-a6b49f46b1c3" />


---

## 🖥️ Dashboard Features & Architecture

### 1️⃣ Page 1: Sales Performance Overview
* **Focus:** Macro-level executive snapshot monitoring revenue streams, transaction volumes, and performance targets.
* **Key KPIs:** Total Sales ($132K), Total Orders (648), Total Customers (793), and Avg Shipping Days (4.04).
* **Key Visuals:** Target Gauge chart for side-by-side quota tracking, segmented Donut chart detailing consumer market share (46.14%), and synchronized parallel timeline trend lines.

### 2️⃣ Page 2: Product Insights & Profitability
* **Focus:** Deep-dive inventory diagnostics, cost efficiency, and product line rank shifts.
* **Key KPIs:** Units Sold (2K) and Average Price per Unit ($54).
* **Key Visuals:** Structural High-Density Treemap for item sizing, Waterfall Chart for category volume walks, Scatter Chart pinpointing distribution speed outliers, and an interactive Ribbon Chart mapping category popularity over multiple fiscal years.

### 3️⃣ Page 3: Regional Logistics
* **Focus:** Geographic market penetration, localized territory metrics, and shipping carrier efficiencies.
* **Key KPIs:** Top Region Sales ($43K) and active geographic distribution reach across 531 Cities.
* **Key Visuals:** Geographic Filled Map tracking market concentration, custom Logistics Matrix Ledger for carrier audit tracking, and an AI-driven Decomposition Tree allowing interactive root-cause drill-downs from macro regions to local target cities.

---

## 🛠️ Core Technical Skills Demonstrated

* **Star Schema Modeling:** Engineered a robust relational data network, cleanly isolating transactional facts from dimensional lookup tables.
* **Advanced DAX Analytics:** Authored clean, explicit calculated measures using `SUM`, `DISTINCTCOUNT`, `AVERAGE`, and `DIVIDE` to handle dynamic formatting and ratio percentages.
* **UX/UI Best Practices:** Applied a modern "glassmorphism" style layout featuring semi-transparent container cards (80% opacity) with subtle drop shadows to prioritize text scannability and high visual contrast.

---

## 🚀 How to Explore the Project
1. Clone or download the repository contents.
2. Ensure you have the latest version of **Power BI Desktop** installed.
3. Open the `.pbix` project file to explore the dynamic filtering, drill-downs, and interactive tooltips across all 3 dashboard tabs.

<img width="1315" height="737" alt="Screenshot 2026-06-16 233006" src="https://github.com/user-attachments/assets/3547a237-be27-48b4-a645-7296ba0f7370" />

<img width="1315" height="739" alt="Screenshot 2026-06-16 233050" src="https://github.com/user-attachments/assets/461474c8-bd8f-4e14-a231-868a5069e6a0" />

<img width="1311" height="737" alt="Screenshot 2026-06-16 233143" src="https://github.com/user-attachments/assets/8956ca0a-568d-491e-babf-52a20cd1fe34" />


