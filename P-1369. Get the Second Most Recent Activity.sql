'''
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| username      | varchar |
| activity      | varchar |
| startDate     | Date    |
| endDate       | Date    |
+---------------+---------+
This table does not contain primary key.
This table contain information about the activity performed of each user in a period of time.
A person with username performed a activity from startDate to endDate.


Write an SQL query to show the second most recent activity of each user.

A user can’t perform more than one activity at the same time. Return the result table in any order.

UserActivity table:
+------------+--------------+-------------+-------------+
| username   | activity     | startDate   | endDate     |
+------------+--------------+-------------+-------------+
| Alice      | Travel       | 2020-02-12  | 2020-02-20  |
| Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
| Alice      | Travel       | 2020-02-24  | 2020-02-28  |
| Bob        | Travel       | 2020-02-11  | 2020-02-18  |
+------------+--------------+-------------+-------------+

Result table:
+------------+--------------+-------------+-------------+
| username   | activity     | startDate   | endDate     |
+------------+--------------+-------------+-------------+
| Alice      | Dancing      | 2020-02-21  | 2020-02-23  |
| Bob        | Travel       | 2020-02-11  | 2020-02-18  |
+------------+--------------+-------------+-------------+
'''

WITH ASSIGN_RANK AS (
SELECT username, activity, startDate, endDate, 
DENSE_RANK() OVER(PARTITION BY username ORDER BY startDate DESC) AS rk,
COUNT(*) OVER(PARTITION BY username) as rows_count
FROM user_activity
)
SELECT username, activity, startDate, endDate 
FROM ASSIGN_RANK 
WHERE (rk=1 AND rows_count=1) OR (rk=2 AND rows_count>1)