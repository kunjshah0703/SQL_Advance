CREATE TABLE users3
(
user_id int,
name varchar(20),
join_date date
);

CREATE TABLE events
(
user_id int,
type varchar(10),
access_date date
);

INSERT INTO users3 VALUES
(1, 'Jon', CAST('2-14-20' AS date)),
(2, 'Jane', CAST('2-14-20' AS date)),
(3, 'Jill', CAST('2-15-20' AS date)),
(4, 'Joshi', CAST('2-15-20' AS date)),
(5, 'Jean', CAST('2-16-20' AS date)),
(6, 'Justin', CAST('2-17-20' AS date)),
(7, 'Jeremy', CAST('2-18-20' AS date));

INSERT INTO events VALUES
(1, 'Pay', CAST('3-1-20' AS date)),
(2, 'Music', CAST('3-2-20' AS date)),
(2, 'P', CAST('3-12-20' AS date)),
(3, 'Music', CAST('3-15-20' AS date)),
(4, 'Music', CAST('3-15-20' AS date)),
(1, 'P', CAST('3-16-20' AS date)),
(3, 'P', CAST('3-22-20' AS date));

/*
Prime subscription rate by product action.
Given the gollowing two tables, return the fraction of users, rounded to two decimal places, who accessed
Amaxon music and upgraded to prime membership within the first 30 days of signing up
*/

SELECT * FROM users3;
SELECT * FROM events;

-- Step 1 : First we will find users who have access Music
SELECT *
FROM users3
WHERE user_id IN (SELECT user_id FROM events WHERE type = 'Music');

-- Step 2 : We will check users who accessed usic and when they purchased prime membership.
SELECT u.*, e.type, e.access_date
FROM users3 AS u
LEFT JOIN events AS e
ON u.user_id = e.user_id AND e.type = 'P'
WHERE u.user_id IN (SELECT user_id FROM events WHERE type = 'Music');

-- Step 3 : Now we will check users who converted to prime members
SELECT u.*, e.type, e.access_date, DATEDIFF(day, u.join_date, e.access_date) AS no_of_days
FROM users3 AS u
LEFT JOIN events AS e
ON u.user_id = e.user_id AND e.type = 'P'
WHERE u.user_id IN (SELECT user_id FROM events WHERE type = 'Music');

-- Step 4 : we will check now who bought in 30 days.
SELECT --u.*, e.type, e.access_date, DATEDIFF(day, u.join_date, e.access_date) AS no_of_days
COUNT(DISTINCT u.user_id) AS total_users,
COUNT(DISTINCT CASE WHEN DATEDIFF(day, u.join_date, e.access_date) <= 30 THEN u.user_id END)
FROM users3 AS u
LEFT JOIN events AS e
ON u.user_id = e.user_id AND e.type = 'P'
WHERE u.user_id IN (SELECT user_id FROM events WHERE type = 'Music');

-- Step 5 : Ratio
SELECT --u.*, e.type, e.access_date, DATEDIFF(day, u.join_date, e.access_date) AS no_of_days
COUNT(DISTINCT u.user_id) AS total_users,
COUNT(DISTINCT CASE WHEN DATEDIFF(day, u.join_date, e.access_date) <= 30 THEN u.user_id END) AS converted_prime_members_within_30days,
1.0*COUNT(DISTINCT CASE WHEN DATEDIFF(day, u.join_date, e.access_date) <= 30 THEN u.user_id END)/COUNT(DISTINCT u.user_id)*100 AS percent_of_converted_users
FROM users3 AS u
LEFT JOIN events AS e
ON u.user_id = e.user_id AND e.type = 'P'
WHERE u.user_id IN (SELECT user_id FROM events WHERE type = 'Music');