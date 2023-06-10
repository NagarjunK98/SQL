'''
+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
+----------------+----------+
user_id is the primary key for this table.
Each row contains information about the signup time for the user with ID user_id.
+----------------+----------+
| Column Name    | Type     |
+----------------+----------+
| user_id        | int      |
| time_stamp     | datetime |
| action         | ENUM     |
+----------------+----------+
(user_id, time_stamp) is the primary key for this table.
user_id is a foreign key with a reference to the Signups table.
action is an ENUM of the type ('confirmed', 'timeout')
Each row of this table indicates that the user with ID user_id requested a confirmation message at time_stamp 
and that confirmation message was either confirmed ('confirmed') or expired without confirming ('timeout').

The confirmation rate of a user is the number of 'confirmed' messages divided by the total number of requested confirmation messages. The confirmation rate of a user that did not request any confirmation messages is 0. Round the confirmation rate to two decimal places.

Write an SQL query to find the confirmation rate of each user.
'''
WITH CROSS_JOIN AS (
    SELECT A.user_id, B.action, A.time_stamp AS A_T, B.time_stamp AS B_T FROM Signups A  LEFT JOIN Confirmations B
    ON A.user_id = B.user_id
),
JOINED_DATA_1 AS (
SELECT
user_id, 
SUM(CASE WHEN action='confirmed' THEN 1 ELSE 0 END) AS confirmed,
SUM(CASE WHEN action='timeout' THEN 1 ELSE 0 END) AS timeout
FROM CROSS_JOIN
GROUP BY user_id
)
SELECT user_id, 
CASE 
    WHEN confirmed = 0 AND timeout = 0 THEN 0
    ELSE ROUND(confirmed/((confirmed+timeout)*1.0), 2)
END AS confirmation_rate 
FROM JOINED_DATA_1 
ORDER BY user_id

