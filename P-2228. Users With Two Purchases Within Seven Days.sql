'''
+---------------+------+
| Column Name   | Type |
+---------------+------+
| purchase_id   | int  |
| user_id       | int  |
| purchase_date | date |
+---------------+------+
purchase_id is the primary key for this table.
This table contains logs of the dates that users purchased from a certain retailer.

Write an SQL query to report the IDs of the users that made any two purchases at most 7 days apart.

Input: 
Purchases table:
+-------------+---------+---------------+
| purchase_id | user_id | purchase_date |
+-------------+---------+---------------+
| 4           | 2       | 2022-03-13    |
| 1           | 5       | 2022-02-11    |
| 3           | 7       | 2022-06-19    |
| 6           | 2       | 2022-03-20    |
| 5           | 7       | 2022-06-19    |
| 2           | 2       | 2022-06-08    |
+-------------+---------+---------------+
Output: 
+---------+
| user_id |
+---------+
| 2       |
| 7       |
+---------+
Explanation: 
User 2 had two purchases on 2022-03-13 and 2022-03-20. Since the second purchase is within 7 days of the first purchase,
we add their ID.

User 5 had only 1 purchase.
User 7 had two purchases on the same day so we add their ID.
'''

SELECT DISTINCT A.user_id FROM purchases A INNER JOIN purchases B ON A.user_id = B.user_id AND A.purchase_id < B.purchase_id
AND DATEDIFF(day, B.purchase_date, A.purchase_date) <=7