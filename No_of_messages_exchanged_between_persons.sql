CREATE TABLE subscriber
(
sms_date DATE,
sender varchar(20),
receiver varchar(20),
sms_no int
);

INSERT INTO subscriber VALUES
('2020-4-1', 'Avinash', 'Vibhor', 10),
('2020-4-1', 'Vibhor', 'Avinash', 20),
('2020-4-1', 'Avinash', 'Pawan', 30),
('2020-4-1', 'Pawan', 'Avinash', 20),
('2020-4-1', 'Vibhor', 'Pawan', 5),
('2020-4-1', 'Pawan', 'Vibhor', 8),
('2020-4-1', 'Vibhor', 'Deepak', 50);

/* Find total no of messages exchanged between each person per day */

SELECT * FROM subscriber;

-- Step 1 : First we will check whether sender string is greater than receiver string.

SELECT *
,CASE WHEN sender < receiver THEN sender ELSE receiver END AS p1
,CASE WHEN sender > receiver THEN sender ELSE receiver END AS p2
FROM subscriber

-- Step 2 : Group By

SELECT sms_date, p1, p2, SUM(sms_no) AS total_sms
FROM
(
SELECT sms_date
,CASE WHEN sender < receiver THEN sender ELSE receiver END AS p1
,CASE WHEN sender > receiver THEN sender ELSE receiver END AS p2
, sms_no
FROM subscriber) AS A
GROUP BY sms_date, p1, p2;