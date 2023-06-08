'''
Write an SQL query to find all numbers that appear at least three times consecutively.

'''

# Solution -1 -> Using window function 

WITH CTE_1 AS(
    SELECT 
        id, 
        num, 
        LEAD(num,1) OVER( ORDER BY id) AS second_no,
        LEAD(num,2) OVER( ORDER BY id) AS third_no
    FROM Logs 
)
SELECT DISTINCT num AS ConsecutiveNums FROM CTE_1
WHERE num = second_no AND second_no = third_no