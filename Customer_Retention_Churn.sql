CREATE TABLE transactions
(
order_id int,
cust_id int,
order_date date,
amount int
);

INSERT INTO transactions VALUES
(1, 1, '2020-01-15', 150),
(2, 1, '2020-02-10', 150),
(3, 2, '2020-01-16', 150),
(4, 2, '2020-02-25', 150),
(5, 3, '2020-01-10', 150),
(6, 3, '2020-02-20', 150),
(7, 4, '2020-01-20', 150),
(8, 5, '2020-02-20', 150);

/*
-- Customer retention and customer churn metrics.

-- Customer retention : Refers to a company's ability to turn customers into repeat buyers and prevent
from switching to a competitor.
It indicates whether your product and the quality of your service please your existing customers.
reward program(cc companies)
wallet cash back(paytm/gpay)
zomato pro/ swiggy super

retention period
*/
-- jan 0
-- feb 1, 2, 3 --> 3
-- marc 0
SELECT * FROM transactions;

-- Step 1: First we will check whether customer has ordered in previous month ? (Retention)

SELECT MONTH(this_month.order_date) AS month_date, COUNT(DISTINCT last_month.cust_id)
FROM transactions AS this_month
LEFT JOIN 
transactions AS last_month
ON this_month.cust_id = last_month.cust_id AND DATEDIFF(month, last_month.order_date, this_month.order_date)=1
GROUP BY MONTH(this_month.order_date)

-- Step 2 : Customer churn
SELECT MONTH(last_month.order_date) AS month_date, COUNT(DISTINCT last_month.cust_id)
FROM transactions AS last_month
LEFT JOIN 
transactions AS this_month
ON this_month.cust_id = last_month.cust_id AND DATEDIFF(month, last_month.order_date, this_month.order_date)=1
WHERE MONTH(last_month.order_date)=1
AND this_month.cust_id IS NULL
GROUP BY MONTH(last_month.order_date)

SELECT MONTH(last_month.order_date) AS month_date, COUNT(DISTINCT last_month.cust_id)
FROM transactions AS last_month
LEFT JOIN 
transactions AS this_month
ON this_month.cust_id = last_month.cust_id AND DATEDIFF(month, last_month.order_date, this_month.order_date)=1
WHERE this_month.cust_id IS NULL
GROUP BY MONTH(last_month.order_date)
