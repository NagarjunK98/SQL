'''
Table Project: project_id, employee_id

Table Employee: employee_id, name, expr

Write a query that reports the most experienced employees in each project. 
In case of tie, report all employees with maximum no of experience years.
'''

WITH ASSIGN_RANK AS (
    SELECT A.project_id, A.employee_id, B.expr,
    DENSE_RANK() OVER(PARTITION BY A.project_id ORDER BY B.expr DESC) AS rn 
    FROM Project A LEFT JOIN Employee ON A.employee_id = B.employee_id
)
SELECT project_id, employee_id FROM ASSIGN_RANK WHERE rn = 1