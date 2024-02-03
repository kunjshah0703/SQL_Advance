CREATE TABLE clocked_hours
(
emp_id int,
swipe time,
flag char
)

INSERT INTO clocked_hours VALUES
(11114, '08:30', 'I'),
(11114, '10:30', 'I'),
(11114, '11:30', 'I'),
(11114, '15:30', 'O'),
(11115, '09:30', 'I'),
(11115, '17:30', 'O');

SELECT * FROM clocked_hours;

UPDATE clocked_hours
SET flag = 'O'
WHERE swipe = '10:30';

-- Q. Calculate working time of each employee

-- Soultion 1 :
WITH CTE
AS
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY emp_id, flag ORDER BY swipe) AS rn
FROM clocked_hours)
, cte2
AS
(SELECT emp_id, rn, MIN(swipe) AS swipe_in, MAX(swipe) AS swipe_out
, DATEDIFF(hour, MIN(swipe), MAX(swipe)) AS clocked_in_hours
FROM CTE
GROUP BY emp_id, rn)
SELECT emp_id, SUM(clocked_in_hours) AS clocked_in_hours
FROM cte2
GROUP BY emp_id;

-- Solution 2 :

WITH cte3
AS
(SELECT *, 
LEAD(swipe, 1) OVER(PARTITION BY emp_id ORDER BY swipe) AS swipe_out_time
FROM clocked_hours
--ORDER BY emp_id, swipe
),
cte4
AS
(SELECT *
,DATEDIFF(hour, swipe, swipe_out_time) AS clocked_in_time
FROM cte3
WHERE flag = 'I')
SELECT emp_id, SUM(clocked_in_time) AS total_working_hours
FROM cte4
GROUP BY emp_id;