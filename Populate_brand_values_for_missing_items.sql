CREATE TABLE brands
(
category varchar(20),
brand_name varchar(20)
);

INSERT INTO brands VALUES
('chocolates', '5-star'),
(null, 'dairy milk'),
(null, 'perk'),
(null, 'eclair'),
('Biscuits','britannia'),
(null, 'good day'),
(null, 'boost');

-- Write a sql to populate category values to the last not null value

SELECT * FROM brands;

-- Step 1 : We will generate row_number

SELECT *
, ROW_NUMBER() OVER(ORDER BY (SELECT null)) AS rn
FROM brands

-- Step 2 : We will filter on not null values
WITH cte1
AS
(
SELECT *
, ROW_NUMBER() OVER(ORDER BY (SELECT null)) AS rn
FROM brands
)
SELECT *
FROM cte1
WHERE category IS NOT NULL

-- Step 3 : We will use lead function means anything between 1 and 4 put chocolate and else

WITH cte1
AS
(
SELECT *
, ROW_NUMBER() OVER(ORDER BY (SELECT null)) AS rn
FROM brands
)
, cte2
AS
(
SELECT *
, LEAD(rn, 1) OVER(ORDER BY rn) AS next_rn
FROM cte1
WHERE category IS NOT NULL)
SELECT cte2.category, cte1.brand_name
FROM cte1
INNER JOIN cte2
ON cte1.rn >= cte2.rn AND (cte1.rn <= cte2.next_rn-1 OR cte2.next_rn IS NULL)