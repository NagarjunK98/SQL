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


'''
Find out runs scored in each over including runs scored in extra balls. Additionally add 1 run extra for each non legal delivery

cricket_runs(balls_no, runs, delivery_type)
https://www.youtube.com/watch?v=1fQ2bZAF6uY
'''

'''
Things to consider here
    1. We have to consider 6 legal balls as one over
    2. Consider non legal delivery which are thrown in same over into same over runs
    3. There may be a case first delivery of each over could be non legal delivery. Consider this also into account
    4. Add 1 more run to each non-legal deliveries
'''

-- Solution-1 : My solution

-- Add 1 run to each non legal delivery. And change delivery_type(1->legal 0-> non legal)
WITH ADD_ONE_RUN AS (
    SELECT ball_no,
    CASE WHEN delivery_type = 'legal' THEN runs ELSE runs+1 END AS runs,
    CASE WHEN delivery_type = 'legal' THEN 1 ELSE 0 END AS delivery_type
    from cricket_runs
),
-- Find running sum of delivery_type (1,2,2,2,3,4,5,6,6,7,8,9)
RUNNING_BALLS_SUM AS (
    SELECT ball_no, runs, delivery_type, SUM(delivery_type) OVER(ORDER BY ball_no) AS running_balls
    FROM ADD_ONE_RUN
),
-- There could be case where starting ball itself is non legal ball. To handle that find the rank (1st 6=1 & 2nd 6=2)
ADD_RANK AS (
    SELECT ball_no, runs, delivery_type, running_balls, DENSE_RANK() OVER(PARTITION BY running_balls ORDER BY ball_no) as rn
    FROM RUNNING_BALLS_SUM
),
-- (1,2,2,2,3,4,5,6,6,7,8,9), In this example After 1st 6, over is complete. 2nd 6 belongs to next over, So add 1 to 6 and it becomes 7, indicating next over starting ball. sequence becomes (1,2,2,2,3,4,5,6,7,7,8,9)
INCREMENT_RUNNING_SUM AS (
    SELECT ball_no, runs, delivery_type,
    CASE WHEN running_balls % 6 = 0 AND rn > 1 THEN running_balls+1
    ELSE running_balls END AS running_balls
    FROM ADD_RANK
),
-- (1,2,2,2,3,4,5,6,7,7,8,9), here 2 rows has 7. We need to consider 1st 7 as starting ball, so find rank
ADD_RANK_1 AS (
    SELECT ball_no, runs, delivery_type, running_balls, DENSE_RANK() OVER(PARTITION BY running_balls ORDER BY ball_no) as rn_1
    FROM INCREMENT_RUNNING_SUM
),
-- if running_ball % 6 = 1, means starting of over, add 1 else 0 as new_over_start_ball
ADD_NEW_OVER_START_BALL AS (
    SELECT ball_no, runs, delivery_type, running_balls,
    CASE WHEN running_balls % 6 = 1 AND rn_1=1 THEN 1 ELSE 0 END AS new_over_start_ball
    FROM ADD_RANK_1
),
-- Find running sum to split overs as over_no
ADD_OVER_NO AS (
    SELECT runs, SUM(new_over_start_ball) OVER(ORDER BY ball_no) AS over_no
    FROM ADD_NEW_OVER_START_BALL
)
-- finally aggregate based on over_no
SELECT over_no, SUM(runs) as total_runs FROM ADD_OVER_NO 
GROUP BY over_no ORDER BY over_no


'''
Given job_positions & job_employee tables. Write an SQL query to display which position are filled and which are vacant

job_positions(id, title, groups, levels, payscale, totalpost)

job_employees(id, name, position_id)

'''
-- Solution-1

