'''
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on 
someday using some device.

Write an SQL query to report the fraction of players that logged in again on the day after the day they first logged in,
rounded to 2 decimal places. In other words, you need to count the number of players that logged in 
for at least two consecutive days starting from their first login date, then divide that number by the total number of players.
'''

WITH MIN_NEXT_MIN AS (
    SELECT player_id, event_date, 
    ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date) as rn 
    FROM Activity
),
FILTER_ROWS AS (
    SELECT * FROM MIN_NEXT_MIN WHERE rn <=2 
),
ADD_NEXT_DATE AS (
    SELECT player_id, event_date,
    LEAD(event_date) OVER(PARTITION BY player_id ORDER BY event_date) AS next_date 
    FROM FILTER_ROWS
),
FIND_MIN_MAX AS (
SELECT player_id, MIN(event_date) AS event_date, MAX(next_date) AS next_date
FROM ADD_NEXT_DATE
GROUP BY player_id
)
SELECT 
ROUND(SUM(CASE WHEN DATEADD(day, 1,event_date) = next_date THEN 1 ELSE 0 END)/(COUNT(*)*1.0), 2) AS fraction
FROM FIND_MIN_MAX