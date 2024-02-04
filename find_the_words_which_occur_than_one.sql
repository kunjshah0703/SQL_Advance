CREATE TABLE namaste_python
(
file_name varchar(25),
content varchar(200)
);

INSERT INTO namaste_python VALUES
('python bootcamp1.txt', 'python for data analytics 0 to hero bootcamp starting on Jan 6th'),
('python bootcamp2.txt', 'classes will be held from 11am to 1 pm for 5-6 weeks'),
('python bootcamp3.txt', 'use code NY2024 to get 33 percent off. You can register from namaste sql
website. Link in pinned comment');

SELECT * FROM namaste_python;

-- Q. Find the words which are repeating more than once considering all the rows of content column.

SELECT value AS word, COUNT(*) AS cnt_of_word
FROM namaste_python
CROSS APPLY string_split(content, ' ')
GROUP BY value
HAVING COUNT(*) > 1
ORDER BY cnt_of_word DESC;

