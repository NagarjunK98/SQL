'''
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
| salary      | int     |
+-------------+---------+
employee_id is the primary key for this table.
Each row of this table indicates the employee ID, employee name, and salary

A company wants to divide the employees into teams such that all the members on each team have the same salary. 
The teams should follow these criteria:

Each team should consist of at least two employees.
    1. All the employees on a team should have the same salary.
    2. All the employees of the same salary should be assigned to the same team.
    3. If the salary of an employee is unique, we do not assign this employee to any team.
    4. A team’s ID is assigned based on the rank of the team’s salary relative to the other teams’ salaries, where the team with the lowest salary has team_id = 1. Note that the salaries for employees not on a team are not included in this ranking.

Write an SQL query to get the team_id of each employee that is in a team. Return the result table ordered by team_id in ascending order. 
In case of a tie, order it by employee_id in ascending order
'''

WITH ASSIGN_RANK AS (
SELECT employee_id, name, salary, DENSE_RANK() OVER(order by salary) AS RN  from employees
),
FILTER_DATA AS (
SELECT employee_id, name, salary FROM ASSIGN_RANK WHERE RN IN (
	SELECT RN FROM ASSIGN_RANK GROUP BY RN HAVING COUNT(RN)>=2
  ) 
)
SELECT employee_id, name, salary, DENSE_RANK() OVER(ORDER BY salary) AS team_id
FROM FILTER_DATA ORDER BY employee_id