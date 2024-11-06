'''
Query Statement -> Write an SQL query to find the customer_number for the customer who has placed the largest number of orders
'''

# Solution - 1 -> Using CTE & Aggregate functions

WITH CTE_1 AS (
    SELECT customer_number, COUNT(*)  AS C FROM Orders GROUP BY customer_number ORDER BY C DESC
)
SELECT customer_number FROM CTE_1 LIMIT 1


# Pyspark Solution

from pyspark.sql.functions import count 

agg_df = df.groupBy(col("customer_number")).agg(count("*").alias("count")).orderBy(col("count"), desc())
agg_df.limit(1).show()