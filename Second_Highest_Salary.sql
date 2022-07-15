'''
Query Statement ->  Write an SQL query to report the second highest salary from the Employee table. 
If there is no second highest salary, the query should report null
'''

# Solution - 1 -> Using Aggregate function

SELECT MAX(salary) AS SecondHighestSalary FROM Employee WHERE salary <(SELECT MAX(salary) FROM Employee);

# Solution - 2 -> Using CTE & WINDOW function

WITH CTE_1 AS (
    SELECT salary,
    DENSE_RANK() OVER(ORDER BY salary DESC) AS RK  FROM Employee
)
SELECT MAX(salary) AS SecondHighestSalary FROM CTE_1 WHERE RK=2;
