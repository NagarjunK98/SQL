'''
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the name of an employee, their department, and the id of their manager.
If managerId is null, then the employee does not have a manager.
No employee will be the manager of themself.

Write an SQL query to report the managers with at least five direct reports.
'''
WITH GROUP_BY AS (
SELECT managerId, count(*) AS c FROM Employee GROUP BY managerId HAVING COUNT(*) > 4
)
SELECT B.name FROM GROUP_BY A INNER JOIN Employee B ON A.managerId = B.id