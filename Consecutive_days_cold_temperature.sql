'''
From the weather table, fetch all the records when London had extremely cold temperature for 3 consecutive days or more
'''

WITH find_consecutive_days AS (
SELECT *,
  CASE 
  	WHEN temperature < 0 AND LEAD(temperature,1) OVER(ORDER BY id) < 0 AND LEAD(temperature,2) OVER(ORDER BY id) < 0
  	THEN 'Y'
  	WHEN temperature < 0 AND LAG(temperature,1) OVER(ORDER BY id) < 0 AND LEAD(temperature,1) OVER(ORDER BY id) < 0
  	THEN 'Y'
  	WHEN temperature < 0 AND LAG(temperature,1) OVER(ORDER BY id) < 0 AND LAG(temperature,2) OVER(ORDER BY id) < 0
  	THEN 'Y'
  END AS FLAG
FROM weather
)
SELECT * FROM find_consecutive_days WHERE FLAG='Y'

# PySpark solution

from pyspark.sql import Window

window = Window.orderBy("id")

weather_df = df.withColumn("flag", when(col("temperature") < 0 & lead(temperature, 1).over(window) < 0 & lead(temperature, 2).over(window) < 0, 'Y'),
								   when(col("temperature") < 0 & lag(temperature, 1).over(window) < 0 & lead(temperature, 2).over(window) < 0, 'Y'),
								   when(col("temperature") < 0 & lag(temperature, 1).over(window) < 0 & lag(temperature, 2).over(window) < 0, 'Y')
								   .otherwise("N")
			)
res_df = weather_df.filter(col("flag") == 'Y')