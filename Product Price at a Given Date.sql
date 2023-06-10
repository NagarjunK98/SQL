'''
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.

Write an SQL query to find the prices of all products on 2019-08-16. 
Assume the price of all products before any change is 10.
'''
WITH DISTINCT_DATA AS (
SELECT DISTINCT product_id FROM Products 
),
MAX_DATE AS (
SELECT product_id, MAX(change_date) AS change_date
FROM Products
WHERE change_date <= '2019-08-16'
GROUP BY product_id
),
GET_PRICE AS (
  SELECT A.*, B.new_price FROM MAX_DATE A INNER JOIN Products B 
  ON A.product_id = B.product_id AND A.change_date = B.change_date
)
SELECT A.product_id, COALESCE(B.new_price, 10) as price 
FROM DISTINCT_DATA A LEFT JOIN GET_PRICE B
ON A.product_id = B.product_id