'''
Query Statement -> Write a SQL query for a report that provides the pairs (actor_id, director_id) 
where the actor has cooperated with the director at least three times
'''

# Solution - 1 -> Using Aggregate function

SELECT ACTOR_ID, DIRECTOR_ID FROM ACTORDIRECTOR GROUP BY ACTOR_ID, DIRECTOR_ID HAVING COUNT(*) >=3

# Pyspark solution

df_grp = df.groupBy("actor_id", "director_id").agg(count("*").alias("count"))
df_res = df.df_grp.filter(col("count") >= 3)
df_res.show()