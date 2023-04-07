CREATE TABLE candidates
(
emp_id int,
experience varchar(20),
salary int
);

INSERT INTO candidates VALUES
(1, 'Junior', 10000),
(2, 'Junior', 15000),
(3, 'Junior', 40000),
(4, 'Senior', 16000),
(5, 'Senior', 20000),
(6, 'Senior', 50000);

/* A company wants to hire new employees. The budget of the company for the salaries is $70000. */
/* The company's criteria for hiring are: keep hiring the senior with the smalled salary until you cannot hire
any more seniors.*/
/* Use the reamining budget to hire the junior with the smallest salary. */
/* Keep hiring the junior with the smallest salary until you cannot hire any more juniors */
/* Write the SQL query to find seniors and juniors hired under the mentioned criteria */

SELECT * FROM candidates;

-- Step 1 : We will find running sum
-- Tip : We use unbounded preceding when there are duplicate values
SELECT *
, SUM(salary) OVER(PARTITION BY experience ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_salary
FROM candidates

-- Step 2 : Now we will check criteria for hiring senior.

WITH total_sal
AS
(
SELECT *
, SUM(salary) OVER(PARTITION BY experience ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_salary
FROM candidates
)
SELECT *
FROM total_sal
WHERE experience = 'Senior' AND running_salary <= 70000

-- Step 3 : Now we will check criteria for junior and substract salaries of senior.

WITH total_sal
AS
(
SELECT *
, SUM(salary) OVER(PARTITION BY experience ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_salary
FROM candidates
), seniors
AS
(SELECT *
FROM total_sal
WHERE experience = 'Senior' AND running_salary <= 70000)
SELECT *
FROM total_sal
WHERE experience = 'Junior' AND running_salary <= 70000 - (SELECT SUM(salary) FROM seniors)

-- Step 4 : We will combine both

WITH total_sal
AS
(
SELECT *
, SUM(salary) OVER(PARTITION BY experience ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_salary
FROM candidates
), seniors
AS
(SELECT *
FROM total_sal
WHERE experience = 'Senior' AND running_salary <= 70000)
SELECT *
FROM total_sal
WHERE experience = 'Junior' AND running_salary <= 70000 - (SELECT SUM(salary) FROM seniors)
UNION ALL
SELECT * FROM seniors;
