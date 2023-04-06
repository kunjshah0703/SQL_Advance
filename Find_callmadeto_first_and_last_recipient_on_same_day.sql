CREATE TABLE phonelog
(
Callerid int,
Recipientid int,
Datecalled datetime
);

INSERT INTO phonelog VALUES
(1, 2, '2019-01-01 09:00:00.000'),
(1, 3, '2019-01-01 17:00:00.000'),
(2, 4, '2019-01-01 23:00:00.000'),
(2, 5, '2019-07-05 09:00:00.000'),
(2, 3, '2019-07-01 17:00:00.000'),
(2, 3, '2019-07-07 17:20:00.000'),
(2, 5, '2019-07-05 23:00:00.000'),
(2, 3, '2019-08-01 09:00:00.000'),
(2, 3, '2019-08-01 17:00:00.000'),
(2, 5, '2019-08-01 19:30:00.000'),
(2, 4, '2019-08-02 09:00:00.000'),
(2, 5, '2019-08-02 10:00:00.000'),
(2, 5, '2019-08-02 10:45:00.000'),
(2, 4, '2019-08-02 11:00:00.000');

/* There is a phonelog table that has information about caller's call history. */
/* Write a SQL to find out callers whose first and last call was to the same person on a given day. */

SELECT * FROM phonelog;

-- Step 1 : We will find call timings for all day

SELECT Callerid, CAST(Datecalled AS date) AS called_date
, MIN(Datecalled) AS first_Call, MAX(Datecalled) AS last_Call
FROM phonelog
GROUP BY Callerid, CAST(Datecalled AS date)

-- Step 2: We will create CTE and join with original table

WITH calls
AS
(
SELECT Callerid, CAST(Datecalled AS date) AS called_date
, MIN(Datecalled) AS first_Call, MAX(Datecalled) AS last_Call
FROM phonelog
GROUP BY Callerid, CAST(Datecalled AS date)
)
SELECT c.*, p1.Recipientid AS first_recipient, p2.Recipientid AS last_recipient
FROM calls AS c
INNER JOIN phonelog AS p1
ON c.Callerid = p1.Callerid AND c.first_call = p1.Datecalled
INNER JOIN phonelog AS p2
ON c.Callerid = p2.Callerid AND c.last_call = p2.Datecalled
WHERE p1.Recipientid = p2.Recipientid