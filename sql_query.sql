-- SQL Retail Sales Analysis Database
CREATE DATABASE retail_data;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales_analysis;
CREATE TABLE retail_sales_analysis
            (
                transactions_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales_analysis
LIMIT 10


    

SELECT 
    COUNT(*) 
FROM retail_sales_analysis

-- Data Cleaning
SELECT * FROM retail_sales_analysis
WHERE transaction_id IS NULL

SELECT * FROM retail_sales_analysis
WHERE sale_date IS NULL

SELECT * FROM retail_sales_analysis
WHERE sale_time IS NULL

SELECT * FROM retail_sales_analysis
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales_analysis
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;


    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales_analysis

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales_analysis



SELECT DISTINCT category FROM retail_sales_analysis






-- Data Analysis & Business Key Problems & Answers


-- Q.1 Write a SQL query to find the total sale made by gender category?
-- Q.2 Write a SQL query to find all transactions where the total_sale is greater than 700?
-- Q.3 Write a SQL query to retrieve all columns for sales made on '2022-05-10'?
-- Q.4 Write a SQL query to calculate the total sales (total_sale) for each category?
-- Q.5 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category?
-- Q.7 Write a SQL query to find the number of unique customers who purchased items from each category?
-- Q.8 Write a SQL query to retrieve all transactions where the category is 'Beauty' and the quantity sold is more than 3 in the month of Oct-2022?
-- Q.9 Write a SQL query to find what is the average total sale amount for transactions where the quantity sold is above 10 units?
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)?
-- Q.11 Write a SQL query to find the average price per unit for products sold in each category?
-- Q.12 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year?
-- Q.13 Write a SQL query to find which month had the highest number of products sold in 2023?
-- Q.14 Write a SQL query to find which month had the highest number of transactions in 2023?
-- Q.15 Write a SQL query to find what is the average total sale amount for each age group (e.g., 18-25, 26-35, etc.)?
-- Q.16 Write a SQL query to find which customer made the largest purchase in terms of a single transaction in 2023?
-- Q.17 Write a SQL query to find the percentage of total sales made in the 'Electronics' category compared to the overall sales in 2023?
-- Q.18 Write a SQL query to find the top 3 products (categories) based on the highest total sales in the first quarter of 2023?
-- Q.19 Write a SQL query to find the top 10 customers based on the highest total sales?
-- Q.20 Write a SQL query to find how many transactions had a total sale amount greater than 1000 and were made by customers aged over 40?






-- Q.1 Write a SQL query to find the total sale made by gender category?

SELECT gender, SUM(total_sale) AS total_sales_by_gender
FROM retail_sales_analysis
GROUP BY gender;


-- Q.2 Write a SQL query to find all transactions where the total_sale is greater than 700?

SELECT * FROM retail_sales_analysis
WHERE total_sale > 700


-- Q.3 Write a SQL query to retrieve all columns for sales made on '2022-05-10'?

SELECT *
FROM retail_sales_analysis
WHERE sale_date = '2022-05-10';


-- Q.4 Write a SQL query to calculate the total sales (total_sale) for each category?

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales_analysis
GROUP BY 1



-- Q.5 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales_analysis
WHERE category = 'Beauty'


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category?

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales_analysis
GROUP BY category,gender
ORDER BY 1


-- Q.7 Write a SQL query to find the number of unique customers who purchased items from each category?


SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales_analysis
GROUP BY category


-- Q.8 Write a SQL query to retrieve all transactions where the category is 'Beauty' and the quantity sold is more than 3 in the month of Oct-2022?

SELECT *
FROM retail_sales_analysis
WHERE 
    category = 'Beauty'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-10'
    AND
    quantity >= 3
    
    
-- Q.9 Write a SQL query to find what is the average total sale amount for transactions where the quantity sold is above 3 units?

SELECT AVG(total_sale) AS avg_sale_above_03_units
FROM retail_sales_analysis
WHERE quantiy > 3;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)?

WITH hourly_sale AS (
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales_analysis
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- Q.11 Write a SQL query to find the average price per unit for products sold in each category?

SELECT category, AVG(price_per_unit) AS avg_price_per_unit
FROM retail_sales_analysis
GROUP BY category;

-- Q.12 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year?

SELECT year,month,avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales_analysis
GROUP BY 1, 2
) as t1
WHERE rank = 1

-- Q.13 Write a SQL query to find which month had the highest number of products sold in 2023?

SELECT MONTH(sale_date) AS sale_month, SUM(quantiy) AS total_quantity_sold
FROM retail_sales_analysis
WHERE YEAR(sale_date) = 2024
GROUP BY sale_month
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- Q.14 Write a SQL query to find which month had the highest number of transactions in 2023?

SELECT MONTH(sale_date) AS sale_month, COUNT(*) AS total_transactions
FROM retail_sales_analysis
WHERE YEAR(sale_date) = 2024
GROUP BY sale_month
ORDER BY total_transactions DESC
LIMIT 1;

-- Q.15 Write a SQL query to find what is the average total sale amount for each age group (e.g., 18-25, 26-35, etc.)?

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


-- Q.16 Write a SQL query to find which customer made the largest purchase in terms of a single transaction in 2023?

SELECT customer_id, MAX(total_sale) AS largest_purchase
FROM retail_sales_analysis
WHERE YEAR(sale_date) = 2024
GROUP BY customer_id
ORDER BY largest_purchase DESC
LIMIT 1;

-- Q.17 Write a SQL query to find the percentage of total sales made in the 'Electronics' category compared to the overall sales in 2023?

SELECT 
    (SUM(CASE WHEN category = 'Electronics' THEN total_sale ELSE 0 END) / SUM(total_sale)) * 100 AS electronics_sales_percentage
FROM retail_sales_analysis
WHERE YEAR(sale_date) = 2024;

-- Q.18 Write a SQL query to find the top 3 products (categories) based on the highest total sales in the first quarter of 2023?

SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales_analysis
WHERE sale_date BETWEEN '2024-01-01' AND '2024-03-31'
GROUP BY category
ORDER BY total_sales DESC
LIMIT 3;

-- Q.19 Write a SQL query to find the top 10 customers based on the highest total sales?

SELECT customer_id,
       SUM(total_sale) as total_sales
FROM retail_sales_analysis
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10



-- Q.20 Write a SQL query to find how many transactions had a total sale amount greater than 1000 and were made by customers aged over 40?

SELECT COUNT(*) AS high_value_transactions
FROM retail_sales_analysis
WHERE total_sale > 1000 AND age > 40;


-- End of project

