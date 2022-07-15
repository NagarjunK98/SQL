'''
Query Statement -> Write an SQL query to report the IDs of all the employees with missing information. 
The information of an employee is missing if:
    1. The employee\'s name is missing, or
    2. The employee\'s salary is missing.
Return the result table ordered by employee_id in ascending orde
'''

# Solution - 1 -> Using CTE & Join operation

WITH CTE_1 AS (
    SELECT A.employee_id, A.name, B.salary 
    FROM Employees A LEFT JOIN Salaries B
    ON A.employee_id=B.employee_id
),
CTE_2 AS (
    SELECT B.employee_id, A.name, B.salary 
    FROM Employees A RIGHT JOIN Salaries B
    ON A.employee_id=B.employee_id
),
CTE_3 AS (
    SELECT * FROM CTE_1
    UNION
    SELECT * FROM CTE_2
)
SELECT DISTINCT employee_id  FROM CTE_3 WHERE name is null OR salary IS NULL ORDER BY employee_id 