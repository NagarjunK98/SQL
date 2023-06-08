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