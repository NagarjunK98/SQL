'''
Table: x,y

Write a query to find the shortest distance between points rounded to 2 decimals
'''

SELECT ROUND(MIN(SQRT((A.x - B.x) * (A.x - B.x) + (A.y - B.y) * (A.y - B.y)), 2)) as short_distance 
FROM Cordinates A, Cordinates B
WHERE A.x != B.x AND A.y != B.y