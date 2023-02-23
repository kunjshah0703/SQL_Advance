CREATE TABLE spending
(
user_id int,
spend_date DATE,
platform varchar(10),
amount int
)

INSERT INTO spending VALUES
(1, '2019-07-01', 'mobile', 100),
(1, '2019-07-01', 'desktop', 100),
(2, '2019-07-01', 'mobile', 100),
(2, '2019-07-02', 'mobile', 100),
(3, '2019-07-01', 'desktop', 100),
(3, '2019-07-02', 'desktop', 100);

/*
Q. Write an SQL Query to find the total number of users and the total amount spent using mobile only;
desktop only; and both mobile and desktop together for each date.
*/

SELECT * FROM spending;

WITH all_spend
AS
(
SELECT spend_date, user_id, MAX(platform) AS platform, SUM(amount) AS amount
FROM spending
GROUP BY spend_date, user_id
HAVING COUNT(DISTINCT platform) = 1
UNION ALL
SELECT spend_date, user_id, 'both' AS platform, SUM(amount) AS amount
FROM spending
GROUP BY spend_date, user_id
HAVING COUNT(DISTINCT platform) = 2
UNION ALL
SELECT DISTINCT spend_date, NULL AS user_id, 'both' AS platform, 0 AS amount
FROM spending
)
SELECT spend_date, platform, SUM(amount) AS total_amount, COUNT(DISTINCT user_id) AS total_users
FROM all_spend
GROUP BY spend_date, platform
ORDER BY spend_date, platform DESC;