SELECT * FROM sachin_scores;

/* Find Sachin's milestones innings/matches */

-- Step 1 : First we will find rolling sum so we can find the milestone runs

--SELECT *
--, DATEPART(year, match_date)
--, DATEPART(month, match_date)
--, DATEPART(day, match_date)
--FROM sachin_scores
WITH cte1
AS
(
SELECT Match, Innings, Runs
, SUM(Runs) OVER(ORDER BY Match ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rolling_sum
FROM sachin_scores)

-- Step 2 : We will take milestone runs
WITH cte2
AS
(
SELECT 1 AS milestone_number, 1000 AS milestone_runs
UNION ALL
SELECT 2 AS milestone_number, 5000 AS milestone_runs
UNION ALL
SELECT 3 AS milestone_number, 10000 AS milestone_runs
)

-- Step 3 : We will check whether rolling sum is greater than milestone runs

WITH cte1
AS
(
SELECT Match, Innings, Runs
, SUM(Runs) OVER(ORDER BY Match ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rolling_sum
FROM sachin_scores)
,cte2
AS
(
SELECT 1 AS milestone_number, 1000 AS milestone_runs
UNION ALL
SELECT 2 AS milestone_number, 5000 AS milestone_runs
UNION ALL
SELECT 3 AS milestone_number, 10000 AS milestone_runs
UNION ALL
SELECT 4 AS milestone_number, 15000 AS milestone_runs
)
SELECT milestone_number, milestone_runs, MIN(Match) AS milestone_match, MIN(Innings) AS milestone_innings
FROM cte2
INNER JOIN cte1
ON rolling_sum > milestone_runs
GROUP BY milestone_number, milestone_runs
ORDER BY milestone_number