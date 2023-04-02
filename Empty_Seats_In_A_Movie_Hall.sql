CREATE TABLE movie
(
seat varchar(50),
occupancy int
);

INSERT INTO movie VALUES
('a1', 1),
('a2', 1),
('a3', 0),
('a4', 0),
('a5', 0),
('a6', 0),
('a7', 1),
('a8', 1),
('a9', 0),
('a10', 0),
('b1', 0),
('b2', 0),
('b3', 0),
('b4', 1),
('b5', 1),
('b6', 1),
('b7', 1),
('b8', 0),
('b9', 0),
('b10', 0),
('c1', 0),
('c2', 1),
('c3', 0),
('c4', 1),
('c5', 1),
('c6', 0),
('c7', 1),
('c8', 0),
('c9', 0),
('c10', 1);

/* There are 3 rows in a movie hall each with 10 seats in each row. */
/* Write a SQL to find 4 consecutive empty seats. */
SELECT * FROM movie;

-- Step 1 : We will first take row_id and seat_id

SELECT *
, LEFT(seat, 1) AS row_id
, CAST(SUBSTRING(seat, 2, 2) AS int) AS seat_id
FROM movie

-- Step 2 : We will do some aggregation. We will check if the current row and next 3 rows are empty or not.

WITH cte1
AS
(
SELECT *
, LEFT(seat, 1) AS row_id
, CAST(SUBSTRING(seat, 2, 2) AS int) AS seat_id
FROM movie
)
SELECT *
, MAX(occupancy) OVER(PARTITION BY row_id ORDER BY seat_id ROWs BETWEEN CURRENT ROW AND 3 FOLLOWING) AS is_4_empty
FROM cte1

-- Step 3 : We need to check count also

WITH cte1
AS
(
SELECT *
, LEFT(seat, 1) AS row_id
, CAST(SUBSTRING(seat, 2, 2) AS int) AS seat_id
FROM movie
), cte2
AS
(
SELECT *
, MAX(occupancy) OVER(PARTITION BY row_id ORDER BY seat_id ROWs BETWEEN CURRENT ROW AND 3 FOLLOWING) AS is_4_empty
, COUNT(occupancy) OVER(PARTITION BY row_id ORDER BY seat_id ROWs BETWEEN CURRENT ROW AND 3 FOLLOWING) AS cnt
FROM cte1)
, cte3
AS
(
SELECT *
FROM cte2
WHERE is_4_empty = 0 AND cnt = 4)
SELECT cte2.*
FROM cte2
INNER JOIN cte3
ON cte2.row_id = cte3.row_id AND cte2.seat_id BETWEEN cte3.seat_id AND cte3.seat_id+3