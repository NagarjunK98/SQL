'''
Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its 
corresponding Occupation. The output column headers should be Doctor, Professor, Singer, and Actor, respectively.

Note: Print NULL when there are no more names corresponding to an occupation
'''

WITH ADD_RN AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY OCCUPATION ORDER BY NAME) AS RN 
    FROM OCCUPATIONS
)
SELECT 
    MAX(CASE WHEN OCCUPATION = 'Doctor' THEN NAME END) AS Doctor,
    MAX(CASE WHEN OCCUPATION = 'Professor' THEN NAME END) AS Professor,
    MAX(CASE WHEN OCCUPATION = 'Singer' THEN NAME END) AS Singer,
    MAX(CASE WHEN OCCUPATION = 'Actor' THEN NAME END) AS Actor
FROM ADD_RN
GROUP BY RN

'''
If don't want to show NULLs, then use IFNULL or COALESE to replace NULL with some value
'''