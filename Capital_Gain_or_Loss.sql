'''
Query Statement -> Write an SQL query to report the Capital gain/loss for each stock.
The Capital gain/loss of a stock is the total gain or loss after buying and selling the stock one or many times
'''

# Solution - 1 -> Using CTE, Window & Join 

WITH CTE_1 AS (
SELECT stock_name, operation, SUM(price) as total FROM Stocks GROUP BY stock_name, operation
),
CTE_2 AS (
    SELECT *,
    RANK() OVER (PARTITION BY stock_name order by operation) as rk
    FROM CTE_1
),
CTE_3 AS (
    SELECT * FROM CTE_2 WHERE rk=1
),
CTE_4 AS (
    SELECT * FROM CTE_2 WHERE rk=2
)
SELECT A.stock_name, A.total-B.total as capital_gain_loss  FROM CTE_3 A INNER JOIN CTE_4 B ON A.stock_name=B.stock_name