-- Find all filled positions
WITH ALREADY_FILLED AS (
    SELECT A.id, A.title, A.groups, A.levels, A.payscale, B.name, A.totalpost FROM job_positions A INNER JOIN job_employees B 
    ON A.id = B.position_id 
),
-- Find how many positions are still vacant after filling
VACANT_POST_COUNT AS (
    SELECT id, title, groups, levels, payscale, (totalpost-filled) as vacant_no FROM (
        SELECT id, title, totalpost, groups, levels, payscale, COUNT(*) as filled 
        FROM ALREADY_FILLED GROUP BY id, title, totalpost, groups, levels, payscale
    ) A 
    WHERE totalpost-filled > 0
),
-- Generate vacant position using recursive CTE 
GENERATE_VACANT AS (
    SELECT id, title, groups, levels, payscale, 1 AS flag, 'vacant' AS name
    FROM VACANT_POST_COUNT
    UNION ALL
    SELECT A.id, A.title, A.groups, A.levels, A.payscale, flag+1 as flag, 'vacant' AS name
    FROM GENERATE_VACANT A INNER JOIN VACANT_POST_COUNT B 
    ON A.id=B.id AND A.flag < B.vacant_no
)
-- Union filled and generated vacant positions
SELECT title, groups, levels, payscale, name from ALREADY_FILLED
UNION ALL
SELECT title, groups, levels, payscale, name  FROM GENERATE_VACANT


'''
Write sql query to build icc points table.
icc_world_cup(match_no, team_1, team_2, winner)
'''
-- Solution-1
WITH MATCHES_PLAYED AS (
    SELECT team, COUNT(*) AS matches_played FROM (
        SELECT team_1 AS team FROM icc_world_cup
        UNION ALL
        SELECT team_2 AS team FROM icc_world_cup
    ) A 
    GROUP BY team
),
WON_MATCHES AS (
    SELECT winner, COUNT(*) AS wins FROM icc_world_cup GROUP BY winner
)
SELECT A.team, A.matches_played, COALESCE(B.wins, 0) AS wins, (A.matches_played - COALESCE(B.wins, 0)) AS loss 
FROM MATCHES_PLAYED A LEFT JOIN WON_MATCHES B ON A.team = B.winner


'''
Write a SQL query to list companies whose revenue is increasing YOY

company_revenue(company, year, revenue)
'''

-- Solution-1: Using LAG by comparing previous year revenue with current year revenue
WITH FIND_PREVIOUS_YEAR_REVENUE as (
    SELECT company, year, revenue, LAG(revenue, 1, 0) OVER(PARTITION BY company ORDER BY year) AS previous_year_revenue
    FROM company_revenue
),
ADD_FLAG AS (
    SELECT company,
    CASE 
        WHEN previous_year_revenue < revenue THEN 1
        ELSE 0
    END AS flag
    FROM FIND_PREVIOUS_YEAR_REVENUE
)
SELECT company FROM ADD_FLAG GROUP BY company HAVING COUNT(DISTINCT flag) = 1 

-- Solution-2 : Using LEAD by comparing next year revenue with current year
WITH FIND_NEXT_YEAR_REVENUE as (
    SELECT company, year, revenue, LEAD(revenue) OVER(PARTITION BY company ORDER BY year) AS next_year_revenue
    FROM company_revenue
),
ADD_FLAG AS (
    SELECT company,
    CASE 
        WHEN revenue < next_year_revenue THEN 1
        WHEN revenue IS NOT NULL AND next_year_revenue IS NULL THEN 1
        ELSE 0
    END AS flag
    FROM FIND_NEXT_YEAR_REVENUE
)
SELECT company FROM ADD_FLAG GROUP BY company HAVING COUNT(DISTINCT flag) = 1


'''Write a SQL Query to fill missing transactions with qty value. At max only one transaction between them will be missing 

transactions(id, qty)

Input:
1 10
2 40
3 33
5 21
6 23
8 19

Output:
1 10
2 40
3 33
4 33
5 21
6 23
7 23
8 19
'''

-- Solution-1 : Used recursive cte to generate numbers.WE can generate upto 100 numbers due to recursive cte limitations
WITH FIND_MIN_MAX_ID AS (
    SELECT MIN(id) AS min_id, MAX(id) AS max_id FROM transactions
),
GENERATE_IDS AS (
    SELECT min_id AS id FROM FIND_MIN_MAX_ID
    UNION ALL
    SELECT id+1 AS id FROM GENERATE_IDS WHERE id < (SELECT max_id FROM FIND_MIN_MAX_ID)
),
ALL_IDS AS (
    SELECT A.id, B.qty FROM GENERATE_IDS A LEFT JOIN transactions B ON A.id=B.id
)
SELECT id, COALESCE(qty, LAG(qty,1) OVER(ORDER BY id)) AS qty
FROM ALL_IDS

