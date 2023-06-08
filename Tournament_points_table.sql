'''
Write a SQL query to populate points table for a cricket, tennis, football, etc
'''

WITH match_level_score AS (
select team_1 as team,
CASE 
	WHEN team_1 = winner THEN 1
	ELSE 0 
END AS win_count,
CASE 
	WHEN winner='draw' THEN 1
	ELSE 0 
END AS draw_count
from icc_world_cup
UNION ALL
select team_2 as team,
CASE 
	WHEN team_2 = winner THEN 1
	ELSE 0 
END AS win_count,
CASE 
	WHEN winner='draw' THEN 1
	ELSE 0 
END AS draw_count
from icc_world_cup
)
SELECT 
	team, COUNT(1) as total_matches, SUM(win_count) as win_count, 
	COUNT(1)-(SUM(win_count)+SUM(draw_count)) as loss_count, 
SUM(draw_count) AS draw_count
FROM match_level_score 
GROUP BY team
ORDER BY win_count DESC