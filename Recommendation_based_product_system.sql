CREATE TABLE orders1
(
order_id int,
customer_id int,
product_id int
);

CREATE TABLE products1
(
id int,
name varchar(10)
);

INSERT INTO orders1 VALUES
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

INSERT INTO products1 VALUES
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

/*
Recommendation system based on - product pairs most commonly purchased together
*/

SELECT * FROM orders1;
SELECT * FROM products1;

-- Step 1 : We will find the pairs within the orders table for that we will do self join.

SELECT o1.order_id, o1.product_id AS p1, o2.product_id AS p2 FROM orders1 AS o1
INNER JOIN orders1 AS o2
ON o1.order_id = o2.order_id
WHERE o1.order_id = 1 AND o1.product_id != o2.product_id AND o1.product_id > o2.product_id;

-- Step 2 : We will do for all order_ids
SELECT o1.order_id, o1.product_id AS p1, o2.product_id AS p2 FROM orders1 AS o1
INNER JOIN orders1 AS o2
ON o1.order_id = o2.order_id
WHERE o1.product_id > o2.product_id;

-- Step 3: We will calculate purchase frequency
SELECT o1.product_id AS p1, o2.product_id AS p2, COUNT(1) AS purchase_freq
FROM orders1 AS o1
INNER JOIN orders1 AS o2
ON o1.order_id = o2.order_id
WHERE o1.product_id > o2.product_id
GROUP BY o1.product_id, o2.product_id;

-- Step 4 : We will join with products table for name
SELECT pr1.name + ' ' + pr2.name AS pair, COUNT(1) AS purchase_freq
FROM orders1 AS o1
INNER JOIN orders1 AS o2
ON o1.order_id = o2.order_id
INNER JOIN products1 AS pr1
ON pr1.id = o1.product_id
INNER JOIN products1 AS pr2
ON pr2.id = o2.product_id
WHERE o1.product_id > o2.product_id
GROUP BY pr1.name, pr2.name;