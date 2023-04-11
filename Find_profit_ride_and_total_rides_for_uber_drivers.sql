CREATE TABLE drivers
(
id varchar(10),
start_time time,
end_time time,
start_loc varchar(10),
end_loc varchar(10)
);

INSERT INTO drivers VALUES
('dri_1', '09:00', '09:30', 'a', 'b'),
('dri_1', '09:30', '10:30', 'b', 'c'),
('dri_1', '11:00', '11:30', 'd', 'e'),
('dri_1', '12:00', '12:30', 'f', 'g'),
('dri_1', '13:30', '14:30', 'c', 'h'),
('dri_2', '12:15', '12:30', 'f', 'g'),
('dri_2', '13:30', '14:30', 'c', 'h');

SELECT * FROM drivers;

/* Write a query to print total rides and profit rides for each driver. */
/* Profit ride is when the end location of current ride is same as start location on next ride. */

-- Method 1 : Lead function 
-- Step 1 : For each ride we will check previous location and id start and previous are same then it is a profit ride. 

SELECT id, COUNT(1) AS total_rides
, SUM(CASE WHEN end_loc = next_start_loc THEN 1 ELSE 0 END) AS profit_ride
FROM(
SELECT *
, LEAD(start_loc, 1) OVER(PARTITION BY id ORDER BY start_time ASC) AS next_start_loc
FROM drivers) A
GROUP BY id;

-- Method 2 : Self - Join.
-- Step 1 : We will generate row number to check if end loc is same as start as we need to check consecutive rows.

WITH ride
AS
(
SELECT *
, ROW_NUMBER() OVER(PARTITION BY id ORDER BY start_time ASC) AS rn
FROM drivers
)
SELECT r1.id, COUNT(1) AS total_rides, COUNT(r2.id) AS profit_rides 
FROM ride AS r1
LEFT JOIN ride AS r2
ON r1.id = r2.id AND r1.end_loc = r2.start_loc AND r1.rn+1 = r2.rn
GROUP BY r1.id;

