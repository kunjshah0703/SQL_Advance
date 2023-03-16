CREATE TABLE exams
(
student_id int,
subject varchar(20),
marks int
);

INSERT INTO exams VALUES
(1, 'Chemistry', 91),
(1, 'Physics', 91),
(2, 'Chemistry', 80),
(2, 'Physics', 90),
(3, 'Chemistry', 80),
(4, 'Chemistry', 71),
(4, 'Physics', 54);

-- Find Students with same marks in Pysics and Chemistry

SELECT * FROM exams;

SELECT student_id
FROM exams
WHERE subject IN ('Chemistry', 'Physics')
GROUP BY student_id
HAVING COUNT(DISTINCT subject) = 2 AND COUNT(DISTINCT marks) = 1