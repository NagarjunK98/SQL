'''
We have office swipe table which track employee login and logout timings.

1. Find out time employee spent in office on particular day(last logout time - first login time)

2. Find out how productive employee was at office on a particular day(employee might have done many swipes per day)
'''


-- For question-1
SELECT employee_id, CAST(activity_time AS DATE) as date, DATEDIFF("hour", MIN(activity_time), MAX(activity_time)) AS office_hours
FROM swipe
GROUP BY employee_id, CAST(activity_time AS DATE)

-- For question-2
WITH find_time AS (
    SELECT employee_id, CAST(activity_time AS DATE) as date, activity_type, activity_time as login_time, 
    LEAD(activity_time, 1) OVER(PARTITION BY employee_id ORDER BY activity_time) AS logout_time
    FROM swipe
)
SELECT employee_id, date, SUM(DATEDIFF("hour", login_time, logout_time)) AS productive_hours
FROM find_time WHERE activity_type = 'login'
GROUP BY employee_id, date



'''
We have friends and likes table. 
Friends table has (user_id, friend_id)
likes table has (user_id, page_id). Likes table has user who liked page

Write a SQL query to recommend page to a user which are liked by his friends and not liked by user itself
'''
WITH CTE AS (
SELECT A.user_id, A.friend_id, B.page_id FROM friends A INNER JOIN likes B ON A.friend_id = B.user_id 
)
SELECT DISTINCT A.user_id, A.page_id
FROM CTE A LEFT JOIN likes B ON A.user_id = B.user_id AND A.page_id = B.page_id
WHERE B.page_id IS NULL