'''
Write a SQL query to print number from 1 to 10 
'''

WITH recurrsive_cte AS (
    SELECT 1 AS no
    UNION ALL
    SELECT no+1 AS no FROM recurrsive_cte WHERE no < 10
)
SELECT no FROM recurrsive_cte


'''
Given Input of numbers
1
2
3
Write a SQL query to print numbers by number of times by number itself

Output:
1
2
2
3
3
3
'''

# Solution - 1
'''Assuming input is given in a table with values(1,2,3)'''
WITH recurrsive_cte AS (
    SELECT no, 1 AS count FROM table
    UNION ALL
    SELECT no, count+1 AS count FROM recurrsive_cte WHERE count < no 
)
SELECT no FROM recurrsive_cte ORDER BY no

# Solution - 2
''' We need to generate number between min & max and print n number of times'''
WITH generate_no as (
  SELECT 1 AS no, 1 AS c 
  UNION ALL
  SELECT no+1 AS no, no+1 AS c FROM generate_no WHERE no < 3
),
recurrsive_cte AS (
    SELECT no, 1 AS count FROM generate_no
    UNION ALL
    SELECT no, count+1 AS count FROM recurrsive_cte WHERE count < no 
)
SELECT no FROM recurrsive_cte order by no