-- Solution-2: Used sub query to find missing no
WITH FIND_MISSING_NO AS (
    SELECT id+1 AS id FROM transactions 
    WHERE id+1 NOT IN ( SELECT id from transactions)
),
FILTER_NO AS (
    SELECT id, null as qty FROM FIND_MISSING_NO WHERE id < (SELECT MAX(id) FROM transactions)
),
UNION_ALL AS (
    SELECT id, qty FROM transactions
    UNION ALL
    SELECT id, qty FROM FILTER_NO
)
SELECT id, COALESCE(qty, LAG(qty) OVER(ORDER BY id)) AS qty
FROM UNION_ALL

'''
An organization is looking to hire employees for their junior and senior positions. They have total limit of 50,000$, they have to first fill up the senior positions and then fill junior positions. 

candidates(id, positions, salary)
'''
WITH FIND_RUNNING_SALARY AS (
    SELECT positions, salary, SUM(salary) OVER(PARTITION BY positions ORDER BY salary ASC) AS running_total
    FROM candidates
),
-- COALESCE is used fill all senior have > 50,000 salary, so that they can hire juniors
FILTER_SENIOR AS (
    SELECT COALESCE(SUM(salary),0) AS senior_total, COUNT(*) AS senior_count 
    FROM FIND_RUNNING_SALARY 
    WHERE positions = 'senior' AND running_total <=50000
),
FILTER_JUNIOR AS (
    SELECT SUM(salary) AS junior_salary, COUNT(*) AS junior_count
    FROM FIND_RUNNING_SALARY
    WHERE positions = 'junior' AND salary <= (SELECT (50000 -        senior_total) FROM FILTER_SENIOR)
)
SELECT A.junior_count AS juniors, B.senior_count AS seniors 
FROM FILTER_JUNIOR A, FILTER_SENIOR B


'''
Write SQL to print employee_id, default phone no, totalentry, totallogin, tottalogout, latest login, latest logout

employee_checking_details(employeeid, entry_details, timestamp_details)

employee_details(employeeid, phone_number , isdefault)
'''

-- Solution-1 : Not optimized

WITH LOG_COUNT AS (
  SELECT employeeid, entry_details, COUNT(*) AS log_count 
  from employee_checking_details 
  GROUP BY employeeid, entry_details
),
PIVOT_DATA_LOG_COUNT AS (
  SELECT employeeid, login AS login_count, logout AS logout_count, (login+logout) AS totalentry FROm (
      SELECT employeeid, entry_details, log_count
      FROM LOG_COUNT
  ) AS TEMP
  PIVOT (
  MAX(log_count)
  FOR entry_details IN ([login], [logout])
  ) AS A
),
LATEST_LOG_TIME AS (
  SELECT employeeid, entry_details, MAX(timestamp_details) as latest_time FROM employee_checking_details
  GROUP BY employeeid, entry_details
),
PIVOT_LATEST_LOG_TIME AS (
  SELECT employeeid, login AS latest_login, logout AS latest_logout FROM (
      SELECT employeeid, entry_details, latest_time
      FROM LATEST_LOG_TIME
  ) AS TEMP
  PIVOT (
      MAX(latest_time)
      FOR entry_details IN ([login], [logout])
  ) AS A
),
JOINED_DATA AS (
  SELECT A.employeeid, A.totalentry, A.login_count, A.logout_count, B.latest_login, B.latest_logout
  FROM PIVOT_DATA_LOG_COUNT A INNER JOIN PIVOT_LATEST_LOG_TIME B ON A.employeeid = B.employeeid
),
DEFAULT_PHONE_NO AS (
	SELECT employeeid, phone_number FROM employee_details WHERE isdefault = 1
)
SELECt A.employeeid, A.totalentry, A.login_count, A.logout_count, A.latest_login, A.latest_logout, B.phone_number
FROM JOINED_DATA A LEFT JOIN DEFAULT_PHONE_NO B ON A.employeeid = B.employeeid

-- Solution-2 : Optimized approach

