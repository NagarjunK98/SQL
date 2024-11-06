'''
From the login_details table, fetch the users who logged in consecutively 3 or more times
'''

# Approach-1 => Using CTEs

WITH check_consecutive_login AS (
	select user_name,
    CASE
  		WHEN user_name = LAG(user_name, 1) OVER(ORDER by login_id) AND 
  			 user_name = LAG(user_name, 2) OVER(ORDER by login_id) THEN user_name
  		ELSE NULL
  	end AS repeated_name
  	from login_details
)

SELECT DISTINCT user_name from check_consecutive_login
WHERE repeated_name IS NOT NULL

# Approach-2 => Using Sub-queries

SELECT DISTINCT user_name
FROM
(SELECT *,
CASE
    WHEN user_name = LAG(user_name, 1) OVER(ORDER by login_id) AND 
            user_name = LAG(user_name, 2) OVER(ORDER by login_id) THEN user_name
    ELSE NULL
end AS repeated_name
FROM login_details) A
WHERE A.repeated_name IS NOT NULL

# PySpark Solution

from pyspark.sql.functions import lag, when, col
from pyspark.sql import Window

window = Window.orderBy("login_id")

login_df = df.withColumn("repeated_name", 
				when(col("user_name") == lag(col("user_name"), 1).over(window) & col("user_name") == lag(col("user_name"), 2).over(window), col("user_name"))
				.otherwise(None)
			)
res_df = login_df.filter(col("repeated_name").isNotNull()).select("user_name").distinct()