'''
Query Statement -> Write an SQL query to report all the classes that have at least five students
'''

# Solution - 1 -> Using Aggregate function

SELECT CLASS FROM COURSES GROUP BY CLASS HAVING COUNT(*) >=5

# Pyspark solution

res_df = df.groupBy("class").agg(count("*").alias("count")).filter(col("count") >= 5).select("class")