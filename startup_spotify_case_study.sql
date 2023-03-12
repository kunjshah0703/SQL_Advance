CREATE TABLE activity
(
user_id VARCHAR(20),
event_name VARCHAR(20),
event_date DATE,
country VARCHAR(20)
);

INSERT INTO activity VALUES
(1, 'app-installed', '2022-01-01', 'India'),
(1, 'app-purchase', '2022-01-02', 'India'),
(2, 'app-installed', '2022-01-01', 'USA'),
(3, 'app-installed', '2022-01-01', 'USA'),
(3, 'app-purchase', '2022-01-03', 'USA'),
(4, 'app-installed', '2022-01-03', 'India'),
(4, 'app-purchase', '2022-01-03', 'India'),
(5, 'app-installed', '2022-01-03', 'SL'),
(5, 'app-purchase', '2022-01-03', 'SL'),
(6, 'app-installed', '2022-01-04', 'Pakistan'),
(6, 'app-purchase', '2022-01-04', 'Pakistan');

/*
The activity table shows the app-installed and app-purchase activities for spotify app along with country details.
*/

SELECT * FROM activity;

/*
Question 1 : Find total active users each day
event_date  total_active_users
2022-01-01   3
2022-01-02   1
2022-01-03   3
2022-01-04   1
*/

SELECT event_date, COUNT(DISTINCT user_id) AS total_active_users
FROM activity
GROUP BY event_date
ORDER BY event_date;

/*
Question 2 : Find total active users each week.
week_number    total_active_users
1				3
2				5
*/

SELECT DATEPART(week, event_date) AS week_number, COUNT(DISTINCT user_id) AS total_active_users
FROM activity
GROUP BY DATEPART(week, event_date)

/*
Question 3 : Date Wise total number of users who made the purchase same day they installed the app
event_date    no_of_users_same_day_purchase
2022-01-01		0
2022-01-02		0
2022-01-03		2
2022-01-04		1
*/

SELECT event_date, COUNT(new_user) AS no_of_users
FROM
(
SELECT user_id, event_date,
CASE WHEN COUNT(DISTINCT event_name) = 2 THEN user_id ELSE NULL END AS new_user
FROM activity
-- WHERE event_name IN ('app-installed','app-purchase') AND event_date = event_date
GROUP BY user_id, event_date
-- HAVING COUNT(DISTINCT event_name) = 2
) a
GROUP BY event_date;


/*
Question 4 : Percentage of paid users in India, USA and any other country should be tagged as others
country		percentage_users
India		40
USA			20
Others		40
*/


WITH country_users AS
(
SELECT CASE WHEN country IN ('USA', 'India') THEN country ELSE 'Others' END AS new_country,
COUNT(DISTINCT user_id) AS user_count
FROM activity
WHERE event_name = 'app-purchase'
GROUP BY CASE WHEN country IN ('USA', 'India') THEN country ELSE 'Others' END
),
total 
AS
(
SELECT SUM(user_count) AS total_users FROM country_users
)
SELECT
new_country, ROUND(user_count * 1.0/total_users,2) * 100 AS perc_users
FROM country_users,total

/*
Question 5 : Among all the users who installed the app on a given day, how many did in app purchased on the very
next day
event_date		cnt_users
2022-01-01		0
2022-01-02		1
2022-01-03		0
2022-01-04		0
*/


WITH prev_date
AS
(
SELECT *,
LAG(event_name, 1) OVER(PARTITION BY user_id ORDER BY event_date) AS previous_event_name,
LAG(event_date, 1) OVER(PARTITION BY user_id ORDER BY event_date) AS previous_event_date
FROM activity
)
SELECT event_date, COUNT(DISTINCT user_id) AS cnt_users
--,CASE WHEN event_name = 'app-purchase' AND previous_event_name = 'app-installed' AND DATEDIFF(day, previous_event_date, event_date) = 1 THEN user_id ELSE NULL END
FROM prev_date
WHERE event_name = 'app-purchase' AND previous_event_name = 'app-installed' AND DATEDIFF(day, previous_event_date, event_date) = 1
GROUP BY event_date--, event_name = 'app-purchase' AND previous_event_name = 'app-installed' AND DATEDIFF(day, previous_event_date, event_date) = 1
