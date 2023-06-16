'''
Table: id, month, salary

Write a SQL to get cumulative sum of employee salary over a period of 3 months but exclude the most recent month
'''

WITH GET_MAX_MONTH AS (
  	select id, MAX(month) as month from emp_sal GROUP BY id
  ),
  FILTER_MAX_MONTH AS (
    SELECT A.id, A.month, A.salary 
  	FROM emp_sal A INNER JOIN GET_MAX_MONTH B
  	ON A.id = B.id AND A.month < B.month
  )
  SELECT id, month, SUM(salary) OVER(PARTITION BY id ORDER BY month) as salary
  FROM FILTER_MAX_MONTH
  ORDER BY id, salary DESC