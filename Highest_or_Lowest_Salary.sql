'''
Write a SQL query to display only the details of employees who either 
earn the highest salary or the lowest salary in each department from the employee table
'''

# Approach-1

WITH max_min_sal AS (
    SELECT MIN(salary) as min_sal, MAX(salary) as max_sal, Dept FROM Employee GROUP BY Dept
)

SELECT A.* FROM  Employee A INNER JOIN max_min_sal B ON A.Dept = B.Dept
WHERE A.salary = B.min_sal OR A.salary = B.max_sal