'''
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
There is no primary key for this table. It may contain duplicates. customer_id is not NULL.
product_key is a foreign key to Product table.

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
product_key is the primary key column for this table.

Write an SQL query to report the customer ids from the Customer table that bought all the products in the Product table.

'''

WITH AGG_DATA AS (
SELECT customer_id, COUNT(DISTINCT product_key) as CNS FROM Customer 
GROUP BY customer_id
)
SELECT customer_id FROM AGG_DATA
WHERE CNS = (SELECT COUNT(*) FROM Product)

# Pyspark solution

agg_data = (
    customer_df
    .groupBy("customer_id")
    .agg(F.countDistinct("product_key").alias("CNS"))
)

total_products_count = product_df.select(F.count("*").alias("total_count")).collect()[0]["total_count"]

result = agg_data.filter(F.col("CNS") == total_products_count).select("customer_id")
