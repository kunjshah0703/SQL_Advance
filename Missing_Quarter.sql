CREATE TABLE Stores
(
store varchar(10),
quarter varchar(10),
amount int
);

INSERT INTO Stores Values
('S1', 'Q1', 200),
('S1', 'Q2', 300),
('S1', 'Q4', 400),
('S2', 'Q1', 500),
('S2', 'Q3', 600),
('S2', 'Q4', 700),
('S3', 'Q1', 800),
('S3', 'Q2', 750),
('S3', 'Q3', 900);

/* Find the missing quarter from the store data */

SELECT * FROM Stores;

-- Step 1: Using Aggregation
SELECT store, 'Q' + CAST(10 - SUM(CAST(RIGHT(quarter, 1) AS INT)) AS CHAR(2)) AS q_no
FROM Stores
GROUP BY store;

-- Step 2: Using recursive CTE
WITH CTE AS
(
SELECT DISTINCT store, 1 AS q_no FROM Stores
UNION ALL
SELECT store, q_no + 1 AS q_no FROM CTE
WHERE q_no < 4
),
q AS 
(SELECT store, 'Q' + CAST(q_no AS char(1)) AS q_no FROM CTE)
SELECT q.*
FROM q
LEFT JOIN Stores
ON q.store = Stores.store AND q.q_no = Stores.quarter
WHERE Stores.store IS NULL

-- Step 3 : Using Cross Join

WITH CTE AS
(
SELECT DISTINCT s1.store, s2.quarter
FROM Stores AS s1, Stores AS s2
)
SELECT q.*
FROM CTE AS q
LEFT JOIN Stores AS s
ON q.store = s.store AND q.quarter = s.quarter
WHERE s.store IS NULL