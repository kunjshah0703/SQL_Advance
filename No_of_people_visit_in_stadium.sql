CREATE TABLE stadium
(
id int,
visit_date date,
no_of_people int
);

INSERT INTO stadium VALUES
(1, '2017-07-01', 10),
(2, '2017-07-02', 109),
(3, '2017-07-03', 150),
(4, '2017-07-04', 99),
(5, '2017-07-05', 145),
(6, '2017-07-06', 1455),
(7, '2017-07-07', 199),
(8, '2017-07-08', 188);

/* Write a query to display the records which have 3 or more consecutive rows. */

/* With the amount of people more than 100(inclusive) each day */

SELECT * FROM stadium;

-- Step 1 : We will apply filter where no_of_people are more than 100 and generate row_number

SELECT *
, ROW_NUMBER() OVER(ORDER BY visit_date) AS rn
FROM stadium
WHERE no_of_people >= 100

-- Step 2 : We will do id - rn. Because if it is consecutive number than difference will be always same

SELECT *
, ROW_NUMBER() OVER(ORDER BY visit_date) AS rn
, id - ROW_NUMBER() OVER(ORDER BY visit_date) AS grp
FROM stadium
WHERE no_of_people >= 100

-- Step 3 : We will group all counts together.

WITH grp_number
AS
(
SELECT *
, ROW_NUMBER() OVER(ORDER BY visit_date) AS rn
, id - ROW_NUMBER() OVER(ORDER BY visit_date) AS grp
FROM stadium
WHERE no_of_people >= 100
)
SELECT grp, COUNT(1)
FROM grp_number
GROUP BY grp
-- HAVING COUNT(1) >= 3

-- Step 4 : Final Solution. We will apply greater than or equal to 3 condition.
WITH grp_number
AS
(
SELECT *
, ROW_NUMBER() OVER(ORDER BY visit_date) AS rn
, id - ROW_NUMBER() OVER(ORDER BY visit_date) AS grp
FROM stadium
WHERE no_of_people >= 100
)
SELECT id, visit_date, no_of_people
FROM grp_number
WHERE grp IN
(SELECT grp
FROM grp_number
GROUP BY grp
HAVING COUNT(1) >= 3)