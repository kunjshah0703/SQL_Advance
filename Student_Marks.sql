CREATE TABLE students
(
studentid int,
studentname varchar (255),
subject varchar (255),
marks int,
testid int,
testdate DATE
);

INSERT INTO students VALUES
(2, 'Max Ruin', 'Subject1', 63, 1, '2022-01-02'),
(3, 'Arnold', 'Subject1', 95, 1, '2022-01-02'),
(4, 'Krish Star', 'Subject1', 61, 1, '2022-01-02'),
(5, 'John Mike', 'Subject1', 91, 1, '2022-01-02'),
(4, 'Krish Star', 'Subject2', 71, 1, '2022-01-02'),
(3, 'Arnold', 'Subject2', 32, 1, '2022-01-02'),
(5, 'John Mike', 'Subject2', 61, 2, '2022-11-02'),
(1, 'John Deo', 'Subject2', 60, 1, '2022-01-02'),
(2, 'Max Ruin', 'Subject2', 84, 1, '2022-01-02'),
(2, 'Max Ruin', 'Subject3', 29, 3, '2022-01-03'),
(5, 'John Mike', 'Subject3', 98, 2, '2022-11-02');

/* Student Marks */

SELECT * FROM students

/* Write an SQL Query to get the list of students who scored above the average marks in each subject */
WITH avg_cte
AS
(
SELECT subject, AVG(marks) AS avg_marks
FROM students
GROUP BY subject)
SELECT s.*, ac.*
FROM students AS s
INNER JOIN avg_cte AS ac
ON s.subject = ac.subject
WHERE s.marks > ac.avg_marks

/* Write an SQL Query to get the percentage of students who score more than 90 in any subject amongst
the total students*/

SELECT 
COUNT(DISTINCT CASE WHEN marks > 90 THEN studentid ELSE NULL END)*1.0/COUNT(DISTINCT studentid) * 100 AS perc
FROM students

/* Write an SQL Query to get the second highest and second-lowest marks for each subject
Subject		 second_highest_marks	second_lowest_marks
Subject 1		91						63
Subject 2		71						60
Subject 3		29						98
*/

SELECT subject, marks
, RANK() OVER(PARTITION BY subject ORDER BY marks) AS rnk_asc
, RANK() OVER(PARTITION BY subject ORDER BY marks DESC ) AS rnk_desc
FROM students

SELECT subject,
SUM(CASE WHEN rnk_desc = 2 THEN marks ELSE NULL END) AS second_highest_marks,
SUM(CASE WHEN rnk_asc = 2 THEN marks ELSE NULL END) AS second_lowest_marks
FROM
(
SELECT subject, marks
, RANK() OVER(PARTITION BY subject ORDER BY marks) AS rnk_asc
, RANK() OVER(PARTITION BY subject ORDER BY marks DESC ) AS rnk_desc
FROM students) A
GROUP BY subject

/* For each student and test, identify if their marks increased or decreased from the previous test */

SELECT *
, CASE WHEN marks > prev_marks THEN 'increased' WHEN marks < prev_marks THEN 'decreased' ELSE NULL END AS status
FROM
(
SELECT *
,LAG(marks, 1) OVER(PARTITION BY studentid ORDER BY testdate, subject) AS prev_marks
FROM students
) A
