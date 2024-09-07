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


'''
You have game of thrones tables. kings & battle
battle (battle_id, battle_name, attacker_king, defender_king, attacker_outcome, region)
kings(k_no, king_name, house)

Find out in each region, which house has won maximum no of battles
'''

-- Solution-1
WITH WINNERS AS (
    SELECT region, CASE WHEN attacker_outcome =  1 THEN attacker_king ELSE defender_king END AS winner_id 
    from battle 
),
GROUP_BY AS (
    SELECT A.region, B.house, COUNT(B.k_no) AS total 
    FROM WINNERS A LEFT JOIN king B On A.winner_id = B.k_no
    GROUP BY region, house
)
SELECT region, house, total FROM (
	SELECT region, house, total, RANK() OVER(PARTITION BY region ORDER BY total DESC) as rank
    FROM GROUP_BY
) A 
WHERE rank = 1

--Solution-2: Using case stmt in join clause
WITH WINNERS AS (
    SELECT A.region, B.house, COUNT(B.k_no) AS total
    FROM battle A LEFT JOIN king B 
    ON B.k_no = CASE WHEN attacker_outcome =  1 THEN attacker_king ELSE defender_king END
    GROUP BY A.region, B.house
)
SELECT region, house, total FROM (
	SELECT region, house, total, RANK() OVER(PARTITION BY region ORDER BY total DESC) as rank
    FROM WINNERS
) A 
WHERE rank = 1



'''
We have employee table (employee_id, employee_name, email_id). 
Find out all lower case email ids which are duplicate in the table
'''
WITH CTE AS (
    SELECT employee_id, email_id, LOWER(email_id) as lower_email,
    CASE WHEN ASCII(SUBSTRING(email_id, 0, 2)) BETWEEN 65 AND 91 THEN 0  ELSE 1 END as is_lower
    FROM employees
),
FILTER_EMAIL AS (
  SELECT lower_email FROM CTE GROUP BY lower_email HAVING COUNT(*)>1
)
SELECT A.employee_id, A.email_id 
FROM CTE A INNER JOIN FILTER_EMAIL B ON A.lower_email = B.lower_email
WHERE A.is_lower = 1
ORDER BY A.employee_id
 