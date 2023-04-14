CREATE TABLE hall_events
(
hall_id int,
start_date date,
end_date date
);

INSERT INTO hall_events VALUES
(1, '2023-01-13', '2023-01-14'),
(1, '2023-01-14', '2023-01-17'),
(1, '2023-01-15', '2023-01-17'),
(1, '2023-01-18', '2023-01-25'),
(2, '2022-12-09', '2022-12-23'),
(2, '2022-12-13', '2022-12-17'),
(3, '2022-12-01', '2023-01-30');

/* Merge overlapping events in the same hall. */

SELECT * FROM hall_events;

-- Step 1 : We will create event id based on start_date

SELECT *
, ROW_NUMBER() OVER(ORDER BY hall_id, start_date) AS event_id
FROM hall_events

-- Step 2 : We will use recursive CTE and check loop conditons. We will create flag overlapping events 1 and not 2

WITH cte
AS
(
SELECT *
, ROW_NUMBER() OVER(ORDER BY hall_id, start_date) AS event_id
FROM hall_events
)
, r_cte   -- In r_cte we have the first row
AS
(
SELECT hall_id, start_date, end_date, event_id
FROM cte
WHERE event_id = 1
UNION ALL
SELECT cte.hall_id, cte.start_date, cte.end_date, cte.event_id
FROM r_cte
INNER JOIN cte
ON r_cte.event_id + 1 = cte.event_id
)
SELECT *
FROM r_cte

-- Step 3 : We will set a flag and check looping condition

WITH cte
AS
(
SELECT *
, ROW_NUMBER() OVER(ORDER BY hall_id, start_date) AS event_id
FROM hall_events
)
, r_cte   -- In r_cte we have the first row
AS
(
SELECT hall_id, start_date, end_date, event_id, 1 AS flag
FROM cte
WHERE event_id = 1
UNION ALL
SELECT cte.hall_id, cte.start_date, cte.end_date, cte.event_id
, CASE WHEN cte.hall_id = r_cte.hall_id AND (cte.start_date BETWEEN r_cte.start_date AND r_cte.end_date)
OR (r_cte.start_date BETWEEN cte.start_date AND cte.end_date) THEN 0 ELSE 1 END + flag AS flag
FROM r_cte
INNER JOIN cte
ON r_cte.event_id + 1 = cte.event_id
)
SELECT hall_id, flag, MIN(start_date) AS start_date, MAX(end_date) AS end_date
FROM r_cte
GROUP BY hall_id, flag
