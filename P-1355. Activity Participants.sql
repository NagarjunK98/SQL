'''
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
| activity      | varchar |
+---------------+---------+
id is the id of the friend and primary key for this table.
name is the name of the friend.
activity is the name of the activity which the friend takes part in.

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key for this table.
name is the name of the activity.

Write an SQL query to find the names of all the activities with neither maximum, nor minimum number of participants.

Friends table:
+------+--------------+---------------+
| id   | name         | activity      |
+------+--------------+---------------+
| 1    | Jonathan D.  | Eating        |
| 2    | Jade W.      | Singing       |
| 3    | Victor J.    | Singing       |
| 4    | Elvis Q.     | Eating        |
| 5    | Daniel A.    | Eating        |
| 6    | Bob B.       | Horse Riding  |
+------+--------------+---------------+

Activities table:
+------+--------------+
| id   | name         |
+------+--------------+
| 1    | Eating       |
| 2    | Singing      |
| 3    | Horse Riding |
+------+--------------+

Result table:
+--------------+
| results      |
+--------------+
| Singing      |
+--------------+

Eating activity is performed by 3 friends, maximum number of participants, (Jonathan D. , Elvis Q. and Daniel A.)
Horse Riding activity is performed by 1 friend, minimum number of participants, (Bob B.)
Singing is performed by 2 friends (Victor J. and Jade W.)
'''

WITH AGG_DATA AS (
    SELECT activity, COUNT(DISTINCT name) AS total_count
    FROM Friends
    GROUP BY activity
),
ASSIGN_RANK AS (
    SELECT *, DENSE_RANK() OVER(ORDER BY total_count) AS rn 
    FROM AGG_DATA
  ),
GET_MIN_MAX AS (
  SELECT activity, rn FROM  ASSIGN_RANK WHERE rn = (SELECT MIN(rn) FROM ASSIGN_RANK)
  UNION
  SELECT activity, rn FROM  ASSIGN_RANK WHERE rn = (SELECT MAX(rn) FROM ASSIGN_RANK)
)
SELECT * FROM Activities WHERE name NOT IN (SELECT activity FROM GET_MIN_MAX)