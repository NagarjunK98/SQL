'''

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |
+--------------+---------+
id is the primary key column for this table.
departmentId is a foreign key of the ID from the Department table.
Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the ID of a department and its name.

A company\'s executives are interested in seeing who earns the most money in each of the company\'s departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department.

Write an SQL query to find the employees who are high earners in each of the departments.
'''

WITH ASSIGN_RANK AS (
SELECT A.salary AS Salary, A.departmentId, B.name AS Department, A.name AS Employee,
DENSE_RANK() OVER(PARTITION BY A.departmentId ORDER BY A.salary DESC) as rk
FROM Employee A INNER JOIN Department B
ON A.departmentId = B.id
)
SELECT Department, employee, Salary FROM ASSIGN_RANK WHERE rk <=3