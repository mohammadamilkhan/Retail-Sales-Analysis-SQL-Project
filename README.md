# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `retail_data`

## Objectives

1. **Set up a retail sales database**: Create and fill a retail sales database using the given sales data.
2. **Data Cleaning**: Find and remove all records that have missing or null values.
3. **Exploratory Data Analysis (EDA)**: Conduct a preliminary exploratory data analysis (EDA) to gain insights into the dataset.
4. **Business Analysis**: Utilize SQL queries to address specific business questions and extract insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_data`.
- **Table Creation**: A table called `retail_sales_analysis` has been set up to hold the sales data. The structure of this table includes the following columns:

  transaction_id: Unique identifier for each transaction.
  sale_date: The date the sale took place.
  sale_time: The time the sale occurred.
  customer_id: Unique identifier for each customer.
  gender: The gender of the customer.
  age: The age of the customer.
  product_category: The category of the product sold.
  quantity_sold: The number of units sold in the transaction.
  price_per_unit: The price per unit of the product sold.
  cogs: The cost of goods sold for the transaction.
  total_sale_amount: The total sale amount for the transaction.

This table structure allows for comprehensive tracking and analysis of sales data..

```sql
CREATE DATABASE retail_data;

CREATE TABLE retail_sales_analysis
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Calculate the overall count of records in the dataset.
- **Customer Count**: Determine the number of distinct customers in the dataset.
- **Category Count**: Retrieve all the unique product categories from the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales_analysis;
SELECT COUNT(DISTINCT customer_id) AS total_cust FROM retail_sales_analysis;
SELECT DISTINCT category FROM retail_sales_analysis;

SELECT * FROM retail_sales_analysis
WHERE
    transactions_id IS NULL OR sale_date IS NULL OR  sale_time IS NULL OR gender IS NULL
    OR customer_id IS NULL OR age IS NULL OR category IS NULL OR category IS NULL
    OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;

DELETE FROM retail_sales_analysis
WHERE
   transactions_id IS NULL OR sale_date IS NULL OR  sale_time IS NULL OR gender IS NULL
    OR customer_id IS NULL OR age IS NULL OR category IS NULL OR category IS NULL
    OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were created to address particular business questions:

1. **Write a SQL query to find the total sale made by gender category?**:

```sql
SELECT gender, SUM(total_sale) AS total_sales_by_gender
FROM retail_sales_analysis
GROUP BY gender;
```

2. **Write a SQL query to find all transactions where the total_sale is greater than 700?**:

```sql
SELECT * FROM retail_sales_analysis
WHERE total_sale > 700;
```

3. **Write a SQL query to retrieve all columns for sales made on '2022-05-10'?**:

```sql
SELECT *
FROM retail_sales_analysis
WHERE sale_date = '2022-05-10';
```

4. **Write a SQL query to calculate the total sales (total_sale) for each category?**:

```sql
SELECT
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales_analysis
GROUP BY 1;
```

5. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?**:

```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales_analysis
WHERE category = 'Beauty';

```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category?**:

```sql
SELECT
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales_analysis
GROUP BY category,gender
ORDER BY 1;
```

7. **Write a SQL query to find the number of unique customers who purchased items from each category?**:

```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales_analysis
GROUP BY category;
```

8. **Write a SQL query to retrieve all transactions where the category is 'Beauty' and the quantity sold is more than 3 in the month of Oct-2022?**:

```sql
SELECT *
FROM retail_sales_analysis
WHERE
    category = 'Beauty'
    AND
    DATE_FORMAT(sale_date, '%Y-%m') = '2022-10'
    AND
    quantity >= 3;
```

9. **Write a SQL query to find what is the average total sale amount for transactions where the quantity sold is above 03 units?**:

```sql
SELECT AVG(total_sale) AS avg_sale_above_03_units
FROM retail_sales_analysis
WHERE quantiy > 3;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)?**:

```sql
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales_analysis
)
SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

