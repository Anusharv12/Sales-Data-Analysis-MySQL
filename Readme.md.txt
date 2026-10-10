# Sales Data Analysis Using MySQL

## Project Overview
This project analyzes sales data using MySQL to identify sales trends, top-performing products, customer purchasing behavior, and category performance.

## Tools Used
- MySQL
- MySQL Workbench
- SQL

## Dataset
The dataset contains three tables:
- **Orders:** Order dates, customers, products, quantities, discounts, and sales.
- **Customers:** Customer IDs and customer names.
- **Products:** Product names, categories, and unit prices.

## Key Analysis
- Overall sales and order performance
- Top-performing products by sales
- Sales performance by product category
- Top customers by sales
- Monthly and yearly sales trends
- Sales comparison between January–September 2025 and 2026
- Discount analysis
- Top three products in each category
- Repeat customer analysis
- Data quality checks for missing values, duplicate IDs, invalid values, and unmatched records

## Key Findings
- Total recorded sales: **17,266,091**
- Total order records: **750**
- Total units sold: **2,117**
- Electronics generated the highest recorded sales among the four product categories.
- The project includes monthly and year-over-year comparisons to explore changes in sales performance.

## SQL Concepts Practiced
- SELECT and WHERE
- Aggregate functions
- GROUP BY and ORDER BY
- JOINs
- Common Table Expressions (CTEs)
- Window functions
- Data quality checks

## Project Files
- `sql/sales_analysis.sql` — SQL queries used for analysis
- `dataset/` — Dataset files

## Conclusion
This project demonstrates the use of SQL to explore sales data, evaluate business performance, and derive insights that can support data-driven decision-making.