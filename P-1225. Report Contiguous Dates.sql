'''
Failed:
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| fail_date    | date    |
+--------------+---------+
fail_date is the primary key for this table.This table contains the days of failed tasks.

Succeeded
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| success_date | date    |
+--------------+---------+
success_date is the primary key for this table.This table contains the days of succeeded tasks.

A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.

Write an SQL query to generate a report of period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.

period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.

Return the result table ordered by start_date.

Input: 
Failed table:
+-------------------+
| fail_date         |
+-------------------+
| 2018-12-28        |
| 2018-12-29        |
| 2019-01-04        |
| 2019-01-05        |
+-------------------+

Succeeded table:
+-------------------+
| success_date      |
+-------------------+
| 2018-12-30        |
| 2018-12-31        |
| 2019-01-01        |
| 2019-01-02        | 
| 2019-01-03        | 
| 2019-01-06        | 
+-------------------+

Output: 
+--------------+--------------+--------------+
| period_state | start_date   | end_date     |
+--------------+--------------+--------------+
| succeeded    | 2019-01-01   | 2019-01-03   |
| failed       | 2019-01-04   | 2019-01-05   |
| succeeded    | 2019-01-06   | 2019-01-06   |
+--------------+--------------+--------------+

Explanation: The report ignored the system state in 2018 as we care about the system in the period 2019-01-01 to 2019-12-31.
From 2019-01-01 to 2019-01-03 all tasks succeeded and the system state was "succeeded".From 2019-01-04 to 2019-01-05 all 
tasks failed and the system state was "failed".From 2019-01-06 to 2019-01-06 all tasks succeeded 
and the system state was "succeeded".
'''

WITH FAILED_DATA AS (
  SELECT period_state, MIN(fail_date) start_date, MAX(fail_date) AS end_date FROM ( 
        SELECT 'failed' AS period_state, fail_date, ROW_NUMBER() OVER(ORDER BY fail_date) As rn,
        DATEPART(dy, fail_date) AS day_no
        FROM failed
        WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'
        ) AS A 
  GROUP BY period_state, (rn - day_no)
), 
SUCCESS_DATA AS (
    SELECT period_state, MIN(success_date) start_date, MAX(success_date) AS end_date FROM ( 
        SELECT 'succeeded' AS period_state, success_date, ROW_NUMBER() OVER(ORDER BY success_date) As rn,
        DATEPART(dy, success_date) AS day_no
        FROM succeeded
        WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31'
        ) AS A 
  GROUP BY period_state, (rn - day_no)
)
SELECT * FROM (
    SELECT * FROM SUCCESS_DATA
    UNION ALL
    SELECT * FROM FAILED_DATA
) AS A 
ORDER BY start_date

Note: This solution works to find all consecutive SQL queries
