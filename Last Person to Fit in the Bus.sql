'''
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| person_id   | int     |
| person_name | varchar |
| weight      | int     |
| turn        | int     |
+-------------+---------+
person_id is the primary key column for this table.
This table has the information about all people waiting for a bus.
The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table.
turn determines the order of which the people will board the bus, where turn=1 denotes the first person to board and 
turn=n denotes the last person to board.
weight is the weight of the person in kilograms.

There is a queue of people waiting to board a bus. However, the bus has a weight limit of 1000 kilograms, 
so there may be some people who cannot board.

Write an SQL query to find the person_name of the last person that can fit on the bus without exceeding the weight limit. 
The test cases are generated such that the first person does not exceed the weight limit.
'''

WITH ADD_FLAG AS (
SELECT turn, person_name, 
CASE 
    WHEN SUM(weight) OVER(ORDER BY turn) < 1000 AND 
    SUM(weight) OVER(ORDER BY turn ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING) < 1000 THEN 0
    WHEN SUM(weight) OVER(ORDER BY turn) = 1000 THEN 1
    WHEN SUM(weight) OVER(ORDER BY turn) < 1000 AND SUM(weight) 
    OVER(ORDER BY turn ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING) > 1000 THEN 1
END AS flag
FROM Queue 
)
SELECT 
CASE WHEN SUM(flag) = 1 THEN (SELECT person_name FROM ADD_FLAG WHERE flag=1) 
ELSE (SELECT person_name FROM Queue WHERE turn = (SELECT MAX(turn) FROM Queue))
END AS person_name 
FROM ADD_FLAG