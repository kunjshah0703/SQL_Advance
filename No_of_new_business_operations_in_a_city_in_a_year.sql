CREATE TABLE business_city
(
business_date DATE,
city_id int
);

INSERT INTO business_city VALUES
(CAST('2020-01-02' AS DATE), 3),
(CAST('2020-07-01' AS DATE), 7),
(CAST('2021-01-01' AS DATE), 3),
(CAST('2021-02-03' AS DATE), 19),
(CAST('2022-12-01' AS DATE), 3),
(CAST('2022-12-15' AS DATE), 3),
(CAST('2022-02-28' AS DATE), 12);

/* Business city table has data from the day Udaan has started it's operation. */
/* Write a SQL to identify yearwise count of new cities where udaan started their operation. */

SELECT * FROM business_city;

-- Step 1 : We will extract year out of it.

SELECT DATEPART(year, business_date) AS business_year, city_id
FROM business_city;

-- Step 2 : We will do self join

WITH cte
AS
(
SELECT DATEPART(year, business_date) AS business_year, city_id
FROM business_city)
SELECT c1.*, c2.*
FROM cte AS c1
LEFT JOIN cte AS c2
ON c1.business_year > c2.business_year AND c1.city_id = c2.city_id

-- Step 3 : Wherever there is null that are new business operations.

WITH city_new
AS
(
SELECT DATEPART(year, business_date) AS business_year, city_id
FROM business_city)
SELECT c1.business_year
, COUNT(DISTINCT CASE WHEN c2.business_year IS NULL THEN c1.city_id END) AS no_of_new_cities
FROM city_new AS c1
LEFT JOIN city_new AS c2
ON c1.business_year > c2.business_year AND c1.city_id = c2.city_id
GROUP BY c1.business_year