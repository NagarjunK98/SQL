'''
Spending: user_id, spend_date, platform, amount

Write a query to find total number of users and total amount spent using mobile only, 
desktop only, and both mobile and desktop together for each date
'''

WITH DISTINCT_DATE AS (
  SELECT DISTINCT spend_date AS spend_date FROM spending
),
PLATFORMS AS (
  SELECT 'mobile' AS platform
  UNION
  SELECT 'desktop' AS platform
  UNION
  SELECT 'both' AS platform
 ),
 MAP_DATA AS (
   SELECT spend_date, platform 
   FROM DISTINCT_DATE CROSS JOIN PLATFORMS
 ),
 SINGLE_AGG AS (
   SELECT user_id, spend_date, SUM(amount) as total_amount, COUNT(*) AS total_users
   FROM spending
   GROUP BY user_id, spend_date
   HAVING COUNT(*) = 1
 ),
 SINGLE_PLATFORM AS (
   SELECT A.spend_date, B.platform, A.total_amount, A.total_users 
 	FROM SINGLE_AGG A INNER JOIN spending B
 	ON A.user_id = B.user_id AND A.spend_date = B.spend_date
),
BOTH_PLATFORM as (
  SELECT spend_date, 'both' AS platform, total_amount, total_users FROM (
		select user_id, spend_date, SUM(amount) as total_amount, COUNT(distinct user_id) AS total_users
		FROM spending
		GROUP BY user_id, spend_date HAVING COUNT(DISTINCT platform) = 2
    ) A
),
UNION_PLATFORM AS (
  SELECT * FROM SINGLE_PLATFORM
  UNION
  SELECT * FROM BOTH_PLATFORM
)
SELECT A.spend_date, A.platform, COALESCE(B.total_amount, 0) as total_amount, COALESCE(B.total_users, 0) AS total_users
FROM MAP_DATA A LEFT JOIN UNION_PLATFORM B
ON A.spend_date = B.spend_date AND A.platform = B.platform