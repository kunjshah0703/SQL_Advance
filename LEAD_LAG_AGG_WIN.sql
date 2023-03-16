CREATE TABLE bms
(
seat_no int,
is_empty varchar(10)
);

INSERT INTO bms VALUES
(1, 'N'),
(2, 'Y'),
(3, 'N'),
(4, 'Y'),
(5, 'Y'),
(6, 'Y'),
(7, 'N'),
(8, 'Y'),
(9, 'Y'),
(10, 'Y'),
(11, 'Y'),
(12, 'N'),
(13, 'Y'),
(14, 'Y');

/*
3 or more consecutive empty seats
Method 1 -- Lead, lag
Method 2 -- Advance Aggregation
Method 3 -- Analytical Row Number function 
*/


SELECT * FROM bms;

-- Approach 1 : using Lead, lag

SELECT * FROM (
SELECT *,
LAG(is_empty, 1) OVER (ORDER by seat_no) AS prev_1,
LAG(is_empty, 2) OVER (ORDER BY seat_no) AS prev_2,
LEAD(is_empty, 1) OVER (ORDER by seat_no) AS next_1,
LEAD(is_empty, 2) OVER (ORDER BY seat_no) AS next_2
FROM bms) A
WHERE is_empty = 'Y' AND prev_1 = 'Y' AND prev_2 = 'Y'
OR (is_empty = 'Y' AND prev_1 = 'Y' AND next_1 = 'Y')
OR (is_empty = 'Y' AND next_1 = 'Y' AND next_2 = 'Y');


-- Approach 2 : Using advance aggregation
SELECT * FROM bms;

SELECT * FROM (
SELECT *,
SUM (CASE WHEN is_empty = 'Y' THEN 1 ELSE 0 END) OVER (ORDER by seat_no ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS prev_2,
SUM (CASE WHEN is_empty = 'Y' THEN 1 ELSE 0 END) OVER (ORDER by seat_no ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS prev_next_1,
SUM (CASE WHEN is_empty = 'Y' THEN 1 ELSE 0 END) OVER (ORDER by seat_no ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS next_2
FROM bms)  A
WHERE prev_2 = 3 OR prev_next_1 = 3 OR next_2 = 3

-- Aproach 3 : Analytical Function

WITH diff_num
AS
(
SELECT *,
ROW_NUMBER() OVER(ORDER BY seat_no) AS rn,
seat_no - ROW_NUMBER() OVER(ORDER BY seat_no) AS diff
FROM bms
WHERE is_empty = 'Y')
,cnt AS (
SELECT diff, COUNT(1) AS c
FROM diff_num
GROUP BY diff
HAVING COUNT(1) >=3)
SELECT * FROM diff_num WHERE diff IN (SELECT diff FROM cnt)