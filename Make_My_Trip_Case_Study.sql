CREATE TABLE booking_table(
Booking_id VARCHAR(3) NOT NULL 
,Booking_date date NOT NULL
,User_id VARCHAR(2) NOT NULL
,Line_of_business VARCHAR(6) NOT NULL
);

INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b1','2022-03-23','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b2','2022-03-27','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b3','2022-03-28','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b4','2022-03-31','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b5','2022-04-02','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b6','2022-04-02','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b7','2022-04-06','u5','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b8','2022-04-06','u6','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b9','2022-04-06','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b10','2022-04-10','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b11','2022-04-12','u4','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b12','2022-04-16','u1','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b13','2022-04-19','u2','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b14','2022-04-20','u5','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b15','2022-04-22','u6','Flight');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b16','2022-04-26','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b17','2022-04-28','u2','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b18','2022-04-30','u1','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b19','2022-05-04','u4','Hotel');
INSERT INTO booking_table(Booking_id,Booking_date,User_id,Line_of_business) VALUES ('b20','2022-05-06','u1','Flight');

CREATE TABLE user_table(
User_id VARCHAR(3) NOT NULL
,Segment VARCHAR(2) NOT NULL
);

INSERT INTO user_table(User_id,Segment) VALUES ('u1','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u2','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u3','s1');
INSERT INTO user_table(User_id,Segment) VALUES ('u4','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u5','s2');
INSERT INTO user_table(User_id,Segment) VALUES ('u6','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u7','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u8','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u9','s3');
INSERT INTO user_table(User_id,Segment) VALUES ('u10','s3');

-- Q.1 : Write an SQL query that gives the below output.
/* Segment	Total_user_count	User_who_booked_flight_in_2022
	s1			3					2
	s2			2					2
	s3			5					1
*/

SELECT * FROM booking_table;
SELECT * FROM user_table

-- Step 1 : We will join both the tables

SELECT u.Segment, COUNT(DISTINCT u.User_id) AS total_user_count
, COUNT(DISTINCT CASE WHEN b.Line_of_business = 'Flight' AND b.Booking_date BETWEEN '2022-04-01' AND '2022-04-30' THEN b.User_id END) AS User_who_booked_flight_in_2022
FROM user_table AS u
LEFT JOIN booking_table AS b
ON u.User_id = b.User_id
GROUP BY u.Segment

-- Q.2 : Write a query to identify users whose first booking was a hotel booking.

-- Step 1 : First we will find user's first booking(i.e flight or hotel)

SELECT * FROM(
SELECT *
, RANK() OVER(PARTITION BY User_id ORDER BY Booking_date ASC) AS rnk
FROM booking_table) A
WHERE rnk = 1 AND Line_of_business = 'Hotel'

-- Step 2 : Approach 2 first Value 

SELECT DISTINCT User_id FROM
(SELECT *
, FIRST_VALUE(Line_of_business) OVER(PARTITION BY User_id ORDER BY Booking_date ASC) AS rn
FROM booking_table) A
WHERE rn = 'Hotel'

-- Q.3 : Write a query to calculate the days between first and last booking of each user.

SELECT User_id, DATEDIFF(day, MIN(Booking_date), MAX(Booking_date)) AS no_of_days
FROM booking_table
GROUP BY User_id

-- Q.4 : Write a query to count the number of flight and hotel bookings in each of the user segments for the year 2022.

-- Step1 : We will check flight and hotel bookings by each user

SELECT *
, CASE WHEN Line_of_business = 'Flight' THEN 1 ELSE 0 END AS flight_flag
, CASE WHEN Line_of_business = 'Hotel' THEN 1 ELSE 0 END AS hotel_flag
FROM booking_table
GROUP BY User_id

SELECT User_id
, SUM(CASE WHEN Line_of_business = 'Flight' THEN 1 ELSE 0 END) AS flight_bookings
, SUM(CASE WHEN Line_of_business = 'Hotel' THEN 1 ELSE 0 END) AS hotel_bookings
FROM booking_table AS b
GROUP BY User_id
--INNER JOIN user_table AS u
--ON b.User_id = u.User_id

-- Step 2 : We need segment wise so joining both the tables

SELECT u.Segment
, SUM(CASE WHEN Line_of_business = 'Flight' THEN 1 ELSE 0 END) AS flight_bookings
, SUM(CASE WHEN Line_of_business = 'Hotel' THEN 1 ELSE 0 END) AS hotel_bookings
FROM booking_table AS b
INNER JOIN user_table AS u
ON b.User_id = u.User_id
WHERE DATEPART(year, b.Booking_date) = 2022
GROUP BY u.Segment
