CREATE TABLE players_location
(
name varchar(20),
city varchar(20)
);

INSERT INTO players_location VALUES
('Sachin', 'Mumbai'),
('Virat', 'Delhi'),
('Rahul', 'Bangalore'),
('Rohit', 'Mumbai'),
('Mayank', 'Bangalore');

/* pivot players by their cities. */

SELECT * FROM players_location;

-- Step1 : First we will generate row_number for each city.

SELECT *,
ROW_NUMBER() OVER(PARTITION BY city ORDER BY name) AS player_groups
FROM players_location

-- Step 2 : Pivot
SELECT 
MAX(CASE WHEN city = 'Bangalore' THEN name END) AS Bangalore
, MAX(CASE WHEN city = 'Mumbai' THEN name END) AS Mumbai
, MIN(CASE WHEN city = 'DELHI' THEN name END) AS Delhi
FROM
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY city ORDER BY name) AS player_groups
FROM players_location) A
GROUP BY player_groups