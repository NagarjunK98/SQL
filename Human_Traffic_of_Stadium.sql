'''
Query Statement -> Write an SQL query to display the records with three or more rows with consecutive ids, 
and the number of people is greater than or equal to 100 for each.
Return the result table ordered by visit_date in ascending order
'''

# Solution - 1 -> Using CTE & Window fucntion

WITH CTE_1 AS (
SELECT *, 
    id - ROW_NUMBER() OVER(ORDER BY id) as diff
    FROM Stadium WHERE people >=100
),
CTE_2 AS (
    SELECT diff, COUNT(*) from CTE_1 GROUP BY diff HAVING COUNT(*)>=3
)
SELECT id, visit_date, people from CTE_1 WHERE diff IN (SELECT diff FROM CTE_2)