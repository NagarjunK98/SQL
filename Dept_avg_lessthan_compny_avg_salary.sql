'''
Write a sql query to find department id where avg salary of department is less than company avg salary. 

Note: While calculating company avg salary, exclude its own department salaries. Means every department will have unique 
company avg salary 
'''

'''
1. First find avg, sum, count of each department
2. Do SELF JOIN on dept_id not matching to exclude its own dept and find the avg and compare
'''
WITH DEPT_AVG AS (
    SELECT department_id, avg(salary) as dept_avg_sal, SUM(salary) as total_salary, COUNT(*) as total_count 
    FROM emp_1
    GROUP by department_id
)
SELECT department_id FROM (
    SELECT A.department_id, A.dept_avg_sal, SUM(B.total_salary)/SUM(B.total_count) as company_avg_sal
    FROM DEPT_AVG A INNER JOIN DEPT_AVG B ON A.department_id != B.department_id
    GROUP by A.department_id, A.dept_avg_sal
) A 
WHERE dept_avg_sal < company_avg_sal