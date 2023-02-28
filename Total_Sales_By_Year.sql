CREATE TABLE sales
(
product_id INT,
period_start DATE,
period_end DATE,
average_daily_sales INT
);

INSERT INTO sales VALUES
(1, '2019-01-25', '2019-02-28', 100),
(2, '2018-12-01', '2020-01-01', 10),
(3, '2019-12-01', '2020-01-31', 1);

SELECT * FROM sales;

-- Recursive CTE

-- Q. Total Sales by year

-- Step 1 : We will generate date for each row.

WITH r_cte
AS
(
SELECT MIN(period_start) AS dates, MAX(period_end) AS max_date
FROM sales
UNION ALL
SELECT DATEADD(day, 1, dates), max_date
FROM r_cte
WHERE dates < max_date
)
SELECT product_id, YEAR(dates) AS report_year, SUM(average_daily_sales) AS total_amount FROM r_cte
INNER JOIN sales ON dates BETWEEN period_start AND period_end
GROUP BY product_id, YEAR(dates)
ORDER BY product_id, YEAR(dates)
option (maxrecursion 1000);