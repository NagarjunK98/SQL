'''
+-------------+------+
| Column Name | Type |
+-------------+------+
| employee_id | int  |
| experience  | enum |
| salary      | int  |
+-------------+------+
employee_id is the primary key column for this table.
experience is an enum with one of the values (Senior, Junior).
Each row of this table indicates the id of a candidate, their monthly salary, and their experience.
The salary of each candidate is guaranteed to be unique.

A company wants to hire new employees. The budget of the company for the salaries is $70000. 
The company criteria for hiring are:
1. Keep hiring the senior with the smallest salary until you cannot hire any more seniors.
2. Use the remaining budget to hire the junior with the smallest salary.
3. Keep hiring the junior with the smallest salary until you cannot hire any more juniors

Write an SQL query to find the ids of seniors and juniors hired under the mentioned criteria.

'''

WITH RUNNING_SALARY as (
    SELECT *, SUM(salary) OVER(PARTITION BY experience ORDER BY salary, employee_id) AS running_sum
    FROM candidates
),
SENIOR AS (
    SELECT employee_id, running_sum FROM RUNNING_SALARY WHERE experience = 'Senior' AND running_sum <=70000
),
JUNIOR AS (
    SELECT employee_id, running_sum FROM RUNNING_SALARY WHERE experience = 'Junior' AND running_sum <= (SELECT 70000-MAX(running_sum) FROM SENIOR)
)

SELECT employee_id FROM SENIOR
UNION 
SELECT employee_id FROM JUNIOR