CREATE TABLE buy
(
Date int,
Time int,
Qty int,
per_share_price int,
total_value int
);

CREATE TABLE sell
(
Date int,
Time int,
Qty int,
per_share_price int,
total_value int
);

INSERT INTO buy VALUES
(15, 10, 10, 10, 100),
(15, 14, 20, 10, 200);

INSERT INTO sell VALUES
(15, 15, 15, 20, 300);

/* Q. Find how many quantities were sold. */

SELECT * FROM buy;
SELECT * FROM sell;

-- Step 1: We will check if buy time is less than sell time
SELECT b.Time AS buy_time, b.Qty AS buy_qty, s.Qty AS sell_qty
FROM buy as b
INNER JOIN sell as s
ON b.Date = s.Date AND b.Time < s.Time

-- Step 2 : We will take running sum of buy quantity

SELECT b.Time AS buy_time, b.Qty AS buy_qty, s.Qty AS sell_qty
, SUM(b.Qty) OVER(ORDER BY b.Time) AS running_buy_qty
FROM buy as b
INNER JOIN sell as s
ON b.Date = s.Date AND b.Time < s.Time

-- Step 3 : We will check how much we bought

SELECT b.Time AS buy_time, b.Qty AS buy_qty, s.Qty AS sell_qty
, SUM(b.Qty) OVER(ORDER BY b.Time) AS running_buy_qty
, ISNULL(SUM(b.Qty) OVER(ORDER BY b.Time ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) AS running_buy_qty_prev
FROM buy as b
INNER JOIN sell as s
ON b.Date = s.Date AND b.Time < s.Time

-- STep 4 : We will calculate sell shares

WITH running_sum_values
AS
(
SELECT b.Time AS buy_time, b.Qty AS buy_qty, s.Qty AS sell_qty
, SUM(b.Qty) OVER(ORDER BY b.Time) AS running_buy_qty
, ISNULL(SUM(b.Qty) OVER(ORDER BY b.Time ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING),0) AS running_buy_qty_prev
FROM buy as b
INNER JOIN sell as s
ON b.Date = s.Date AND b.Time < s.Time
)
SELECT buy_time
, CASE WHEN sell_qty >= running_buy_qty THEN buy_qty ELSE sell_qty - running_buy_qty_prev END AS buy_qty
, CASE WHEN sell_qty >= running_buy_qty THEN buy_qty ELSE sell_qty - running_buy_qty_prev END AS sell_qty
FROM running_sum_values
UNION ALL
SELECT buy_time, running_buy_qty - sell_qty AS buy_qty
, NULL AS sell_qty
FROM running_sum_values
WHERE sell_qty < running_buy_qty