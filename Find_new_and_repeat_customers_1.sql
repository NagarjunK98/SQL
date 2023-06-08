'''
Write a SQL query to list out count of new, and repeated customer orders based on order date.
Here consider order as repeated order, if customer had made at least one order in past days
'''

WITH assign_rank AS (
	SELECT customer_id, order_date, ROW_NUMBER() OVER(PARTITION by customer_id order BY order_date) AS rn
  	FROM customer_orders
)
select order_date, SUM(CASE WHEN rn=1 THEN 1 ELSE 0 END) as new_orders_count,
SUM(CASE WHEN rn>1 THEN 1 ELSE 0 END) AS repeated_orders_count
FROM assign_rank
GROUP BY order_date
order by order_date