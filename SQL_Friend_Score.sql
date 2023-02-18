/*
Write a query to find personid, Name, number of friends, sum of marks of person who have friends
with total score greater than 100.
*/

SELECT * FROM friend;

SELECT * FROM person;

-- Step 1 : In this Query we will get score of persons friends.
SELECT f.PersonID, f.FriendID, p.Score AS friend_score
FROM friend AS f
INNER JOIN person AS p
ON f.FriendID = p.PersonID;

-- Step 2 : We will take aggregated score on person id where score is greater than 100
SELECT f.PersonID,SUM(p.Score) AS total_friend_score
FROM friend AS f
INNER JOIN person AS p
ON f.FriendID = p.PersonID
GROUP BY f.PersonID
HAVING SUM(p.Score) > 100;

-- Step 3 : We will take count of friends
SELECT f.PersonID, SUM(p.Score) AS total_friend_score, COUNT(1) AS total_number_of_friends
FROM friend AS f
INNER JOIN person AS p
ON f.FriendID = p.PersonID
GROUP BY f.PersonID, p.Name
HAVING SUM(p.Score) > 100;

-- STep 4 : Making CTE
WITH score_details
AS
(
SELECT f.PersonID, SUM(p.Score) AS total_friend_score, COUNT(1) AS total_number_of_friends
FROM friend AS f
INNER JOIN person AS p
ON f.FriendID = p.PersonID
GROUP BY f.PersonID
HAVING SUM(p.Score) > 100
)
SELECT s.*, p.Name AS person_name
FROM person AS p
INNER JOIN score_details AS s
ON p.PersonID = s.PersonID;