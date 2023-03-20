CREATE TABLE company_users
(
company_id int,
user_id int,
language varchar(20)
);

INSERT INTO company_users VALUES
(1, 1, 'English'),
(1, 1, 'German'),
(1, 2, 'English'),
(1, 3, 'German'),
(1, 3, 'English'),
(1, 4, 'English'),
(2, 5, 'English'),
(2, 5, 'German'),
(2, 5, 'Spanish'),
(2, 6, 'German'),
(2, 6, 'Spanish'),
(2, 7, 'English');

/* Find companies who have atleast 2 users who speaks English and German both the languages*/

SELECT * FROM company_users;

-- Step 1 : Find those users in company speaking both languages
SELECT company_id, user_id, COUNT(1) AS no_of_language_spoke
FROM company_users
WHERE language IN ('English', 'German')
GROUP By company_id, user_id
HAVING COUNT(1) = 2

-- Step 2 : Filter out company that is having 2 users.
SELECT company_id, COUNT(1) AS total_users FROM
(
SELECT company_id, user_id
FROM company_users
WHERE language IN ('English', 'German')
GROUP By company_id, user_id
HAVING COUNT(1) = 2) A
GROUP BY company_id
HAVING COUNT(1) >= 2

WITH lang
AS
(
SELECT company_id, user_id
FROM company_users
WHERE language IN ('English', 'German')
GROUP By company_id, user_id
HAVING COUNT(1) = 2)
SELECT company_id, COUNT(1) AS total_users
FROM lang
GROUP BY company_id
HAVING COUNT(1) >= 2