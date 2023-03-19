CREATE TABLE covid
(
city varchar(50),
days date,
cases int
);

INSERT INTO covid VALUES
('DELHI', '2022-01-01', 100),
('DELHI', '2022-01-02', 200),
('DELHI', '2022-01-03', 300),
('MUMBAI', '2022-01-01', 100),
('MUMBAI', '2022-01-02', 100),
('MUMBAI', '2022-01-03', 300),
('CHENNAI', '2022-01-01', 100),
('CHENNAI', '2022-01-01', 200),
('CHENNAI', '2022-01-01', 150),
('BANGALORE', '2022-01-01', 100),
('BANGALORE', '2022-01-02', 300),
('BANGALORE', '2022-01-03', 200),
('BANGALORE', '2022-01-04', 400);

/* Covid Cases Analysis.
Find the cities where the covid cases are increasing continuously.*/

SELECT * FROM covid;

WITH rnk AS(
SELECT *,
RANK() OVER(PARTITION BY city ORDER BY days) AS rn_days,
RANK() OVER(PARTITION BY city ORDER BY cases) AS rn_cases,
RANK() OVER(PARTITION BY city ORDER BY days) - RANK() OVER(PARTITION BY city ORDER BY cases) AS diff
FROM covid)
SELECT city
FROM rnk
GROUP BY city
HAVING COUNT(DISTINCT diff) = 1 AND MAX(diff) = 0