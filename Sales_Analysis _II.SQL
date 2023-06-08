'''
Write an SQL query that reports the products that were only sold in the first quarter of 2019. 
That is, between 2019-01-01 and 2019-03-31 inclusive
'''

# Solution - 1 -> Took less execution time

WITH CTE_1 AS (
    SELECT product_id,
    CASE
        WHEN MONTH(sale_date) IN (1, 2, 3) THEN 1
        ELSE 0
        END AS Quater,
    CASE
        WHEN YEAR(sale_date)=2019 THEN 1
        ELSE 0
    END AS Year
    FROM Sales
),
CTE_2 AS (
    SELECT  product_id, Quater, Year, COUNT(*) AS sold_count FROM CTE_1 
    GROUP BY product_id, Quater, Year 
),
CTE_3 AS (
    SELECT  product_id FROM CTE_2 GROUP BY product_id HAVING COUNT(*)=1
)
SELECT DISTINCT A.product_id, B.product_name FROM CTE_3 A
INNER JOIN Product B 
ON A.product_id = B.product_id
INNER JOIN CTE_1 C
ON A.product_id = C.product_id AND C.Year = 1 AND C.Quater = 1 

# Solution -2 -> Took more execution time

SELECT DISTINCT A.product_id, B.product_name
from Sales A INNER JOIN Product B
ON A.product_id = B.product_id
AND A.product_id IN 
(SELECT product_id FROM Sales 
GROUP BY product_id HAVING MIN(sale_date) >= '2019-01-01' AND MAX(sale_date) <= '2019-03-31')