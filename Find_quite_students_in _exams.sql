CREATE TABLE students1
(
student_id int,
student_name varchar(20)
);

CREATE TABLE exams1
(
exam_id int,
student_id int,
score int
);

INSERT INTO students1 VALUES
(1, 'Daniel'),
(2, 'Jade'),
(3, 'Stella'),
(4, 'Jonathan'),
(5, 'Will');

INSERT INTO exams1 VALUES
(10, 1, 70),
(10, 2, 80),
(10, 3, 90),
(20, 1, 80),
(30, 1, 70),
(30, 3, 80),
(30, 4, 90),
(40, 1, 60),
(40, 2, 70),
(40, 4, 80);

/* Write an SQL to report the students (student_id, student_name) being "quite" in ALL exams. */
/* A "quite" student is the one who took atleast one exam and didn't score neither the high score nor the low
score in any of the exam.*/
/* Don't return the student who has never taken any exam. Return the table ordered by student_id */

SELECT * FROM students1
SELECT * FROM exams1

--Step 1 : We will identify highest and lowest marks from each exam_id

SELECT exam_id, MIN(score) AS min_Score, MAX(score) AS max_score
FROM exams1
GROUP BY exam_id

-- Step 2 : We will join with exams table so we will get whether student is having max or low score in that exam

WITH all_scores
AS
(
SELECT exam_id, MIN(score) AS min_Score, MAX(score) AS max_score
FROM exams1
GROUP BY exam_id
)
SELECT exams1.*, all_scores.min_score, all_scores.max_score
FROM exams1
INNER JOIN all_scores
ON exams1.exam_id = all_scores.exam_id

-- Step 3 : We will compare

WITH all_scores
AS
(
SELECT exam_id, MIN(score) AS min_Score, MAX(score) AS max_score
FROM exams1
GROUP BY exam_id
)
SELECT exams1.student_id, all_scores.min_score, all_scores.max_score
, MAX(CASE WHEN score = all_scores.min_score OR score = all_scores.max_score THEN 1 else 0 END) AS red_flag
FROM exams1
INNER JOIN all_scores
ON exams1.exam_id = all_scores.exam_id
GROUP BY exams1.student_id

-- Step 4 : Final Solution will take max of 0's

WITH all_scores
AS
(
SELECT exam_id, MIN(score) AS min_Score, MAX(score) AS max_score
FROM exams1
GROUP BY exam_id
)
SELECT exams1.student_id
, MAX(CASE WHEN score = all_scores.min_score OR score = all_scores.max_score THEN 1 else 0 END) AS red_flag
FROM exams1
INNER JOIN all_scores
ON exams1.exam_id = all_scores.exam_id
GROUP BY exams1.student_id
HAVING MAX(CASE WHEN score = all_scores.min_score OR score = all_scores.max_score THEN 1 else 0 END) = 0