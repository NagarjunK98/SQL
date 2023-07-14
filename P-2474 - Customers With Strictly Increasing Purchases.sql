'''
+--------------+------+
| Column Name  | Type |
+--------------+------+
| order_id     | int  |
| customer_id  | int  |
| order_date   | date |
| price        | int  |
+--------------+------+
order_id is the primary key for this table.
Each row contains the id of an order, the id of customer that ordered it, the date of the order, and its price.

Write an SQL query to report the IDs of the customers with the total purchases strictly increasing yearly.

The total purchases of a customer in one year is the sum of the prices of their orders in that year. If for some year the customer did not make any order, we consider the total purchases 0.
The first year to consider for each customer is the year of their first order.
The last year to consider for each customer is the year of their last order.

Input: 
Orders table:
+----------+-------------+------------+-------+
| order_id | customer_id | order_date | price |
+----------+-------------+------------+-------+
| 1        | 1           | 2019-07-01 | 1100  |
| 2        | 1           | 2019-11-01 | 1200  |
| 3        | 1           | 2020-05-26 | 3000  |
| 4        | 1           | 2021-08-31 | 3100  |
| 5        | 1           | 2022-12-07 | 4700  |
| 6        | 2           | 2015-01-01 | 700   |
| 7        | 2           | 2017-11-07 | 1000  |
| 8        | 3           | 2017-01-01 | 900   |
| 9        | 3           | 2018-11-07 | 900   |
+----------+-------------+------------+-------+
Output: 
+-------------+
| customer_id |
+-------------+
| 1           |
+-------------+
Explanation: 
Customer 1: The first year is 2019 and the last year is 2022
  - 2019: 1100 + 1200 = 2300
  - 2020: 3000
  - 2021: 3100
  - 2022: 4700
  We can see that the total purchases are strictly increasing yearly, so we include customer 1 in the answer.

Customer 2: The first year is 2015 and the last year is 2017
  - 2015: 700
  - 2016: 0
  - 2017: 1000
  We do not include customer 2 in the answer because the total purchases are not strictly increasing. Note that customer 2 
  did not make any purchases in 2016.

Customer 3: The first year is 2017, and the last year is 2018
  - 2017: 900
  - 2018: 900
  We can see that the total purchases are strictly increasing yearly, so we include customer 1 in the answer.

'''
WITH AGG_DATA AS (
    SELECT customer_id, year(order_date) as year, SUM(price) as total
    FROM orders GROUP BY customer_id, year(order_date)
),
FIND_YEAR_WISE AS (
    SELECT customer_id, year, total, 
    CASE WHEN (year - LEAD(year) OVER(PARTITION BY customer_id ORDER BY year)) = -1 THEN 1
    WHEN  LEAD(year) OVER(PARTITION BY customer_id ORDER BY year) IS NULL THEN 1
    ELSE 0 END AS cons_year,
    CASE WHEN total < LEAD(total) OVER(PARTITION BY customer_id ORDER BY year) THEN 1 
    WHEN LEAD(total) OVER(PARTITION BY customer_id ORDER BY year) IS NULL THEN 1
    ELSE 0 END AS flag
    FROM AGG_DATA
),
FILER_NON_CONS_YEAR AS (
    SELECT customer_id FROM FIND_YEAR_WISE GROUP BY customer_id HAVING COUNT(DISTINCT cons_year)=1
)
SELECT A.customer_id FROM FILER_NON_CONS_YEAR A INNER JOIN FIND_YEAR_WISE B ON A.customer_id = B.customer_id
GROUP BY A.customer_id HAVING COUNT(DISTINCT B.flag) = 1
