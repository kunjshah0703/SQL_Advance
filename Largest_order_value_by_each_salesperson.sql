CREATE TABLE int_orders
(
order_number int,
order_date date,
cust_id int,
salesperson_id int,
amount float
);

INSERT INTO int_orders VALUES
(30, '1995-07-14', 9, 1, 460),
(10, '1996-08-02', 4, 2, 540),
(40, '1998-01-29', 7, 2, 2400),
(50, '1998-02-03', 6, 7, 600),
(60, '1998-03-02', 6, 7, 720),
(70, '1998-05-06', 9, 7, 150),
(20, '1999-01-30', 4, 8, 1800);

/* Find the largest order by value for each salesperson and display order details.
Get the result without usingsubquery, cte, window functions, temp tables*/


SELECT i.order_number, i.order_date, i.cust_id, i.salesperson_id, i.amount
FROM int_orders AS i
LEFT JOIN int_orders AS i1
ON i.salesperson_id = i1.salesperson_id
GROUP BY i.order_number, i.order_date, i.cust_id, i.salesperson_id, i.amount
HAVING i.amount >= MAX(i1.amount);