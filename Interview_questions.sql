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
 

'''
Write an SQL query to find percentage increase in covid cases versus cumulative cases as of prior(previous) month
covid_case(records_date, cases)
'''
WITH MONTH_AGG AS (
    SELECT MONTH(record_date) AS month_no, SUM(cases) as total_cases
    FROM covid_cases
    GROUP BY MONTH(record_date)
),
FIND_CUMULATIVE_CASES AS (
    SELECT month_no, total_cases, 
    SUM(total_cases) OVER(ORDER BY month_no ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) as cumulative_sum
    FROM MONTH_AGG
)
SELECT month_no, ROUND(cumulative_sum*100.0/total_cases, 1) AS percentage FROM FIND_CUMULATIVE_CASES



'''
Write an SQL query to remove duplicate path from city_distance table
city_distance(distance, source, destination)
'''
SELECT distance, source, destination 
FROM city_distance WHERE source < destination
UNION
SELECT distance, destination, source 
FROM city_distance WHERE source > destination


'''
Write a query to find busiest route with total ticket count
oneway_round='O' -> one way trip
oneway_round='R' -> Round trip
NOTE DEL -> BOM is different route from BOM -> DEL

tickets(airline_number, origin, destination, oneway_round, ticket_count)
'''
WITH CTE AS (
    SELECT origin, destination, SUM(ticket_count) as total_count FROM (
        SELECT origin, destination, ticket_count FROM tickets WHERE oneway_round = 'O'
        UNION ALL
        SELECT origin as origin, destination as destination, ticket_count FROM tickets WHERE oneway_round = 'R' AND origin < destination
        UNION ALL
        SELECT destination as origin, origin as destination, ticket_count FROM tickets WHERE oneway_round = 'R' AND origin > destination
        ) A GROUP BY origin, destination
    )   
SELECT origin, destination, total_count FROM (
    SELECT origin, destination, total_count, RANK() OVER(ORDER BY total_count DESC) as rn
    FROM CTE
) A WHERE rn=1



'''
Write a SQL query to find out supplier_id, product_id, no of days and starting date of record_date for which stock quantity is < 50 for 2 or more consecutive days

stock(supplier_id, product_id, record_date, stock_quantity)
'''
-- First find the previous date, if previous_date not present assign current record_date
WITH CTE AS (
  SELECT supplier_id, product_id, record_date, LAG(record_date, 1, record_date) over(partition by supplier_id, product_id ORDER BY record_date) as prev_date
  from stock WHERE stock_quantity < 50
),
-- find days difference between prev_date & record_date
CTE1 AS (
  SELECT supplier_id, product_id, record_date, DATEDIFF(DAY, prev_date, record_date) as daysdiff
  from CTE
),
-- Assign a flag based on daysdiff. if record_date are consecutive, then daysdiff will be 0 or 1, hence if daysdiff <=1 assign 0 else 1. 1 indicates starting of new group
CTE2  AS (
  SELECT supplier_id, product_id, record_date, 
  CASE WHEN daysdiff <=1 THEN 0 ELSE 1 END AS flag 
  FROM CTE1
),
-- Add group_id by calculating running sum on flag column
CTE3 AS (
  SELECT *, SUM(flag) over(partition by supplier_id, product_id ORDER BY record_date) as group_id
  FROM CTE2
)
-- Group by supplier_id and product_id and find count(*), and min(record_date) with atleast 2 consecutive days 
SELECT supplier_id, product_id, COUNT(*), MIN(record_date) FROM CTE3
GROUP BY supplier_id, product_id, group_id HAVING COUNT(*) >= 2
ORDER BY supplier_id, product_id


'''
Write a SQL query to print maximum number of discounted tours any 1 family in the families table can choose from.

families(id, name, family_size)
countries(id, name, min_size)
'''
SELECT COUNT(*) FROM countries WHERE min_size <= (SELECT MAX(family_size) FROM families)


-- Along with MIN_SIZE, if we have MAX_SIZE
SELECT MAX(count) FROM (
    SELECT A.name, COUNT(*) as count 
    FROM families A INNER JOIN countries B
    ON A.family_size BETWEEN B.min_size AND B.MAX_SIZE
    GROUP BY A.name
) A


