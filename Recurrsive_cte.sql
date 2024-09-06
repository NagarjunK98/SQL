'''
Write a SQL query to print number from 1 to 10 
'''

WITH recursive_cte AS (
    SELECT 1 AS no
    UNION ALL
    SELECT no+1 AS no FROM recursive_cte WHERE no < 10
)
SELECT no FROM recursive_cte

#####################################################################################
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

-- Solution - 1
'''Assuming input is given in a table with values(1,2,3)'''
WITH recursive_cte AS (
    SELECT no, 1 AS count FROM table
    UNION ALL
    SELECT no, count+1 AS count FROM recursive_cte WHERE count < no 
)
SELECT no FROM recursive_cte ORDER BY no

-- Solution - 2
''' We need to generate number between min & max and print n number of times'''
WITH generate_no as (
  SELECT 1 AS no, 1 AS c 
  UNION ALL
  SELECT no+1 AS no, no+1 AS c FROM generate_no WHERE no < 3
),
recursive_cte AS (
    SELECT no, 1 AS count FROM generate_no
    UNION ALL
    SELECT no, count+1 AS count FROM recursive_cte WHERE count < no 
)
SELECT no FROM recursive_cte order by no

###############################################################################################

''' 
Write an SQL query to print number by number of times itself without using recursive cte. Assume number table is given as input
and numbers are consecutive
Input table: (1,2,3,4,5)
'''

--  Solution-1:  Using CROSS JOIN or SELF JOIN. This approach only works when number are consecutive (example: 1 2 3 4 5).
-- It won't work for non consecutive numbers (1,2,7,9) because we are doing cross join so number of rows (total_records * total_records), so it will not give correct result for 7 & 9. 
-- Using recursive CTE we can solve for consecutive and non consecutive numbers

select A.no FROM numbers A, numbers B WHERE A.no >= B.no ORDER BY A.no
-- OR
select A.no FROM numbers A INNER JOIN numbers B ON A.no >= B.no ORDER BY A.no

##################################################################################################

'''
For non consecutive numbers (1,2,5)
'''

-- Solution-1: Using recursive CTE
WITH recursive_cte AS (
    SELECT no, 1 AS count FROM table
    UNION ALL
    SELECT no, count+1 AS count FROM recursive_cte WHERE count < no 
)
SELECT no FROM recursive_cte ORDER BY no


-- Solution-2: Using hybrid approach (First generate numbers from 1 to max(number) using recursive cte and apply self join)
WITH numbers AS (
    SELECT 1 AS no
    UNION ALL
  	SELECT 2 AS no
    UNION ALL
    SELECT 5 AS no
),
generate_no as (
	SELECT MAX(no) AS no FROM numbers
  	UNION ALL
  	SELECT no-1 AS no FROM generate_no WHERE no-1>0
)
select A.no FROM numbers A INNER JOIN generate_no B ON A.no >= B.no ORDER BY A.no

