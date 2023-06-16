'''
Table-1: sender_id, send_to_id, request_date

Table-2: requester_id, accepter_id, accept_date

Write a query to find overall acceptance rate of requests rounded to 2 decimal
'''

WITH REQ_COUNT AS (
    SELECT 1 AS key, COUNT(DISTINCT sender_id, send_to_id)  AS req_count
    FROM Table-1
),
ACC_COUNT (
    SELECT 1 AS key, COUNT(DISTINCT  requester_id, accepter_id) AS acc_count
    FROM Table-2
)
SELECT ROUND((1.0*A.acc_count/B.req_count), 2) AS accept_rate 
FROM ACC_COUNT A INNER JOIN REQ_COUNT B 
ON A.key = B.key