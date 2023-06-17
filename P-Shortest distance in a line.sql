'''
Table: x

Write a query to find the shortest distance between two points  
'''


SELECT A.x-B.x 
FROM Points A JOIN Points B
WHERE A.x > B.x
ORDER BY (A.x-B.x) LIMIT 1