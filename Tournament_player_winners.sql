CREATE TABLE players
(
player_id int,
group_id int
)

CREATE TABLE matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int
);

INSERT INTO players VALUES
(15, 1),
(25, 1),
(30, 1),
(45, 1),
(10, 2),
(35, 2),
(50, 2),
(20, 3),
(40, 3);

INSERT INTO matches VALUES
(1, 15, 45, 3, 0),
(2, 30, 25, 1, 2),
(3, 30, 15, 2, 0),
(4, 40, 20, 5, 2),
(5, 35, 50, 1, 1);

/*
Write an SQL query to find the winner in each group

-- The winner in each group is the player who scored the maximum total points within the group,
In case of a tie the lowest player_id wins.
*/

SELECT * FROM players;

SELECT * FROM matches;

-- Step 1 : Getting aggregated score of players
WITH player_score
AS
(
SELECT first_player AS player_id, first_score AS score
FROM matches
UNION ALL
SELECT second_player AS player_id, second_score AS score
FROM matches
)
SELECT player_id, SUM(score) AS score
FROM player_score
GROUP BY player_id;

-- Step 2 : We will get group of each players
WITH player_score
AS
(
SELECT first_player AS player_id, first_score AS score
FROM matches
UNION ALL
SELECT second_player AS player_id, second_score AS score
FROM matches
)
SELECT p.group_id, ps.player_id, SUM(score) AS score
FROM player_score AS ps
INNER JOIN players AS p
ON p.player_id = ps.player_id
GROUP BY p.group_id, ps.player_id;

-- Step 3 : We need to winner from each group by maximum score.
WITH player_score
AS
(
SELECT first_player AS player_id, first_score AS score
FROM matches
UNION ALL
SELECT second_player AS player_id, second_score AS score
FROM matches
),
final_score
AS
(
SELECT p.group_id, ps.player_id, SUM(score) AS score
FROM player_score AS ps
INNER JOIN players AS p
ON p.player_id = ps.player_id
GROUP BY p.group_id, ps.player_id),
final_ranking
AS
(
SELECT *,
RANK() OVER(PARTITION BY group_id ORDER BY score DESC, player_id ASC) AS rn
FROM final_score)
SELECT *
FROM final_ranking
WHERE rn = 1;