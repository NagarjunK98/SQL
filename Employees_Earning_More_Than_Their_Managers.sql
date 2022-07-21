'''
Query Statement -> Write an SQL query to find the employees who earn more than their managers
'''

# Solution - 1 -> Using CTE

WITH CTE_1 AS (
    SELECT A.id, A.name, A.salary, B.salary AS manager_salary
    FROM Employee A 
    INNER JOIN Employee B ON A.managerId=B.Id
)
SELECT name AS Employee FROM CTE_1 WHERE salary > manager_salary