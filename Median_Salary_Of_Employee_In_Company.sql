CREATE TABLE employee5
(
emp_id int,
company varchar(10),
salary int
);

INSERT INTO employee5 VALUES
(1, 'A', 2341),
(2, 'A', 341),
(3, 'A', 15),
(4, 'A', 15314),
(5, 'A', 451),
(6, 'A', 513),
(7, 'B', 15),
(8, 'B', 13),
(9, 'B', 1154),
(10, 'B', 1345),
(11, 'B', 1221),
(12, 'B', 234),
(13, 'C', 2345),
(14, 'C', 2645),
(15, 'C', 2645),
(16, 'C', 2652),
(17, 'C', 65);

/* Write a SQL Query to find the median salary of each company */
/* Bonus points if you can solve it without using any built-in SQL functions. */

SELECT * FROM employee5
ORDER BY company, salary;

-- Step 1 : We will generate row number

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary) AS rm,
COUNT(1) OVER(PARTITION BY company) AS total_employees
FROM employee5

-- Step 2 : We will calculate Median using 2 new rows

SELECT *, total_employees*1.0/2, total_employees*1.0/2 + 1
FROM
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary) AS rm,
COUNT(1) OVER(PARTITION BY company) AS total_employees
FROM employee5)A

-- Step 3 : Final Solution
SELECT company, AVG(salary) AS median_salary
FROM
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary) AS rn,
COUNT(1) OVER(PARTITION BY company) AS total_employees
FROM employee5)A
WHERE rn BETWEEN total_employees * 1.0 / 2 AND total_employees * 1.0 /2 + 1
GROUP BY company
