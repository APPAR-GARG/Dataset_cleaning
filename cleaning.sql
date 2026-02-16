-- creating table for the dataset:
-- and importing the dataset into the table:
CREATE TABLE financial_sample (
    segment VARCHAR(50),
    country VARCHAR(50),
    product VARCHAR(50),
    discount_band VARCHAR(50),
    units_sold FLOAT,
    manufacturing_price FLOAT,
    sale_price FLOAT,
    gross_sales FLOAT,
    discounts FLOAT,
    sales FLOAT,
    cogs FLOAT,
    profit FLOAT,
    date DATE,
    month_number INT,
    month_name VARCHAR(20),
    year INT
);

--Identifying missing values:
--finding missing values in the columns:
SELECT *
FROM financial_sample
WHERE discount_band IS NULL
   OR units_sold IS NULL
   OR profit IS NULL;


--count missing values column-wise:
SELECT
COUNT(*) FILTER (WHERE discount_band IS NULL) AS missing_discount_band,
COUNT(*) FILTER (WHERE units_sold IS NULL) AS missing_units_sold,
COUNT(*) FILTER (WHERE profit IS NULL) AS missing_profit
FROM financial_sample;


--replacing missing values with mean:
UPDATE financial_sample
SET units_sold =
(
    SELECT AVG(units_sold)
    FROM financial_sample
)
WHERE units_sold IS NULL;

-- updating missing values with the average of upper and lower row's values:
UPDATE financial_sample f
SET units_sold = sub.avg_value
FROM (
    SELECT
    date,
    (LAG(units_sold) OVER (ORDER BY date)
     + LEAD(units_sold) OVER (ORDER BY date)) / 2 AS avg_value
    FROM financial_sample
) sub
WHERE f.date = sub.date
AND f.units_sold IS NULL;








