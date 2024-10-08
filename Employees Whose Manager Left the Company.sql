'''
+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| employee_id | int      |
| name        | varchar  |
| manager_id  | int      |
| salary      | int      |
+-------------+----------+
employee_id is the primary key for this table.
This table contains information about the employees, their salary, and the ID of their manager. 
Some employees do not have a manager (manager_id is null).

Write an SQL query to report the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company. 
When a manager leaves the company, their information is deleted from the Employees table, but the reports still have their manager_id 
set to the manager that left.
'''

SELECT employee_id FROM Employees 
WHERE manager_id NOT IN (
  SELECT A.manager_id
  FROM Employees A INNER JOIN Employees B
  ON A.manager_id = B.employee_id
  WHERE A.manager_id IS NOT NULL
) AND salary < 30000
ORDER BY employee_id