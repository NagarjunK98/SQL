'''
Table: seat_id, free

Write a query to display all consecutive available seats order by seat_id 
'''

-- To display all consecutive seats min & max values
WITH CTE AS (
SELECT seat_id, free, ROW_NUMBER() OVER(ORDER BY seat_id) as rn
from cinema
WHERE free = 1
),
find_diff as (
SELECT seat_id, seat_id - rn as diff 
FROM CTE
)
SELECT MIN(seat_id), MAX(seat_id) from find_diff GROUP BY diff HAVING MIN(seat_id)<>MAX(seat_id)


-- To display all consecutive seats
WITH CTE AS (
  SELECT seat_id, free, seat_id - ROW_NUMBER() OVER(ORDER BY seat_id) as diff
  from cinema
  WHERE free = 1
),
find_count AS (
  SELECT diff from CTE GROUP BY diff HAVING COUNT(*) > 1 
 )
SELECT A.seat_id FROM CTE A INNER JOIN find_count B ON A.diff = B.diff
ORDER BY A.seat_id