'''
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| name          | varchar |
| value         | int     |
+---------------+---------+
name is the primary key for this table.
This table contains the stored variables and their values.

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| left_operand  | varchar |
| operator      | enum    |
| right_operand | varchar |
+---------------+---------+
(left_operand, operator, right_operand) is the primary key for this table.
This table contains a boolean expression that should be evaluated.
operator is an enum that takes one of the values ('<', '>', '=')
The values of left_operand and right_operand are guaranteed to be in the Variables table.

Variables table:
+------+-------+
| name | value |
+------+-------+
| x    | 66    |
| y    | 77    |
+------+-------+

Expressions table:
+--------------+----------+---------------+
| left_operand | operator | right_operand |
+--------------+----------+---------------+
| x            | >        | y             |
| x            | <        | y             |
| x            | =        | y             |
| y            | >        | x             |
| y            | <        | x             |
| x            | =        | x             |
+--------------+----------+---------------+

Result table:
+--------------+----------+---------------+-------+
| left_operand | operator | right_operand | value |
+--------------+----------+---------------+-------+
| x            | >        | y             | false |
| x            | <        | y             | true  |
| x            | =        | y             | false |
| y            | >        | x             | true  |
| y            | <        | x             | false |
| x            | =        | x             | true  |
+--------------+----------+---------------+-------+
As shown, you need find the value of each boolean exprssion in the table using the variables table.
'''

# Solution-1: SQL Server

WITH PIVOT_DATA AS (
SELECT * FROM (
	SELECT name, value
  	FROM Variables
	) AS temp_table
  PIVOT (
  MAX(value)
    FOR name IN ([x], [y])
  ) AS pivot_table
),
ADD_XY AS (
SELECT * FROM expressions CROSS JOIN PIVOT_DATA
)

SELECT left_operand, operator, right_operand,
CASE 
WHEN left_operand = 'x' AND right_operand = 'x' AND operator = '='  THEN 'true'
WHEN left_operand = 'y' AND right_operand = 'y' AND operator = '='  THEN 'true'
WHEN left_operand = 'x' AND right_operand = 'y' AND operator = '='  AND x=y THEN 'true'
WHEN left_operand = 'x' AND right_operand = 'y' AND operator = '>'  AND x>y THEN 'true'
WHEN left_operand = 'x' AND right_operand = 'y' AND operator = '<'  AND x<y THEN 'true'
WHEN left_operand = 'y' AND right_operand = 'x' AND operator = '>'  AND y>x THEN 'true'
WHEN left_operand = 'y' AND right_operand = 'x' AND operator = '<'  AND y<x THEN 'true'
ELSE 'false'
end as s
FROM ADD_XY

# Solution -2 : Mysql

select e.left_operand, e.operator, e.right_operand,
    case
        when e.operator = '<' then if(l.value < r.value,'true','false')
        when e.operator = '>' then if(l.value > r.value,'true','false')
        else if(l.value = r.value,'true','false')
    end as value
from expressions e 
left join variables l on e.left_operand = l.name 
left join variables r on e.right_operand = r.name

# Solution-3: SQL Server

select e.left_operand, e.operator, e.right_operand,
    case
        when e.operator = '<' then IIF(l.value < r.value,'true','false')
        when e.operator = '>' then IIF(l.value > r.value,'true','false')
        else IIF(l.value = r.value,'true','false')
    end as value
from expressions e 
left join variables l on e.left_operand = l.name 
left join variables r on e.right_operand = r.name