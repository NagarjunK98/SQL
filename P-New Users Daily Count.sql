'''
Traffic: user_id, activity, activity_date

Write a query that reports for every date within at most 90 days from today the number of users 
logged in for the first time on that date. Assume today is 2019-06-30
activity can be login, logout, homepage, jobs, groups, etc
'''

WITH GET_MIN_LOG_DATE AS (
    SELECT user_id, MIN(activity_date) AS min_date 
    FROM Traffic 
    WHERE activity = 'login'
    GROUP BY user_id
)

SELECT min_date, COUNT(*) AS unique_count 
FROM GET_MIN_LOG_DATE 
WHERE DATEDIFF('2019-06-30', min_date) < 90
GROUP BY min_date