'''
+-------------+------+
| Column Name | Type |
+-------------+------+
| power       | int  |
| factor      | int  |
+-------------+------+
power is the primary key column for this table.
Each row of this table contains information about one term of the equation.
power is an integer in the range [0, 100].
factor is an integer in the range [-100, 100] and cannot be zero.

You have a very powerful program that can solve any equation of one variable in the world. The equation passed to the program 
must be formatted as follows:
    1. The left-hand side (LHS) should contain all the terms.
    2. The right-hand side (RHS) should be zero.
    3. Each term of the LHS should follow the format "<sign><fact>X^<pow>" where:
        <sign> is either "+" or "-".
        <fact> is the absolute value of the factor.
        <pow> is the value of the power.
    4. If the power is 1, do not add "^<pow>".
        For example, if power = 1 and factor = 3, the term will be "+3X".
    5. If the power is 0, add neither "X" nor "^<pow>".
        For example, if power = 0 and factor = -3, the term will be "-3".
    6. The powers in the LHS should be sorted in descending order.
Write an SQL query to build the equation.

Input: 
Terms table:
+-------+--------+
| power | factor |
+-------+--------+
| 2     | 1      |
| 1     | -4     |
| 0     | 2      |
+-------+--------+
Output: 
+--------------+
| equation     |
+--------------+
| +1X^2-4X+2=0 |
+--------------+

Input: 
Terms table:
+-------+--------+
| power | factor |
+-------+--------+
| 4     | -4     |
| 2     | 1      |
| 1     | -1     |
+-------+--------+
Output: 
+-----------------+
| equation        |
+-----------------+
| -4X^4+1X^2-1X=0 |
+-----------------+

'''
WITH ROW_LEVEL_EQ AS (
    SELECT *, 
    CASE 
        WHEN power = 0 AND factor > 0 THEN CONCAT('+', factor)
        WHEN power = 0 AND factor < 0 THEN CAST(factor as VARCHAR(2))
        WHEN power = 1 AND factor > 0 THEN CONCAT('+', factor, 'X')
        WHEN power = 1 AND factor < 0 THEN CONCAT(factor, 'X')
        WHEN power > 1 AND factor < 0 THEN CONCAT(factor, 'X^', power)
        WHEN power > 1 AND factor > 0 THEN CONCAT('+', factor, 'X^', power)
    END AS equation,
    ROW_NUMBER() OVER(ORDER BY power DESC) AS rn
    FROM terms
),
MAX_ROW AS (
    SELECT MAX(rn) AS max_rn FROM ROW_LEVEL_EQ
),
RECURSIVE_CTE AS (
    SELECT CAST(equation AS VARCHAR(MAX)) AS equation, 1 as row FROM ROW_LEVEL_EQ WHERE rn=1
    UNION ALL
    SELECT CONCAT(A.equation, B.equation), A.row+1 FROM RECURSIVE_CTE A INNER JOIN ROW_LEVEL_EQ B ON B.rn = A.row+1
    WHERE B.rn <= (SELECT max_rn FROM MAX_ROW)
)
SELECT CONCAT(equation, '=0') as equation FROM RECURSIVE_CTE where row = (SELECT max_rn FROM MAX_ROW)
