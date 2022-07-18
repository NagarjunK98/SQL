'''
Query Statement -> Write an SQL query to find for each user, the join date and the number of orders they made as a buyer in 2019
'''

# Solution - 1 -> Using CTE & Join 

WITH CTE_1 AS (
    SELECT buyer_id, COUNT(*) as total_orders FROM Orders 
    WHERE YEAR(order_date)=2019
    GROUP BY buyer_id 
)
SELECT A.user_id AS buyer_id, A.join_date, 
    CASE
        WHEN B.total_orders IS NULL THEN 0
        ELSE B.total_orders 
        END AS orders_in_2019 
FROM Users A LEFT JOIN CTE_1 B
ON A.user_id=B.buyer_id