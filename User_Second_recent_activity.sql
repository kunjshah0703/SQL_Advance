CREATE TABLE UserActivity
(
username varchar(20),
activity varchar(20),
startDate date,
endDate date
);

INSERT INTO UserActivity VALUES
('Alice', 'Travel', '2020-02-12', '2020-02-20'),
('Alice', 'Dancing', '2020-02-21', '2020-02-23'),
('Alice', 'Travel', '2020-02-24', '2020-02-28'),
('Bob', 'Travel', '2020-02-11', '2020-02-18');

/*
Get the second most recent activity and if there is only one activity print that
*/

WITH cte
AS
(
SELECT *,
COUNT(1) OVER(PARTITION BY username) AS total_activities,
RANK() OVER(PARTITION BY username ORDER BY startdate DESC) AS rnk
FROM UserActivity
)
SELECT *
FROM cte
WHERE total_activities = 1 OR rnk = 2

