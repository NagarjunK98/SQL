'''
Query Statement -> Write an SQL query to find all dates Ids with higher temperatures compared to its previous dates (yesterday)
'''

# Solution - 1 -> Using CTE & Join 

WITH CTE_1 AS (
    SELECT id, recordDate, temperature,
            DATE_SUB(recordDate, INTERVAL 1 DAY) AS previous_date
    FROM Weather
),
CTE_2 AS (
    SELECT A.*,B.temperature AS previous_day_temperture FROM CTE_1 A LEFT JOIN Weather B ON A.previous_date=B.recordDate
)
SELECT id FROM CTE_2 WHERE temperature > previous_day_temperture AND previous_day_temperture IS NOT NULL