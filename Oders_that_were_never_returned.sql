CREATE TABLE namaste_orders
(
order_id int,
city varchar(10),
sales int
);

CREATE TABLE namaste_returns
(
order_id int,
return_reason varchar(20)
);

INSERT INTO namaste_orders VALUES
(1, 'Mysore', 100),
(2, 'Mysore', 200),
(3, 'Bangalore', 250),
(4, 'Bangalore', 150),
(5, 'Mumbai', 300),
(6, 'Mumbai', 500),
(7, 'Mumbai', 800);

INSERT INTO namaste_returns VALUES
(3, 'wrong item'),
(6, 'bad quality'),
(7, 'wrong item');

SELECT * FROM namaste_orders;
SELECT * FROM namaste_returns;

-- Q. Return those city name where order was delivered and not returned single time.

-- Solution 1 : Without using cte, windows function and subquery
SELECT o.city, COUNT(r.order_id) AS no_of_returned_orders
FROM namaste_orders AS o
LEFT JOIN namaste_returns AS r
ON o.order_id = r.order_id
GROUP BY o.city
HAVING COUNT(r.order_id) = 0;
--WHERE r.order_id IS NULL OR r.return_reason IS NULL;

-- Solution 2 : Using subquery
SELECT DISTINCT city
FROM namaste_orders
WHERE city NOT IN (
SELECT DISTINCT city
FROM namaste_orders
WHERE order_id IN (SELECT order_id FROM namaste_returns))