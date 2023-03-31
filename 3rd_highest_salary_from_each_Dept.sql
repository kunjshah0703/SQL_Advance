CREATE TABLE employee6
(
emp_id int,
emp_name VARCHAR(50),
salary int,
manager_id int,
emp_age int,
dep_id int,
dep_name VARCHAR(20),
gender VARCHAR(10)
);

INSERT INTO employee6 VALUES
(1, 'Kunj', 14300, 4, 39, 100, 'Analytics', 'Female'),
(2, 'Mohit', 14000, 5, 48, 200, 'IT', 'Male'),
(3, 'Vikas', 12100, 4, 37, 100, 'Analytics', 'Female'),
(4, 'Rohit', 7260, 2, 16, 100, 'Analytics', 'Female'),
(5, 'Mudit', 15000, 6, 55, 200, 'IT', 'Male'),
(6, 'Agam', 15600, 2, 14, 200, 'IT', 'Male'),
(7, 'Sanjay', 12000, 2, 13, 200, 'IT', 'Male'),
(8, 'Ashish', 7200, 2, 12, 200, 'IT', 'Male'),
(9, 'Mukesh', 7000, 6, 51, 300, 'HR', 'Male'),
(10, 'Rakesh', 8000, 6, 50, 300, 'HR', 'Male'),
(11, 'Akhil', 4000, 1, 31, 500, 'Ops', 'Male');

/* Write an SQL to find the details of employees with 3rd highest salary in each department. In case 
there are less than 3 employees in a department then return employee details with lowest salary salary
in that dep.*/

SELECT * FROM employee6;

-- Step 1 : We will find rank by each department and check 3rd highest

WITH third_high_salary
AS
(
SELECT emp_id, emp_name, salary, dep_id, dep_name
, RANK() OVER(PARTITION BY dep_id ORDER BY salary DESC) AS rn
FROM employee6)
SELECT * FROM third_high_salary WHERE rn = 3;

-- Step 2 : We will take count of employees from each dep to tackle 2nd condition.

WITH third_high_salary
AS
(
SELECT emp_id, emp_name, salary, dep_id, dep_name
, RANK() OVER(PARTITION BY dep_id ORDER BY salary DESC) AS rn
, COUNT(1) OVER(PARTITION BY dep_id) AS cnt_emp
FROM employee6)
SELECT * 
FROM third_high_salary
WHERE rn = 3 OR (cnt_emp < 3 AND rn = cnt_emp);
