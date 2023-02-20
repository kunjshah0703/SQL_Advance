CREATE TABLE Users2
(
user_id int,
join_date DATE,
favorite_brand varchar(50)
)

CREATE TABLE orders
(
order_id int,
order_date DATE,
item_id int,
buyer_id int,
seller_id int
)

CREATE TABLE items
(
item_id int,
item_brand varchar(50)
);

INSERT INTO Users2 VALUES
(1, '2019-01-01', 'Lenovo'),
(2, '2019-02-09', 'Samsung'),
(3, '2019-01-19', 'LG'),
(4, '2019-05-21', 'HP');

INSERT INTO orders VALUES
(1, '2019-08-01', 4, 1, 2),
(2, '2019-08-02', 2, 1, 3),
(3, '2019-08-03', 3, 2, 3),
(4, '2019-08-04', 1, 4, 2),
(5, '2019-08-04', 1, 3, 4),
(6, '2019-08-05', 2, 2, 4);

INSERT INTO items VALUES
(1, 'Samsung'),
(2, 'Lenovo'),
(3, 'LG'),
(4, 'HP');

/* Market Analysis : Write an SQL Query to find for each seller, whether the brand of the second item
(by date) they sold is their favorite brand or not.
If a seller sold less than 2 items , report the answer for that seller as no.o/p
1   yes/no
2   yes/no
*/

SELECT * FROM Users2;

SELECT * FROM orders;

SELECT * FROM items;
-- Step 1 : We will first get second order of each seller by rank function.
WITH rnk_orders
AS
(
SELECT *,
RANK() OVER(PARTITION BY seller_id ORDER BY order_date) AS rn
FROM orders)
SELECT * FROM rnk_orders
WHERE rn = 2;

-- Step 2 : We will get brand name of that item_id
WITH rnk_orders
AS
(
SELECT *,
RANK() OVER(PARTITION BY seller_id ORDER BY order_date) AS rn
FROM orders)
SELECT ro.*, i.item_brand FROM rnk_orders AS ro
INNER JOIN items AS i
ON i.item_id = ro.item_id
WHERE rn = 2;

-- Step 3 : We will check favorite brand of each seller
WITH rnk_orders
AS
(
SELECT *,
RANK() OVER(PARTITION BY seller_id ORDER BY order_date) AS rn
FROM orders)
SELECT ro.*, i.item_brand, u.favorite_brand FROM rnk_orders AS ro
INNER JOIN items AS i
ON i.item_id = ro.item_id
INNER JOIN Users2 AS u
ON ro.seller_id = u.user_id
WHERE rn = 2

-- Step 4 : We will check if item_brand and favorite_brand is same or not
WITH rnk_orders
AS
(
SELECT *,
RANK() OVER(PARTITION BY seller_id ORDER BY order_date) AS rn
FROM orders)
SELECT ro.*, i.item_brand, u.favorite_brand,
CASE WHEN i.item_brand = u.favorite_brand THEN 'YES' ELSE 'NO' END AS second_item_fav_brand
FROM rnk_orders AS ro
INNER JOIN items AS i
ON i.item_id = ro.item_id
INNER JOIN Users2 AS u
ON ro.seller_id = u.user_id
WHERE rn = 2;

-- Step 5 : But we need to check if seller has sold less than 2 items and need to report them
WITH rnk_orders
AS
(
SELECT *,
RANK() OVER(PARTITION BY seller_id ORDER BY order_date) AS rn
FROM orders)
SELECT u.user_id AS seller_id,
CASE WHEN i.item_brand = u.favorite_brand THEN 'YES' ELSE 'NO' END AS second_item_fav_brand
FROM Users2 AS u
LEFT JOIN rnk_orders AS ro
ON ro.seller_id = u.user_id AND rn =2
LEFT JOIN items AS i
ON i.item_id = ro.item_id
--WHERE rn = 2;
