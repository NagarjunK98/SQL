'''
+-----------------------------+---------+
 | Column Name | Type |
 +-----------------------------+---------+
 | delivery_id | int |
 | customer_id | int |
 | order_date | date |
 | customer_pref_delivery_date | date |
 +-----------------------------+---------+
 delivery_id is the primary key of this table.
 Each row contains information about food delivery to a customer that makes an order at some date and specifies a preferred delivery date (on the order date or after it).
 
If the customers preferred delivery date is the same as the order date, then the order is called immediate, otherwise, it is scheduled.

Write an SQL query to find the percentage of immediate orders on each unique order_date, rounded to 2 decimal places. 

Return the result table ordered by order_date in ascending order.

Input: 
 Delivery table:
 +-------------+-------------+------------+-----------------------------+
 | delivery_id | customer_id | order_date | customer_pref_delivery_date |
 +-------------+-------------+------------+-----------------------------+
 | 1 | 1 | 2019-08-01 | 2019-08-02 |
 | 2 | 2 | 2019-08-01 | 2019-08-01 |
 | 3 | 1 | 2019-08-01 | 2019-08-01 |
 | 4 | 3 | 2019-08-02 | 2019-08-13 |
 | 5 | 3 | 2019-08-02 | 2019-08-02 |
 | 6 | 2 | 2019-08-02 | 2019-08-02 |
 | 7 | 4 | 2019-08-03 | 2019-08-03 |
 | 8 | 1 | 2019-08-03 | 2019-08-03 |
 | 9 | 5 | 2019-08-04 | 2019-08-08 |
 | 10 | 2 | 2019-08-04 | 2019-08-18 |
 +-------------+-------------+------------+-----------------------------+
 
Output: 
 +------------+----------------------+
 | order_date | immediate_percentage |
 +------------+----------------------+
 | 2019-08-01 | 66.67 |
 | 2019-08-02 | 66.67 |
 | 2019-08-03 | 100.00 |
 | 2019-08-04 | 0.00 |
 +------------+----------------------+
 
Explanation: 
 - On 2019-08-01 there were three orders, out of those, two were immediate and one was scheduled. So, immediate percentage for that date was 66.67.
 - On 2019-08-02 there were three orders, out of those, two were immediate and one was scheduled. So, immediate percentage for that date was 66.67.
 - On 2019-08-03 there were two orders, both were immediate. So, the immediate percentage for that date was 100.00.
 - On 2019-08-04 there were two orders, both were scheduled. So, the immediate percentage for that date was 0.00.
 order_date is sorted in ascending order
'''

WITH ADD_FLAG AS (
SELECT order_date, CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END AS flag
from delivery
)
SELECT order_date, ROUND(100.0*SUM(flag)/COUNT(*), 2) FROM ADD_FLAG 
GROUP BY order_date ORDER BY order_date