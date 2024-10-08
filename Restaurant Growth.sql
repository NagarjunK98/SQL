'''
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
| visited_on    | date    |
| amount        | int     |
+---------------+---------+
(customer_id, visited_on) is the primary key for this table.
This table contains data about customer transactions in a restaurant.
visited_on is the date on which the customer with ID (customer_id) has visited the restaurant.
amount is the total paid by a customer.

You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).

Write an SQL query to compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.

Return result table ordered by visited_on in ascending order.
'''
WITH AGG_DATA AS (
  SELECT visited_on, SUM(amount) as amount FROM Customer GROUP BY visited_on
),
FIND_SUM_AVG AS (
SELECT visited_on, SUM(amount) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as amount,
ROUND(AVG(amount*1.0) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) as average_amount
FROM AGG_DATA 
)
SELECT * FROM FIND_SUM_AVG 
WHERE visited_on > (SELECT DATEADD(day, 5, MIN(visited_on)) FROM Customer) 
ORDER BY visited_on