'''
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| customer_name | varchar |
+---------------+---------+
customer_id is the primary key for this table.
Each row of this table contains the name and the id customer.

Write an SQL query to find the missing customer IDs. The missing IDs are ones that are not in the Customers table 
but are in the range between 1 and the maximum customer_id present in the table. Return the result table ordered by ids in 
ascending order.

Notice that the maximum customer_id will not exceed 100.

Customers table:
+-------------+---------------+
| customer_id | customer_name |
+-------------+---------------+
| 1           | Alice         |
| 4           | Bob           |
| 5           | Charlie       |
+-------------+---------------+
Output: 
+-----+
| ids |
+-----+
| 2   |
| 3   |
+-----+
Explanation: 
The maximum customer_id present in the table is 5, so in the range [1,5], IDs 2 and 3 are missing from the table.
'''
WITH MAX_MIN AS (
    SELECT MAX(customer_id) AS max_id FROM customers
),
recursive_cte AS (
    SELECT 1 as customer_id FROM MAX_MIN
    UNION ALL
    SELECT customer_id + 1 as customer_id FROM recurssive_cte WHERE customer_id < (SELECT max_id FROM MAX_MIN)
)
SELECT customer_id AS ids FROM recursive_cte WHERE customer_id NOT IN (SELECT customer_id FROM customers)
ORDER BY customer_id