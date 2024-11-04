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


# Pyspark solution

from pyspark.sql import Window
from pyspark.sql.functions import col, sum, rank

grp_df = df.groupBy("stock_name", "operation").agg(sum(col("price")).alias("total"))

window_spec = Window.partitionBy("stock_name").orderBy("operation")

rank_df = grp_df.withColumn("rank", rank().over(window_spec))

rank_df_1 = rank_df.filter(col("rank") == 1)

rank_df_2 = rank_df.filter(col("rank") == 2)

joined_df = rank_df_1.alias("A").join(rank_df_2.alias("B"), A.stock_name == B.stock_name, "inner") \
                .select("stock_name", (col("A.total") -col("B.total")).alias("capital_gain_loss"))