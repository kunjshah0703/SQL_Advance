SELECT * FROM purchase_history

SET DATEFORMAT dmy;

INSERT INTO purchase_history VALUES
(1, 1, '23-01-2012'),
(1, 2, '23-01-2012'),
(1, 3, '25-01-2012'),
(2, 1, '23-01-2012'),
(2, 2, '23-01-2012'),
(2, 2, '25-01-2012'),
(2, 4, '25-01-2012'),
(3, 4, '23-01-2012'),
(3, 1, '23-01-2012'),
(4, 1, '23-01-2012'),
(4, 2, '25-01-2012');

/* Write a SQL query to find users who purchased different products on different dates. */
/* i.e : products purchased on any given day are not repeated on any other day. */

SELECT * FROM purchase_history;

-- Step 1: We will check whether they have purchased on different dates and productid is not repeated.

SELECT userid, COUNT(DISTINCT purchasedate) AS no_of_dates
, COUNT(productid) AS cnt_product, COUNT(DISTINCT productid) AS cnt_distinct_product
FROM purchase_history
GROUP BY userid

-- Step 2: We will check condition where no_of_dates is greater than 1 and cnt_product = cnt_distinct_product

WITH cte
AS
(
SELECT userid, COUNT(DISTINCT purchasedate) AS no_of_dates
, COUNT(productid) AS cnt_product, COUNT(DISTINCT productid) AS cnt_distinct_product
FROM purchase_history
GROUP BY userid
)
SELECT userid
FROM cte
WHERE no_of_dates > 1 AND cnt_product = cnt_distinct_product

-- Approach 2 : 
SELECT userid, COUNT(DISTINCT purchasedate) AS no_of_dates
, COUNT(productid) AS cnt_product, COUNT(DISTINCT productid) AS cnt_distinct_product
FROM purchase_history
GROUP BY userid
HAVING COUNT(DISTINCT purchasedate) > 1 AND COUNT(productid) = COUNT(DISTINCT productid)