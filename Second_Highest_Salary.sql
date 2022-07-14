# Solution - 1 -> Using MAX aggregate function

SELECT MAX(salary) AS SecondHighestSalary FROM Employee WHERE salary <(SELECT MAX(salary) FROM Employee);

# Solution - 2 -> Using CTE & RANK function

WITH CTE_1 AS (
    SELECT salary,
    DENSE_RANK() OVER(ORDER BY salary DESC) AS RK  FROM Employee
)
SELECT MAX(salary) AS SecondHighestSalary FROM CTE_1 WHERE RK=2;
