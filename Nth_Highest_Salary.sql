'''
Query Statement -> Write an SQL query to report the nth highest salary from the Employee table. 
If there is no nth highest salary, the query should report null
'''

# Solution -1 -> Using CTE & WINDOW function

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      WITH CTE AS (
        SELECT *, DENSE_RANK() OVER(ORDER BY salary DESC) AS rk FROM Employee
      )
      SELECT IF(N > (SELECT COUNT(DISTINCT salary) FROM Employee), NULL, salary) FROM CTE WHERE rk=N LIMIT 1
      
  );
END