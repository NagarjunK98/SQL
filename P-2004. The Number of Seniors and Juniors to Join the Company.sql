'''
+-------------+------+
| Column Name | Type |
+-------------+------+
| employee_id | int  |
| experience  | enum |
| salary      | int  |
+-------------+------+
employee_id is the primary key column for this table.experience is an enum with one of the values (Senior, Junior).
Each row of this table indicates the id of a candidate, their monthly salary, and their experience.

A company wants to hire new employees. The budget of the company for the salaries is $70000. 
The companys criteria for hiring are:
1. Hiring the largest number of seniors.
2. After hiring the maximum number of seniors, use the remaining budget to hire the largest number of juniors.

Write an SQL query to find the number of seniors and juniors hired under the mentioned criteria.

Input: 
Candidates table:
+-------------+------------+--------+
| employee_id | experience | salary |
+-------------+------------+--------+
| 1           | Junior     | 10000  |
| 9           | Junior     | 10000  |
| 2           | Senior     | 20000  |
| 11          | Senior     | 20000  |
| 13          | Senior     | 50000  |
| 4           | Junior     | 40000  |
+-------------+------------+--------+

Output: 
+------------+---------------------+
| experience | accepted_candidates |
+------------+---------------------+
| Senior     | 2                   |
| Junior     | 2                   |
+------------+---------------------+
Explanation: We can hire 2 seniors with IDs (2, 11). Since the budget is $70000 and the sum of their salaries is $40000, 
we still have $30000 but they are not enough to hire the senior candidate with ID 13.We can hire 2 juniors with IDs (1, 9). 
Since the remaining budget is $30000 and the sum of their salaries is $20000, we still have $10000 but they are not enough 
to hire the junior candidate with ID 4.

Input: 
Candidates table:
+-------------+------------+--------+
| employee_id | experience | salary |
+-------------+------------+--------+
| 1           | Junior     | 10000  |
| 9           | Junior     | 10000  |
| 2           | Senior     | 80000  |
| 11          | Senior     | 80000  |
| 13          | Senior     | 80000  |
| 4           | Junior     | 40000  |
+-------------+------------+--------+

Output: 
+------------+---------------------+
| experience | accepted_candidates |
+------------+---------------------+
| Senior     | 0                   |
| Junior     | 3                   |
+------------+---------------------+

Explanation: We cannot hire any seniors with the current budget as we need at least $80000 to hire one senior.
We can hire all three juniors with the remaining budget.
'''

WITH RUNNING_SALARY as (
    SELECT *, SUM(salary) OVER(PARTITION BY experience ORDER BY salary, employee_id) AS running_sum
    FROM candidates
),
SENIOR_COUNT AS (
    SELECT 'Senior' AS experience, COUNT(*) as accepted_candidates, 700000-(COALESCE(MAX(running_sum),0)) as remaining_sum
    FROM (
	    SELECT * FROM RUNNING_SALARY WHERE experience = 'Senior' AND running_sum <=70000
    ) A
),
JUNIOR_COUNT AS (
    SELECT 'Junior' AS experience, COUNT(*) AS accepted_candidates FROM (
        SELECT * FROM RUNNING_SALARY WHERE experience = 'Junior' AND running_sum <= (SELECT remaining_sum FROM SENIOR_COUNT)
    ) A 
)
SELECT experience, accepted_candidates FROM SENIOR_COUNT
UNION
SELECT experience, accepted_candidates FROM JUNIOR_COUNT