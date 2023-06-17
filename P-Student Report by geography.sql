'''
table: name, continent

Pivot continent column in this table so that name is sorted alphabetically 
and displayed underneath its corresponding continent
'''

WITH ADD_RN AS (
select *, ROW_NUMBER() OVER(ORDER BY name) AS RN from s1
),
PIVOT_DATA AS (
SELECT 
MAX(CASE WHEN continent='America' THEN name END) AS America,
MAX(CASE WHEN continent='Asia' THEN name END) AS Asia,
MAX(CASE WHEN continent='Europe' THEN name END) AS Europe
FROM ADD_RN
GROUP BY RN
)
SELECT COALESCE(America, '') AS America,
COALESCE(Asia, '') AS Asia,
COALESCE(Europe, '') AS Europe 
FROM PIVOT_DATA

'''
Using above query will have empty spaces in result. Try to find way to handle it
'''