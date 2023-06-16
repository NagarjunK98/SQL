'''
Table: player_id, device_id, event_date, games_played

Write a sql query that reports the device that is first logged in for each player
'''

# Solution-1
WITH ASSIGN_ROW_NO AS (
    SELECT player_id, device_id, ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date) as rn
    FROM Activity
)
SELECT player_id, device_id FROM ASSIGN_ROW_NO WHERE rn = 1

# Solution-2
SELECT DISTINCT player_id, device_id FROM Activity
WHERE (player_id, event_date) IN (
    SELECT player_id, MIN(event_date) 
    FROM Activity GROUP BY player_id)