'''
Query Statement -> Write an SQL query to report the names of all the salespersons 
who did not have any orders related to the company with the name "RED"
'''

# Solution - 1 -> Using CTE

WITH CTE_1 AS (
    SELECT B.sales_id 
    FROM Company A INNER JOIN Orders B
    ON A.com_id=B.com_id AND A.name="RED"
)
SELECT name FROM SalesPerson WHERE sales_id NOT IN (SELECT sales_id FROM CTE_1)