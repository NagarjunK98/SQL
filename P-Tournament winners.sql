'''
player: player_id, group_id. player_id is the primary key of this table.Each row of this table indicates the group of each player.

Matches: match_id, first_player, second_player, first_score, second_score

match_id is the primary key of this table.Each row is a record of a match, 
first_player and second_player contain the player_id of each match.first_score and second_score 
contain the number of points of the first_player and second_player respectively.
You may assume that, in each match, players belong to the same group.

The winner in each group is the player who scored the maximum total points within the group. 
In the case of a tie, the lowest player_id wins.

Write an SQL query to find the winner in each group

Input: 
Players table:
+-----------+------------+
| player_id | group_id   |
+-----------+------------+
| 15        | 1          |
| 25        | 1          |
| 30        | 1          |
| 45        | 1          |
| 10        | 2          |
| 35        | 2          |
| 50        | 2          |
| 20        | 3          |
| 40        | 3          |
+-----------+------------+
Matches table:
+------------+--------------+---------------+-------------+--------------+
| match_id   | first_player | second_player | first_score | second_score |
+------------+--------------+---------------+-------------+--------------+
| 1          | 15           | 45            | 3           | 0            |
| 2          | 30           | 25            | 1           | 2            |
| 3          | 30           | 15            | 2           | 0            |
| 4          | 40           | 20            | 5           | 2            |
| 5          | 35           | 50            | 1           | 1            |
+------------+--------------+---------------+-------------+--------------+

Output: 
+-----------+------------+
| group_id  | player_id  |
+-----------+------------+ 
| 1         | 15         |
| 2         | 35         |
| 3         | 40         |
+-----------+------------+

'''

WITH UNION_GROUP AS (
    SELECT A.first_player AS player, A.first_score AS score, B.group_id
    FROM matches A INNER JOIN players B
    ON A.first_player = B.player_id
    UNION ALL
    SELECT A.second_player AS player, A.second_score AS score, B.group_id
    FROM matches A INNER JOIN players B
    ON A.second_player = B.player_id
),
AGG_DATA AS (
    SELECT player, group_id, SUM(score) AS score 
    FROM UNION_GROUP 
    grouP BY player, group_id
),
ASSIGN_RANK AS (
    SELECT player, group_id, score, DENSE_RANK() OVER(PARTITION BY group_id ORDER BY score DESC, player ASC) as rn
    FROM AGG_DATA
)
SELECT group_id, player FROM ASSIGN_RANK WHERE rn = 1 