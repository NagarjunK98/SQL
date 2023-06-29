'''
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| team_id        | int     |
| team_name      | varchar |
+----------------+---------+
team_id is the primary key for this table.
Each row contains information about one team in the league.

+-----------------+---------+
| Column Name     | Type    |
+-----------------+---------+
| home_team_id    | int     |
| away_team_id    | int     |
| home_team_goals | int     |
| away_team_goals | int     |
+-----------------+---------+
(home_team_id, away_team_id) is the primary key for this table.
Each row contains information about one match.
home_team_goals is the number of goals scored by the home team.
away_team_goals is the number of goals scored by the away team.
The winner of the match is the team with the higher number of goals.

Write an SQL query to report the statistics of the league. The statistics should be built using the played matches where 
the winning team gets three points and the losing team gets no points. If a match ends with a draw, both teams get one point.

Each row of the result table should contain:
    team_name - The name of the team in the Teams table.
    matches_played - The number of matches played as either a home or away team.
    points - The total points the team has so far.
    goal_for - The total number of goals scored by the team across all matches.
    goal_against - The total number of goals scored by opponent teams against this team across all matches.
    goal_diff - The result of goal_for - goal_against.

Return the result table in descending order by points. If two or more teams have the same points, order them in descending 
order by goal_diff. If there is still a tie, order them by team_name in lexicographical order.
'''
# Calculate matches_played and goal_for for home team 
WITH HOME_TEAM AS ( 
    SELECT team_id, SUM(matches_played) AS matches_played, SUM(goal_for) as goal_for FROM (
        SELECT home_team_id AS team_id, count(*) as matches_played, SUM(home_team_goals) as goal_for
        FROM matches_1 GROUP BY home_team_id
        UNION ALL
        SELECT away_team_id as team_id, count(*) as matches_played, SUM(away_team_goals) as goal_for
        FROM matches_1 GROUP by away_team_id
    ) A 
    GROUP by team_id
),
# Calculate goal_against for home team 
AWAY_TEAM AS (
    SELECT team_id, SUM(matches_played) AS matches_played, SUM(goal_for) as goal_against FROM (
        SELECT home_team_id AS team_id, count(*) as matches_played, SUM(away_team_goals) as goal_for
        FROM matches_1 GROUP BY home_team_id
        UNION ALL
        SELECT away_team_id as team_id, count(*) as matches_played, SUM(home_team_goals) as goal_for
        FROM matches_1 GROUP by away_team_id
    ) A 
    GROUP by team_id
),
# Calculate points based on condition
POINTS AS (
    SELECT team_id, SUM(points) AS points FROM (
        SELECT home_team_id AS team_id, 
        CASE WHEN home_team_goals > away_team_goals THEN 3
        WHEN home_team_goals <  away_team_goals THEN 0
        ELSE 1 END AS points
        FROM matches_1
        UNION ALL
        SELECT away_team_id AS team_id, 
        CASE WHEN home_team_goals < away_team_goals THEN 3
        WHEN home_team_goals >  away_team_goals THEN 0
        ELSE 1 END AS points
        FROM matches_1
    ) A
    GROUP BY team_id
)
# Final result
SELECT D.team_name, A.matches_played, C.points, A.goal_for, B.goal_against, (A.goal_for - B.goal_against) as goal_diff
FROM HOME_TEAM A LEFT JOIN AWAY_TEAM B ON A.team_id = B.team_id
LEFT JOIN POINTS C ON A.team_id = C.team_id
LEFT JOIN Teams D on A.team_id = D.team_id
ORDER BY C.points DESC,  (A.goal_for - B.goal_against) DESC, D.team_name