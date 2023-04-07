CREATE TABLE employee7
(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int
);

INSERT INTO employee7 VALUES
(1, 'Ankit', 100, 10000, 4, 39),
(2, 'Mohit', 100, 15000, 5, 48),
(3, 'Vikas', 100, 12000, 4, 37),
(4, 'Rohit', 100, 14000, 2, 16),
(5, 'Mudit', 200, 20000, 6, 55),
(6, 'Agam', 200, 12000, 2, 14),
(7, 'Sanjay', 200, 9000, 2, 13),
(8, 'Ashish', 200, 5000, 2, 12),
(9, 'Mukesh', 300, 6000, 6, 51),
(10, 'Rakesh', 500, 7000, 6, 50);


/* Write a SQL to list emp name along with their manager and senior manger name */
/* Senior manager is manger's manager */

SELECT * FROM employee7;

-- Step 1 : We will join table with itself to get manager's name. This is the case of self join.

SELECT e.emp_id, e.emp_name, m.emp_name AS manager_name
FROM employee7 AS e
LEFT JOIN employee7 AS m
ON e.manager_id = m.emp_id

-- Step 2 : We will join table with itself to get manager's manager name.

SELECT e.emp_id, e.emp_name, m.emp_name AS manager_name, sm.emp_name AS senior_manager
FROM employee7 AS e
LEFT JOIN employee7 AS m
ON e.manager_id = m.emp_id
LEFT JOIN employee7 AS sm
ON m.manager_id = sm.emp_id

-- Step 3 : Give me salary of manager and senior manager

SELECT e.emp_id, e.emp_name, m.emp_name AS manager_name, sm.emp_name AS senior_manager
, m.salary AS manager_salary, sm.salary AS senior_manager_salary
FROM employee7 AS e
LEFT JOIN employee7 AS m
ON e.manager_id = m.emp_id
LEFT JOIN employee7 AS sm
ON m.manager_id = sm.emp_id
