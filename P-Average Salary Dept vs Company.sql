'''
Salary Table: id, emp_id, amount, pay_date, amount

Emp table: emp_id, dept_id

Write a query to display comparison result (higher/lower/same) of average salary of employees in a department 
to the company average salary at month level 
'''

WITH JOINED_DATA AS (
SELECT A.amount, A.pay_date, B.dept_id, substring(CONVERT(varchar, A.pay_date), 0, 8) as date_part
FROM Salary A INNER JOIN Emp B ON A.emp_id = B.emp_id 
),
COMPANY_AVG_SAL AS (
SELECT date_part, AVG(amount*1.0) AS com_avg FROM JOINED_DATA GROUP BY date_part
),
DEPT_AVG_SAL AS (
SELECT dept_id, date_part, AVG(amount*1.0) as dept_avg FROM JOINED_DATA GROUP BY dept_id, date_part
)
SELECT A.date_part, A.dept_id,
CASE 
	WHEN A.dept_avg > B.com_avg THEN 'higher'
	WHEN  A.dept_avg < B.com_avg THEN 'lower'
    ELSE 'same'
END AS comparison
FROM DEPT_AVG_SAL A LEFT JOIN COMPANY_AVG_SAL B
ON A.date_part = B.date_part