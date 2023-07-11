'''
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| drink       | varchar |
+-------------+---------+
id is the primary key for this table.
Each row in this table shows the order id and the name of the drink ordered. Some drink rows are nulls.

Write an SQL query to replace the null values of drink with the name of the drink of the previous row that is not null. 
It is guaranteed that the drink of the first row of the table is not null.

Input: 
CoffeeShop table:
+----+------------------+
| id | drink            |
+----+------------------+
| 9  | Mezcal Margarita |
| 6  | null             |
| 7  | null             |
| 3  | Americano        |
| 1  | Daiquiri         |
| 2  | null             |
+----+------------------+
Output: 
+----+------------------+
| id | drink            |
+----+------------------+
| 9  | Mezcal Margarita |
| 6  | Mezcal Margarita |
| 7  | Mezcal Margarita |
| 3  | Americano        |
| 1  | Daiquiri         |
| 2  | Daiquiri         |
+----+------------------+
Explanation: 
For ID 6, the previous value that is not null is from ID 9. We replace the null with "Mezcal Margarita".
For ID 7, the previous value that is not null is from ID 9. We replace the null with "Mezcal Margarita".
For ID 2, the previous value that is not null is from ID 1. We replace the null with "Daiquiri".
Note that the rows in the output are the same as in the input.
'''

# MySQL Solution
'''
In SQL Server, we need to specify ORDER BY Clause inside OVER(), So this approach cant be solved using SQL Server. 
So used MySQL to solve the problem  

Understand the approach once again to solve related questions
'''
WITH ASSIGN_ROW_NO AS (
    SELECT id, drink, ROW_NUMBER() OVER () AS RN FROM coffeeshop
),
ASSIGN_GROUP AS (
    SELECT id, drink, RN, SUM(1-ISNULL(drink)) OVER (ORDER BY RN) AS group_id FROM ASSIGN_ROW_NO
)
SELECT id, FIRST_VALUE(drink) OVER (PARTITION BY group_id) AS drink
FROM ASSIGN_GROUP
ORDER BY RN;


'''
Slighted modified question

Write an SQL query to replace the null values of drink with the name of the drink of the previous row that is not null order by id column. 
It is guaranteed that the drink of the first row of the table is not null.
'''
# MySQL Solution

WITH ASSIGN_ROW_NO AS (
SELECT id, drink, ROW_NUMBER() OVER (ORDER BY id) AS RN FROM coffeeshop
),
ASSIGN_GROUP AS (
SELECT id, drink, RN, SUM(1-ISNULL(drink)) OVER (ORDER BY RN) AS group_id
FROM ASSIGN_ROW_NO
)
SELECT id, FIRST_VALUE(drink) OVER (PARTITION BY group_id) AS drink
FROM ASSIGN_GROUP
ORDER BY RN;