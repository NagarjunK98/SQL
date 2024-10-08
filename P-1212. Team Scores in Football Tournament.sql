'''
Teams:
+---------------+----------+
| Column Name   | Type     |
+---------------+----------+
| team_id       | int      |
| team_name     | varchar  |
+---------------+----------+

team_id is the primary key of this table.Each row of this table represents a single football team.

matches:
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| match_id      | int     |
| host_team     | int     |
| guest_team    | int     |
| host_goals    | int     |
| guest_goals   | int     |
+---------------+---------+

match_id is the primary key of this table.Each row is a record of a finished match between two different teams. 
Teams host_team and guest_team are represented by their IDs in the Teams table (team_id), and they scored host_goals 
and guest_goals goals, respectively.

You would like to compute the scores of all teams after all matches. Points are awarded as follows:
1. A team receives - three points if they win a match (i.e., Scored more goals than the opponent team).
2. A team receives - one point if they draw a match (i.e., Scored the same number of goals as the opponent team).
3. A team receives - no points if they lose a match (i.e., Scored fewer goals than the opponent team).

Write an SQL query that selects the team_id, team_name and num_points of each team in the tournament after all described matches.

Return the result table ordered by num_points in decreasing order. In case of a tie, order the records by team_id in increasing order.

Input: Teams table:
+-----------+--------------+
| team_id   | team_name    |
+-----------+--------------+
| 10        | Leetcode FC  |
| 20        | NewYork FC   |
| 30        | Atlanta FC   |
| 40        | Chicago FC   |
| 50        | Toronto FC   |
+-----------+--------------+

Matches table:
+------------+--------------+---------------+-------------+--------------+
| match_id   | host_team    | guest_team    | host_goals  | guest_goals  |
+------------+--------------+---------------+-------------+--------------+
| 1          | 10           | 20            | 3           | 0            |
| 2          | 30           | 10            | 2           | 2            |
| 3          | 10           | 50            | 5           | 1            |
| 4          | 20           | 30            | 1           | 0            |
| 5          | 50           | 30            | 1           | 0            |
+------------+--------------+---------------+-------------+--------------+

Output:
+------------+--------------+---------------+
| team_id    | team_name    | num_points    |
+------------+--------------+---------------+
| 10         | Leetcode FC  | 7             |
| 20         | NewYork FC   | 3             |
| 50         | Toronto FC   | 3             |
| 30         | Atlanta FC   | 1             |
| 40         | Chicago FC   | 0             |
+------------+--------------+---------------+
'''
WITH ASSIGN_POINT AS (
    SELECT host_team, guest_team, 
    CASE WHEN host_goals > guest_goals THEN 3 
        WHEN host_goals = guest_goals THEN 1
        ELSE 0
    END host_points,
    CASE WHEN host_goals < guest_goals THEN 3 
        WHEN host_goals = guest_goals THEN 1
        ELSE 0
    END guest_points
FROM matches
),
SEPERATE_TEAM AS (
  SELECT team_id, SUM(num_points) AS num_points FROM (
      SELECT host_team AS team_id, host_points AS num_points FROM ASSIGN_POINT
      UNION ALL
      SELECT guest_team AS team_id, guest_points AS num_points FROM ASSIGN_POINT
      ) AS A
  GROUP BY team_id
)
SELECT A.team_id, A.team_name, COALESCE(num_points, 0) AS num_points 
FROM teams A LEFT JOIN SEPERATE_TEAM B
ON A.team_id = B.team_id
ORDER BY num_points DESC