'''
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| requester_id   | int     |
| accepter_id    | int     |
| accept_date    | date    |
+----------------+---------+
(requester_id, accepter_id) is the primary key for this table.
This table contains the ID of the user who sent the request, 
the ID of the user who received the request, and the date when the request was accepted.

Write an SQL query to find the people who have the most friends and the most friends number.

The test cases are generated so that only one person has the most friends.
'''

WITH REQ_AGG AS (
  SELECT requester_id AS id, COUNT(*) AS C FROM RequestAccepted GROUP BY requester_id
),
ACC_AGG AS (
  SELECT accepter_id AS id, COUNT(*) AS C FROM RequestAccepted GROUP BY accepter_id
),
UNION_DATA AS (
  SELECT id, C FROM REQ_AGG
  UNION ALL
  SELECT id, C FROM ACC_AGG
),
FINAL_AGG AS(
SELECT id, SUM(C) AS num 
FROM UNION_DATA GROUP BY id
)
SELECT id, num FROM(
  SELECT id, num, RANK() OVER(ORDER BY num DESC) AS RK
  FROM FINAL_AGG
  ) A
 WHERE A.RK = 1