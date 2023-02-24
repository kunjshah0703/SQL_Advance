CREATE TABLE Trade_tbl
(
trade_id varchar(20),
trade_timestamp time,
trade_stock varchar(20),
quantity int,
price float
)

INSERT INTO Trade_tbl VALUES
('TRADE1', '10:01:05', 'ITJunction4All', 100, 20),
('TRADE2', '10:01:06', 'ITJunction4All', 20, 15),
('TRADE3', '10:01:08', 'ITJunction4All', 150, 30),
('TRADE4', '10:01:09', 'ITJunction4All', 300, 32),
('TRADE5', '10:10:00', 'ITJunction4All', -100, 19),
('TRADE6', '10:10:01', 'ITJunction4All', -300, 19);


/* Write SQL Query to find all couples of trade for same stock that happened in the range of 10
seconds and having price difference more than 10 %.
Output result should also list the percentage of price difference between the 2 trade
*/

SELECT * FROM Trade_tbl;

-- Step 1 : First we will pair all trade_ids with each other.

SELECT t1.trade_id, t2.trade_id
FROM Trade_tbl AS t1
INNER JOIN Trade_tbl AS t2
ON 1 = 1
ORDER BY t1.trade_id;

-- Step 2 : We don't want to pair TRADE1 with TRADE1 and same fo others.
SELECT t1.trade_id, t2.trade_id
FROM Trade_tbl AS t1
INNER JOIN Trade_tbl AS t2
ON 1 = 1
WHERE t1.trade_id != t2.trade_id
ORDER BY t1.trade_id;

-- Step 3 : We also need to eliminate similar parinings for e.g TRADE1 = TRADE2 and TRADE2 = TRADE1
SELECT t1.trade_id, t2.trade_id
FROM Trade_tbl AS t1
INNER JOIN Trade_tbl AS t2
ON 1 = 1
WHERE t1.trade_id != t2.trade_id AND t1.trade_timestamp < t2.trade_timestamp
ORDER BY t1.trade_id;

-- Step 4 :
SELECT t1.trade_id, t2.trade_id
FROM Trade_tbl AS t1
INNER JOIN Trade_tbl AS t2
ON 1 = 1
WHERE t1.trade_timestamp < t2.trade_timestamp
ORDER BY t1.trade_id;

-- Step 5 : We will check whether the difference is less than 10 seconds
SELECT t1.trade_id, t2.trade_id, t1.trade_timestamp, t2.trade_timestamp
FROM Trade_tbl AS t1
INNER JOIN Trade_tbl AS t2
ON 1 = 1
WHERE t1.trade_timestamp < t2.trade_timestamp AND DATEDIFF(second, t1.trade_timestamp, t2.trade_timestamp)<10
ORDER BY t1.trade_id;

-- Step 6 : Now we will check prices
SELECT t1.trade_id, t2.trade_id, t1.trade_timestamp, t2.trade_timestamp, t1.price, t2.price
FROM Trade_tbl AS t1
INNER JOIN Trade_tbl AS t2
ON 1 = 1
WHERE t1.trade_timestamp < t2.trade_timestamp 
AND DATEDIFF(second, t1.trade_timestamp, t2.trade_timestamp)<10
ORDER BY t1.trade_id;

-- Step 7 : Now will we will check if price difference is more than 10 %
SELECT t1.trade_id, t2.trade_id, t1.trade_timestamp, t2.trade_timestamp, t1.price, t2.price, 
abs(t1.price - t2.price)*1.0/t1.price * 100
FROM Trade_tbl AS t1
INNER JOIN Trade_tbl AS t2
ON 1 = 1
WHERE t1.trade_timestamp < t2.trade_timestamp 
AND DATEDIFF(second, t1.trade_timestamp, t2.trade_timestamp)<10
AND abs(t1.price - t2.price)*1.0/t1.price * 100 > 10
ORDER BY t1.trade_id;

-- Step 8 : What if there are other stocks
INSERT INTO Trade_tbl VALUES
('TRADE1', '10:01:05', 'TCS', 100, 20),
('TRADE2', '10:01:06', 'TCS', 20, 15),
('TRADE5', '10:10:00', 'TCS', -100, 19),
('TRADE6', '10:10:01', 'TCS', -300, 19)

-- Step 9 : New try if there are multiple stocks
SELECT t1.trade_stock,t1.trade_id, t2.trade_id, t1.trade_timestamp, t2.trade_timestamp, t1.price, t2.price, 
abs(t1.price - t2.price)*1.0/t1.price * 100 AS percentage_difference
FROM Trade_tbl AS t1
INNER JOIN Trade_tbl AS t2
ON t1.trade_stock = t2.trade_stock
WHERE t1.trade_timestamp < t2.trade_timestamp 
AND DATEDIFF(second, t1.trade_timestamp, t2.trade_timestamp)<10
AND abs(t1.price - t2.price)*1.0/t1.price * 100 > 10
ORDER BY t1.trade_id;