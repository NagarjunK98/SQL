'''
Write a SQL query to find pairs of adult and child to go for a ride.
The pair should be in a way that oldest adult should be with youngest child and so on
'''

WITH ADULT_RN AS (
SELECT person, ROW_NUMBER() OVER(ORDER BY age DESC, person) as rn FROM rides WHERE type = 'ADULT'
),
CHILD_RN AS (
SELECT person, ROW_NUMBER() OVER(ORDER BY age, person) as rn FROM rides WHERE type = 'CHILD'
)
SELECT A.person AS ADULT, B.person AS CHILD FROM ADULT_RN A LEFT JOIN CHILD_RN B ON A.rn = B.rn