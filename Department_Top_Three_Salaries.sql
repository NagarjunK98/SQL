'''
Query Statement -> Write an SQL query to find the employees who are high earners in each of the departments.
Return the result table in any order
'''

# Solution - 1 -> Using CTE & WINDOW function

WITH CTE_1 AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY departmentId ORDER BY salary DESC) AS "rk" FROM Employee
)
SELECT t2.name AS Department, t1.name AS Employee, t1.salary AS Salary FROM CTE_1 t1 INNER JOIN Department t2 ON
t1.departmentId =t2.id WHERE rk<=3 