```

11. **Write a SQL query to find the average price per unit for products sold in each category?**:

```sql
SELECT category, AVG(price_per_unit) AS avg_price_per_unit
FROM retail_sales_analysis
GROUP BY category;
```

12. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year?**:

```sql
SELECT year, month, avg_sale
FROM
(
    SELECT
        YEAR(sale_date) as year,
        MONTH(sale_date) as month,
        AVG(total_sale) as avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as ranked
    FROM retail_sales_analysis
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE ranked = 1;

```

13. **Write a SQL query to find which month had the highest number of products sold in 2023?**:

```sql
SELECT MONTH(sale_date) AS sale_month, SUM(quantiy) AS total_quantity_sold
FROM retail_sales_analysis
WHERE YEAR(sale_date) = 2023
GROUP BY sale_month
ORDER BY total_quantity_sold DESC
LIMIT 1;
```

14. **Write a SQL query to find which month had the highest number of transactions in 2023?**:

```sql
SELECT MONTH(sale_date) AS sale_month, COUNT(*) AS total_transactions
FROM retail_sales_analysis
WHERE YEAR(sale_date) = 2023
GROUP BY sale_month
ORDER BY total_transactions DESC
LIMIT 1;
```

15. **Write a SQL query to find what is the average total sale amount for each age group (e.g., 18-25, 26-35, etc.)?**:

```sql
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        WHEN age BETWEEN 56 AND 65 THEN '56-65'
        ELSE '65+'
    END AS age_group,
    AVG(total_sale) AS average_total_sale
FROM retail_sales_analysis
GROUP BY age_group
ORDER BY age_group;
```

16. **Write a SQL query to find which customer made the largest purchase in terms of a single transaction in 2023?**:

```sql
SELECT customer_id, MAX(total_sale) AS largest_purchase
FROM retail_sales_analysis
WHERE YEAR(sale_date) = 2023
GROUP BY customer_id
ORDER BY largest_purchase DESC
LIMIT 1;
```

17. **Write a SQL query to find the percentage of total sales made in the 'Electronics' category compared to the overall sales in 2023?**:

```sql
SELECT
    (SUM(CASE WHEN category = 'Electronics' THEN total_sale ELSE 0 END) / SUM(total_sale)) * 100 AS electronics_sales_percentage
FROM retail_sales_analysis
WHERE YEAR(sale_date) = 2023;
```

18. **Write a SQL query to find the top 3 products (categories) based on the highest total sales in the first quarter of 2023?**:

```sql
SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales_analysis
WHERE sale_date BETWEEN '2023-01-01' AND '2023-03-31'
GROUP BY category
ORDER BY total_sales DESC
LIMIT 3;

```

19. **Write a SQL query to find the top 10 customers based on the highest total sales?**:

```sql
SELECT customer_id,
       SUM(total_sale) as total_sales
FROM retail_sales_analysis
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

20. **Write a SQL query to find how many transactions had a total sale amount greater than 1000 and were made by customers aged over 40?**:

```sql
SELECT COUNT(*) AS high_value_transactions
FROM retail_sales_analysis
WHERE total_sale > 1000 AND age > 40;
```

## Findings

- **Customer Demographics**: The dataset contains customers from a range of age groups, with sales spanning various categories, including Clothing, Electronics and Beauty.
- **High-Value Transactions**: Multiple transactions had a total sale amount exceeding 700, suggesting premium purchases.
- **Sales Trends**: Monthly analysis reveals fluctuations in sales, aiding in the identification of peak seasons.
- **Customer Insights**: The analysis highlights the highest-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A comprehensive report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales patterns across various months and shifts.
- **Customer Insights**: Reports detailing the top customers and the count of unique customers per category.

## Conclusion

This project offers a comprehensive overview of SQL for data analysts, covering key areas such as database creation, data cleaning, exploratory data analysis, and business-oriented SQL queries. The insights gained from this analysis can assist in making informed business decisions by revealing trends in sales, customer preferences, and product performance.
