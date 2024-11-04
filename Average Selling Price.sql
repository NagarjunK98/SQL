'''
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| start_date    | date    |
| end_date      | date    |
| price         | int     |
+---------------+---------+
(product_id, start_date, end_date) is the primary key for this table.
Each row of this table indicates the price of the product_id in the period from start_date to end_date.
For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods 
for the same product_id.

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| purchase_date | date    |
| units         | int     |
+---------------+---------+
There is no primary key for this table, it may contain duplicates.
Each row of this table indicates the date, units, and product_id of each product sold.

Write an SQL query to find the average selling price for each product. average_price should be rounded to 2 decimal places.
'''

WITH JOINED_DATA AS (
SELECT A.product_id, start_date, end_date, price, purchase_date, units 
FROM Prices A INNER JOIN UnitsSold B ON a.product_id = B.product_id AND B.purchase_date BETWEEN A.start_date AND A.end_date 
)
SELECT product_id, ROUND(SUM(units*price)/(sum(units)*1.0),2) AS average_price
FROM JOINED_DATA
GROUP BY product_id


# Pyspark Solution
from pyspark.sql.functions import round, sum, col

joined_df = prices.join(units_sold, (prices.product_id == units_sold.product_id ) \
                                    & (units_sold.purchase_date between prices.start_date and prices.end_date)
                        )
res_df = joined_df.groupBy("product_id").agg(round(sum(col("units")*col("price"))/sum(col("units")), 2).alias("average_price"))
res_df.show()