-- employee_id, def phone, totelentry, totallogin, tottalogout, latest login, latest logout
WITH LOGIN_DETAILS AS (
  SELECT employeeid, COUNT(*) AS login_count, MAX(timestamp_details) As latest_login
  FROM employee_checking_details 
  WHERE entry_details = 'login'
  GROUP BY employeeid
),
LOGOUT_DETAILS AS (
  SELECT employeeid, COUNT(*) AS logout_count, MAX(timestamp_details) As latest_logout
  FROM employee_checking_details 
  WHERE entry_details = 'logout'
  GROUP BY employeeid
),
JOINED_DATA AS (
  SELECT A.employeeid, A.login_count, B.logout_count, (A.login_count+B.logout_count) AS totalentry, A.latest_login, B.latest_logout
  FROM LOGIN_DETAILS A INNER JOIN LOGOUT_DETAILS B ON A.employeeid = B.employeeid
)
SELECt A.employeeid, A.totalentry, A.login_count, A.logout_count, A.latest_login, A.latest_logout, B.phone_number
FROM JOINED_DATA A LEFT JOIN employee_details B ON A.employeeid = B.employeeid AND B.isdefault = 1


'''
Write SQL query to print min & max population in each state

city_population(state, city, population)
'''

WITH MIN_POPULATION AS (
  SELECT state, min_city, population FROM (
    SELECT state, city AS min_city, population, RANK() OVER(PARTITION BY state ORDER by population) AS min_rk
    from city_population
    ) A
  WHERE min_rk = 1 
),
MAX_POPULATION AS (
  SELECT state, max_city, population FROM (
    SELECT state, city AS max_city, population, RANK() OVER(PARTITION BY state ORDER by population DESC) AS max_rk
    from city_population
    ) A
  WHERE max_rk = 1 
)
SELECT A.state, A.min_city, B.max_city FROM MIN_POPULATION A INNER JOIN MAX_POPULATION B ON A.state = B.state


'''
Write SQL query to list department with average salary lower tan average salary of company.
However, when calculating company average salary, you must exclude salaries of department you are comparing it with.

Example - when comparing average salary of HR dept with company avg, HR dept salaries should not taken into consideration.
'''

-- Solution-1

WITH DEPT_LEVEL AS (
    SELECT department_id, COUNT(*) as emp_count, SUM(salary) AS salary_sum, AVG(salary) AS dept_avg
    FROM emp GROUP BY department_id
),
-- UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING consider all rows to give SUM, So minus total with current row dept salary
FIND_EXCEPT_DEPT AS (
    SELECT department_id, emp_count, salary_sum, dept_avg,
    SUM(salary_sum) OVER(ORDER BY department_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) - salary_sum AS expt_dept_sum,
    SUM(emp_count) OVER(ORDER BY department_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) - emp_count AS expt_dept_count
    FROM DEPT_LEVEL
)
SELECT department_id FROM (
    SELECT department_id, dept_avg, (1.0*expt_dept_sum/expt_dept_count) as expt_dept_avg
    FROM FIND_EXCEPT_DEPT
) A 
WHERE expt_dept_avg > dept_avg


'''
Write SQL query to find all couples of trade for same stock that happened in range of 10 seconds and having price difference by more than 10% 

Trades(trade_id, trade_timestamp, trade_stock, quantity, price)
'''
WITH TRADES_LIST AS (
    SELECT A.TRADE_ID AS first_trade, B.TRADE_ID AS second_trade, A.Trade_Timestamp AS trade_A_ts, B.Trade_Timestamp AS trade_B_ts,
    A.Price AS first_trade_price, B.Price AS second_trade_price
    FROM Trades A INNER JOIN Trades B ON A.Trade_Stock = B.Trade_Stock
    WHERE A.TRADE_ID < B.TRADE_ID
)
SELECT first_trade, second_trade, first_trade_price, second_trade_price, percentdiff FROM (
    SELECT first_trade, second_trade, first_trade_price, second_trade_price, ROUND(ABS(100.0*(first_trade_price-second_trade_price)/first_trade_price), 2) AS percentdiff
    FROM TRADES_LIST
    WHERE ABS(DATEDIFF(second, trade_A_ts, trade_B_ts)) < 10
) A 
WHERE percentdiff > 10