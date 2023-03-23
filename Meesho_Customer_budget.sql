CREATE TABLE products3
(
product_id varchar(20),
cost int
);

CREATE TABLE customer_budget
(
customer_id int,
budget int
);

INSERT INTO products3 VALUES
('P1', 200),
('P2',300),
('P3', 500),
('P4', 800);

INSERT INTO customer_budget VALUES
(100, 400),
(200, 800),
(300, 1500);

/* Q.Find how many products falls into customer budget along with list of products in case of clash
choose the less costly product*/

SELECT * FROM products3
SELECT * FROM customer_budget

-- Step 1 : First we will calculate running sum for products table
WITH runn_cost
AS
(
SELECT *,
SUM(cost) OVER(ORDER BY cost) AS running_cost
FROM products3)

-- Step 2 : We will check whether running cost is less than budget of the customer
SELECT cb.customer_id, cb.budget, COUNT(1) AS no_of_products, STRING_AGG(product_id,',') AS list_of_products 
FROM customer_budget AS cb
LEFT JOIN runn_cost AS rc
ON rc.running_cost < cb.budget
GROUP BY cb.customer_id, cb.budget