'''
Write a SQL query to print best movie in each genre along with average rating printing in stars(****). 

movies(id, title, genre)
reviews(movie_id, rating)
'''
SELECT genre, title, REPLICATE('*', avg_rating) as stars 
FROM (
  SELECT A.genre, A.title, ROUND(AVG(B.rating), 0) as avg_rating, ROW_NUMBER() OVER(PARTITION BY A.genre ORDER BY AVG(B.rating) DESC) AS rank
  from movies A LEFT JOIN reviews B ON A.id = B.movie_id
  GROUP BY A.genre, A.title
) A 
WHERE A.rank=1


'''
Write a SQL query to split name into first name, middle name, and last name. If middle and last name not found, put NULL
'''

-- First number of spaces(0 -> onlyFirst name, 1 -> First and last name, 2 -> first, middle and last name)
WITH no_of_spaces as (
  SELECT customer_name, 
  (len(customer_name) - len(replace(customer_name, ' ', '') )) AS no_of_spaces,
  CHARINDEX(' ', customer_name) as first_space_index,
  CHARINDEX(' ', customer_name, CHARINDEX(' ', customer_name)+1) as second_space_index
  FROM customers
)
SELECT 
CASE 
	WHEN no_of_spaces = 0 THEN customer_name
    ELSE SUBSTRING(customer_name, 1, first_space_index)
    END AS FIRST_NAME,
CASE 
	WHEN no_of_spaces = 0 THEN NULL
    WHEN no_of_spaces = 1 THEN NULL
    ELSE SUBSTRING(customer_name, first_space_index+1,len(customer_name)-second_space_index+1)
    END AS MIDDLE_NAME,
CASE 
	WHEN no_of_spaces = 0 THEN NULL
    WHEN no_of_spaces = 1 THEN SUBSTRING(customer_name, first_space_index+1, len(customer_name)-first_space_index+1)
   ELSE SUBSTRING(customer_name, second_space_index+1, len(customer_name)-second_space_index+1)
    END AS LAST_NAME
FROM no_of_spaces


'''
Write a SQL query to get distribution of games(% of total games) based on social interaction that is happening during the games.
No social interaction(no msgs, emojis or gifts during game)
One sided interaction(messages, emojis or gifts sent during game by only one player)
Both sided interaction without custom_types messages
Both sided interaction with custom_typed messages from at least one player

user_interaction(user_id, event, date, interaction_type, game_id, timestamp)
'''

-- Solution-1
WITH no_interaction as (
    SELECT game_id, 'no interaction' AS type from user_interactions GROUP BY game_id HAVING COUNT(interaction_type) = 0
),
one_side_int AS (
    SELECT distinct game_id, 'one side interation' as type
    from user_interactions 
    WHERE interaction_type IS NOT NULL
    GROUP BY game_id HAVING COUNT(DISTINCT user_id) = 1
),
both_side_inr_no_custom as (
    SELECT distinct game_id, 'both side interaction no custom' AS type
    from user_interactions 
    GROUP BY game_id HAVING COUNT(DISTINCT user_id) = 2 AND COUNT(DISTINCT interaction_type) = 3
),
both_side_inr_custom AS (
    SELECT distinct game_id, 'both side interaction with custom' as type
    from user_interactions 
    GROUP BY game_id HAVING COUNT(DISTINCT user_id) = 2 AND COUNT(DISTINCT interaction_type) = 4
),
union_all AS (
    SELECT * FROM no_interaction
    UNION ALL
    SELECT * FROM one_side_int
    UNION ALL
    SELECT * FROM both_side_inr_no_custom
    UNION ALL
    SELECT * FROM both_side_inr_custom
) 
SELECT * FROM union_all
SELECT type, ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM union_all), 1) AS percentage
FROM union_all
GROUP BY type


-- Solution-2: Optimized approach(logic is same, used case stmt)
WITH union_all AS (
SELECT game_id, 
CASE 
	WHEN COUNT(DISTINCT interaction_type) = 0 THEN 'no interaction'
    WHEN COUNT(DISTINCT CASE WHEN interaction_type IS NOT NULL THEN user_id END) = 1 THEN 'one side interation'
    WHEN COUNT(DISTINCT user_id) = 2 AND COUNT(CASE WHEN interaction_type='custom_typed' THEN user_id END) = 0 THEN 'both side interaction no custom'
    WHEN COUNT(DISTINCT user_id) = 2 AND  COUNT(CASE WHEN interaction_type='custom_typed' THEN user_id END) >= 1 THEN 'both side interaction with custom'
END AS type
from user_interactions 
GROUP BY game_id 
)
SELECT type, 100.0*COUNT(*)/COUNT(*) OVER() AS percentage
FROM union_all
GROUP BY type


