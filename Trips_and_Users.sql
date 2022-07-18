'''
Query Statement -> Write a SQL query to find the cancellation rate of requests with 
unbanned users (both client and driver must not be banned) each day between 
"2013-10-01" and "2013-10-03". Round Cancellation Rate to two decimal points.

The cancellation rate is computed by dividing the number of canceled 
(by client or driver) requests with unbanned users by the total number
 of requests with unbanned users on that day
'''

# Solution - 1 -> Using CTE & Joins

WITH CTE_1 AS (
    SELECT A.id, A.request_at, A.client_id, A.status 
    FROM Trips A INNER JOIN Users B
    ON A.client_id=B.users_id WHERE banned='No' AND request_at BETWEEN '2013-10-01' AND '2013-10-03'
),
CTE_2 AS (
    SELECT A.id, A.request_at, A.driver_id, A.status 
    FROM Trips A INNER JOIN Users B
    ON A.driver_id =B.users_id WHERE banned='No' AND request_at BETWEEN '2013-10-01' AND '2013-10-03'
),
CTE_3 AS (
    SELECT A.id, A.request_at, A.client_id, B.driver_id, A.status 
    FROM CTE_1 A INNER JOIN CTE_2 B
    ON A.id=B.id
),
CTE_4 AS (
    SELECT request_at, COUNT(*) AS total FROM CTE_3 GROUP BY request_at
),
CTE_5 AS (
    SELECT request_at, COUNT(*) AS cancelled_total FROM CTE_3
    WHERE status IN ("cancelled_by_driver", "cancelled_by_client")
    GROUP BY request_at 
)
SELECT A.request_at AS Day, 
CASE
    WHEN ROUND(1.0*(B.cancelled_total/A.total),2) IS NULL THEN 0.00
    ELSE ROUND(1.0*(B.cancelled_total/A.total),2)
    END AS "Cancellation Rate" FROM CTE_4 A LEFT JOIN CTE_5 B
    ON A.request_at=B.request_at