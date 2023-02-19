CREATE TABLE trips
(
id int,
client_id int,
driver_id int,
city_id int,
status varchar(50),
request_at varchar(50)
);

CREATE TABLE Users1
(
users_id int,
banned varchar(50),
role varchar(50)
);

INSERT INTO trips VALUES
(1, 1, 10, 1, 'completed', '2013-10-01'),
(2, 2, 11, 1, 'cancelled_by_driver', '2013-10-01'),
(3, 3, 12, 6, 'completed', '2013-10-01'),
(4, 4, 13, 6, 'cancelled_by_client', '2013-10-01'),
(5, 1, 10, 1, 'completed', '2013-10-02'),
(6, 2, 11, 6, 'completed', '2013-10-02'),
(7, 3, 12, 6, 'completed', '2013-10-02'),
(8, 2, 12, 12, 'completed', '2013-10-03'),
(9, 3, 10, 12, 'completed', '2013-10-03'),
(10, 4, 13, 12, 'cancelled_by_driver', '2013-10-03');

INSERT INTO Users1 VALUES
(1, 'No', 'client'),
(2, 'Yes', 'client'),
(3, 'No', 'client'),
(4, 'No', 'client'),
(10, 'No', 'driver'),
(11, 'No', 'driver'),
(12, 'No', 'driver'),
(13, 'No', 'driver');

SELECT * FROM trips;

SELECT * FROM Users1;

/*
Q. Write a SQL Query to find the cancellation rate of requests with unbanned users
(both client and driver must not be banned) each day between "2013-10-01 and "2013-10-03".

The cancellation rate is computed by dividing the number of canceled (by client or driver)
requests with unbanned users by total number of requests with unbanned users on that day.
*/

-- Step 1 : We will get rid of banned user or banned driver
SELECT *
FROM trips AS t
INNER JOIN Users1 AS c
ON t.client_id = c.users_id
INNER JOIN Users1 AS d
ON t.driver_id = d.users_id
WHERE c.banned = 'No' AND d.banned = 'No';

-- Step 2 : We will calculate cancellation percentage at the request_at level that is trip col.
SELECT t.request_at,
COUNT(CASE WHEN t.status IN ('cancelled_by_client', 'cancelled_by_driver') THEN 1 ELSE NULL END)
AS cancelled_trip_count,
COUNT(1) AS total_trips,
1.0*COUNT(CASE WHEN t.status IN ('cancelled_by_client', 'cancelled_by_driver') THEN 1 ELSE NULL END)
/ COUNT(1) * 100 AS cancelled_percent
FROM trips AS t
INNER JOIN Users1 AS c
ON t.client_id = c.users_id
INNER JOIN Users1 AS d
ON t.driver_id = d.users_id
WHERE c.banned = 'No' AND d.banned = 'No'
GROUP BY t.request_at;