'''
Write a SQL query to find words which are repeating more than once considering all the rows content column
'''
SELECT value AS word, COUNT(*) AS count 
FROM content CROSS APPLY STRING_SPLIT(content, ' ')
GROUP BY value HAVING COUNT(*) > 1


'''
Write an SQL query to print record is new in source table or target table. If id present in source and target table, check name value is same or not, if not same highlight as modified and skip records where id and name is same in both tables

source(id, name)
    1 A
    2 B
    3 C
    4 D
target(id, name)
    1 A
    2 B
    4 X
    5 F
'''

-- Solution-1
WITH UNION_ALL AS (
    SELECT id, name, 'source' as flag FROM source
    UNION ALL
    SELECT id, name, 'target' AS flag FROM target
),
REMOVED_SAME AS (
    SELECT id, name FROM UNION_ALL GROUP BY id, name HAVING COUNT(*) = 1
),
FIND_OCCURANCE AS (
    SELECT id, COUNT(*) AS c FROM REMOVED_SAME GROUP BY id
)
SELECT A.id, 
CASE 
    WHEN B.flag = 'source' THEN 'New in source'
    ELSE 'New in target' 
END AS comment
FROM FIND_OCCURANCE A INNER JOIN UNION_ALL B ON A.id = B.id
WHERE A.c = 1
UNION ALL
SELECT id, 'Modified' AS comment
FROM FIND_OCCURANCE
WHERE c > 1

-- Solution-2 - Apply FULL OUTER JOIN 

-- After joining, Filter records where name is same
WITH OUTER_JOIN AS (
    SELECT A.id AS A_id, A.name AS A_name, B.id AS B_id, B.name AS B_name
    FROM source A FULL OUTER JOIN target B ON A.id = B.id
    WHERE A.name != B.name OR A.name IS NULL OR B.name IS NULL
)
SELECT COALESCE(A_id, B_id) as id, 
CASE 
    WHEN A_id = B_id AND A_name <> B_name THEN 'mismatch'
    WHEN A_id IS NOT NULL AND B_id IS NULL THEN 'New in source'
    WHEN A_id IS NULL AND B_id IS NOT NULL THEN 'New in target'
END AS comment
FROM OUTER_JOIN

'''
Find out number of clocked hours be each employee in office.
flag -> I means punch in & O means punch out. 
Employee can have multiple punch in and punch out in a day.
clocked_hours(empd_id int, swipe time, flag string)
'''
WITH FIND_LOGOUT_TIME AS (
    SELECT empd_id, swipe as login_time, flag, LEAD(swipe) OVER(PARTITION BY empd_id ORDER BY swipe) as logout_time
    FROM clocked_hours
)
SELECT empd_id, SUM(DATEDIFF(HOUR, login_time, logout_time)) AS hours 
FROM FIND_LOGOUT_TIME WHERE flag = 'I'
GROUP BY empd_id

'''
Find origin and final destination for each cid

cid fid origin destination
1   f1    Del     Hyd
1   f2    Hyd     Blr
2   f3    Mum     Agra
2   f4    Agra    Kol

Output
1 Del Blr
2 Mum Kol
'''

SELECT A.cid, A.origin FROM flights A INNER JOIN B ON A.cid=B.cid AND A.destination=B.origin

'''
Find count of new customers added in each month in sales table

sales (order_date, customer, qty)
'''
-- Find the first order for each customer
WITH FIND_FIRST_SALE AS (
    SELECT order_date, customer, ROW_NUMBER() OVER(PARTITION BY customer order BY order_date) as rn
    FROM sales
)
-- rn=1 -> new customer & rn>1 -> repeated customers
SELECT order_date, SUM(CASE WHEN rn=1 THEN 1 ELSE 0 END) AS unique_customers
FROM FIND_FIRST_SALE GROUP BY order_date

'''
Find count of repeated customers in each month in sales table

sales (order_date, customer, qty)
'''
WITH FIND_FIRST_SALE AS (
    SELECT order_date, customer, ROW_NUMBER() OVER(PARTITION BY customer order BY order_date) as rn
    FROM sales
)
-- rn=1 -> new customer & rn>1 -> repeated customers
SELECT order_date, SUM(CASE WHEN rn>1 THEN 1 ELSE 0 END) AS unique_customers
FROM FIND_FIRST_SALE GROUP BY order_date

