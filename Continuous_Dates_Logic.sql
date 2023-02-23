CREATE TABLE tasks
(
date_value DATE,
state varchar(10)
)

INSERT INTO tasks VALUES
('2019-01-01', 'Success'),
('2019-01-02', 'Success'),
('2019-01-03', 'Success'),
('2019-01-04', 'Fail'),
('2019-01-05','Fail'),
('2019-01-06', 'Success');


/*
Q. A person is there daily he performs some task and he gets success or fail so we need to return
start date and end date for success and fail.
*/

SELECT * FROM tasks;

-- Step 1: We will get row numbers for different states
SELECT *,
ROW_NUMBER() OVER(PARTITION BY state ORDER BY date_value) AS rn
FROM tasks
ORDER BY date_value;

-- Step 2: We will get the previous dates(Trick for continuous dates)
WITH all_dates
AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY state ORDER BY date_value) AS rn,
DATEADD(day, -1*ROW_NUMBER() OVER(PARTITION BY state ORDER BY date_value), date_value) AS group_date
FROM tasks)
SELECT MIN(date_value) AS start_date, MAX(date_value) AS end_date, state
FROM all_dates
GROUP BY group_date, state
ORDER BY start_date;