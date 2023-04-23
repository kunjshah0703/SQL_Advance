CREATE TABLE employee8
(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
--emp_age int
);

INSERT INTO employee8 VALUES
(1, 'Ankit', 100, 10000, 4),
(2, 'Mohit', 100, 15000, 5),
(3, 'Vikas', 100, 10000, 4),
(4, 'Rohit', 100, 5000, 2),
(5, 'Mudit', 200, 12000, 6),
(6, 'Agam', 200, 12000, 2),
(7, 'Sanjay', 200, 9000, 2),
(8, 'Ashish', 200, 5000, 2),
(1, 'Saurabh', 900, 12000, 2);


CREATE TABLE employee9
(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
--emp_age int
);

INSERT INTO employee9 VALUES
(1, 'Ankit', 100, 10000, 4),
(2, 'Mohit', 100, 15000, 5),
(3, 'Vikas', 100, 10000, 4),
(4, 'Rohit', 100, 5000, 2),
(5, 'Mudit', 200, 12000, 6),
(6, 'Agam', 200, 12000, 2),
(7, 'Sanjay', 200, 9000, 2),
(8, 'Ashish', 200, 5000, 2),
(1, 'Saurabh', 900, 12000, 2);

-- Q.1 --> How to find duplicates in a table.

SELECT * FROM employee8

SELECT emp_id, COUNT(1)
FROM employee8
GROUP BY emp_id
HAVING COUNT(1) > 1;

-- Q.2 --> How to delete duplicates.

SELECT * FROM employee9;

WITH cte
AS
(
SELECT *
, ROW_NUMBER() OVER(PARTITION BY emp_id ORDER BY emp_id) AS rn
FROM employee9)
DELETE 
FROM cte 
WHERE rn > 1

-- Q.3 --> Difference between UNION and UNION ALL

SELECT manager_id FROM employee8
UNION ALL    -- UNION ALL will return everything including all the duplicates.
SELECT manager_id FROM employee9

SELECT manager_id FROM employee8
UNION        -- UNION will return only unique records.
SELECT manager_id FROM employee9

-- Q.4 --> Difference between RANK, ROW_NUMBER and DENSE_RANK

SELECT *,
ROW_NUMBER() OVER(PARTITION BY emp_id ORDER BY emp_id) AS rn
FROM employee8

SELECT *,
RANK() OVER(PARTITION BY emp_id ORDER BY emp_id) AS rnk -- In RANK it will skip the number
FROM employee8

SELECT *,
DENSE_RANK() OVER(PARTITION BY emp_id ORDER BY emp_id) AS drnk -- In DENSE RANK it will not skip the number.
FROM employee8

-- Q.5 --> Employees who are not present in department table.

CREATE TABLE dept
(
dep_id int,
dep_name VARCHAR(20)
);

INSERT INTO dept VALUES
(100, 'Analytics'),
(300, 'IT');

SELECT * FROM employee8
SELECT * FROM dept

SELECT *
FROM employee8
WHERE department_id NOT IN (SELECT dep_id FROM dept);

SELECT employee8.*, dept.*
FROM employee8
LEFT JOIN dept
ON employee8.department_id = dept.dep_id
WHERE dept.dep_id IS NULL

-- Q.6 --> Second highest salary in each department.

SELECT * FROM employee8

SELECT *
FROM
(SELECT *
--, RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) AS rnk
, DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) AS rnk
FROM employee8) AS A
WHERE rnk = 2

-- Q.7 --> Find all transactions done by Shilpa.

CREATE TABLE orders
(
customer_name VARCHAR(10),
order_date DATE,
order_amount int,
customer_gender VARCHAR(10)
);

INSERT INTO orders VALUES
('Shilpa', '2020-01-01', 10000, 'Male'),
('Ram', '2020-01-02', 12000, 'Female'),
('SHILPA', '2020-01-02', 12000, 'Male'),
('Rohit', '2020-01-03', 15000, 'Female'),
('shilpa', '2020-01-03', 14000, 'Male');

SELECT * FROM orders

SELECT *
FROM orders
WHERE upper(customer_name) = 'SHILPA'

-- Q.8 --> SELF JOIN, Manager Salary > Emp Salary

SELECT e.emp_name, e1.emp_name, e1.salary, e.salary
FROM employee8 AS e
LEFT JOIN employee8 AS e1
ON e.manager_id = e1.emp_id
WHERE e1.salary > e.salary

-- Q.9 --> Joins LEFT JOIN/INNER JOIN


-- Q.10 --> Update Query to swap gender

SELECT * FROM orders

UPDATE orders SET customer_gender = CASE WHEN customer_gender = 'Male' THEN 'Female'
						WHEN customer_gender = 'Female' THEN 'Male'
						END
