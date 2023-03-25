CREATE TABLE event_status
(
event_time varchar(10),
status varchar(10)
);

INSERT INTO event_status VALUES
('10:01', 'on'),
('10:02', 'on'),
('10:03', 'on'),
('10:04', 'off'),
('10:07', 'on'),
('10:08', 'on'),
('10:09', 'off'),
('10:11', 'on'),
('10:12', 'off');

/* Count On and Off */

SELECT * FROM event_status;

-- Step 1 : We will check previous status
SELECT *,
LAG(status, 1, status) OVER(ORDER BY event_time) AS prev_status
FROM event_status

-- Step 2 :We will create new group key when status is on after off.
SELECT *,
SUM(CASE WHEN status = 'on' AND prev_status = 'off' THEN 1 ELSE 0 END) OVER(ORDER BY event_time) AS group_key
FROM
(
SELECT *,
LAG(status, 1, status) OVER(ORDER BY event_time) AS prev_status
FROM event_status) A

-- Step 3 : We will calculate on count.
WITH cte1
AS
(
SELECT *,
SUM(CASE WHEN status = 'on' AND prev_status = 'off' THEN 1 ELSE 0 END) OVER(ORDER BY event_time) AS group_key
FROM
(
SELECT *,
LAG(status, 1, status) OVER(ORDER BY event_time) AS prev_status
FROM event_status) A)
SELECT MIN(event_time) AS login, MAX(event_time) AS logout, COUNT(1) - 1 AS on_count
FROM cte1
GROUP BY group_key

