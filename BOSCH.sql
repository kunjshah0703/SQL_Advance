CREATE TABLE call_details
(
call_type VARCHAR(10),
call_number VARCHAR(12),
call_duration int
);

INSERT INTO call_details VALUES
('OUT', '181868', 13),
('OUT', '2159010', 8),
('OUT', '2159010', 178),
('SMS', '4153810', 1),
('OUT','2159010',152),
('OUT','9140152',18),
('SMS','4162672',1),
('SMS','9168204',1),
('OUT','9168204',576),
('INC','2159010',5),
('INC','2159010',4),
('SMS','2159010',1),
('SMS','4535614',1),
('OUT','181868',20),
('INC','181868',54),
('INC','218748',20),
('INC','2159010',9),
('INC','197432',66),
('SMS','2159010',1),
('SMS','4535614',1);

/* Write a SQL to determine phone numbers that satisfy below conditions : 
1 - The numbers have both incoming and outgoing calls
2 - The sum of duration of outgoing calls should be greater than sum of duration of incoming calls */

SELECT * FROM call_details;

-- Approach 1 : CTE AND FILTER CLAUSE
WITH cte
AS
(
SELECT call_number
, SUM(CASE WHEN call_type = 'OUT' THEN call_duration ELSE NULL END) AS out_duration
, SUM(CASE WHEN call_type = 'INC' THEN call_duration ELSE NULL END) AS inc_duration
FROM call_details
GROUP BY call_number)
SELECT *
FROM cte
WHERE out_duration IS NOT NULL AND inc_duration IS NOT NULL AND out_duration > inc_duration

-- Approach 2 : Using HAVING CLAUSE

SELECT call_number
-- , SUM(CASE WHEN call_type = 'OUT' THEN call_duration ELSE NULL END) AS out_duration
-- , SUM(CASE WHEN call_type = 'INC' THEN call_duration ELSE NULL END) AS inc_duration
FROM call_details
GROUP BY call_number
HAVING SUM(CASE WHEN call_type = 'OUT' THEN call_duration ELSE NULL END) > 0 AND
SUM(CASE WHEN call_type = 'INC' THEN call_duration ELSE NULL END) > 0 AND
SUM(CASE WHEN call_type = 'OUT' THEN call_duration ELSE NULL END) > SUM(CASE WHEN call_type = 'INC' THEN call_duration ELSE NULL END)

-- Approach 3 : Using CTE AND JOIN

WITH cte_out
AS
(
SELECT call_number
, SUM(call_duration) AS duration
FROM call_details
WHERE call_type = 'OUT'
GROUP BY call_number
), cte_inc
AS
(
SELECT call_number
, SUM(call_duration) AS duration
FROM call_details
WHERE call_type = 'INC'
GROUP BY call_number
)
SELECT cte_out.call_number
FROM cte_out
INNER JOIN cte_inc
ON cte_out.call_number = cte_inc.call_number
WHERE cte_out.duration > cte_inc.duration