CREATE TABLE tbl_orders
(
order_id int,
order_date DATE
);

INSERT INTO tbl_orders VALUES
(1, '2022-10-21'),
(2, '2022-10-22'),
(3, '2022-10-25'),
(4, '2022-10-25'),
(5, '2022-10-26'),
(6, '2022-10-26');

-- Step 1 : Find new records inserted or deleted

SELECT * FROM tbl_orders;

-- Making a copy of table orders
SELECT * INTO tbl_orders_copy FROM tbl_orders;

-- Two new inserts on next day
INSERT INTO tbl_orders VALUES
(7, '2022-10-27'),
(8, '2022-10-27');

-- One record is deleted
DELETE FROM tbl_orders WHERE order_id = 1;

SELECT * FROM tbl_orders
SELECT * FROM tbl_orders_copy

-- Expected Output : 
/* order_id	Flag
   1		D
   7		I
   8		I */

-- We will join same table

SELECT o.*, c.*
FROM tbl_orders AS o
FULL OUTER JOIN tbl_orders_copy AS c
ON o.order_id = c.order_id;

-- If Order_id is Null in copy table then they are new records or vise- versa.

SELECT COALESCE(o.order_id, c.order_id) AS order_id
, CASE WHEN c.order_id IS NULL THEN 'I'
WHEN o.order_id IS NULL THEN 'D'
END AS flag
FROM tbl_orders AS o
FULL OUTER JOIN tbl_orders_copy AS c
ON o.order_id = c.order_id
WHERE c.order_id IS NULL OR o.order_id IS NULL;




