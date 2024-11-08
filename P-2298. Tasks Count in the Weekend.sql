'''
+-------------+------+
| Column Name | Type |
+-------------+------+
| task_id     | int  |
| assignee_id | int  |
| submit_date | date |
+-------------+------+
task_id is the primary key for this table.
Each row in this table contains the ID of a task, the id of the assignee, and the submission date.

Write an SQL query to report:
the number of the tasks that were submitted during the weekend (Saturday, Sunday) as weekend_cnt, and the number of the 
tasks that were submitted during the working days as working_cnt. Return the result table in any order.

Input: 
Tasks table:
+---------+-------------+-------------+
| task_id | assignee_id | submit_date |
+---------+-------------+-------------+
| 1       | 1           | 2022-06-13  |
| 2       | 6           | 2022-06-14  |
| 3       | 6           | 2022-06-15  |
| 4       | 3           | 2022-06-18  |
| 5       | 5           | 2022-06-19  |
| 6       | 7           | 2022-06-19  |
+---------+-------------+-------------+
Output: 
+-------------+-------------+
| weekend_cnt | working_cnt |
+-------------+-------------+
| 3           | 3           |
+-------------+-------------+
'''

SELECT SUM(CASE WHEN DATENAME(weekday, submit_date) IN ('Sunday', 'Saturday')  THEN 1 ELSE 0 END) AS weekend_cnt,
SUM(CASE WHEN DATENAME(weekday, submit_date) NOT IN ('Sunday', 'Saturday') THEN 1 ELSE 0 END) AS working_cnt
FROM tasks