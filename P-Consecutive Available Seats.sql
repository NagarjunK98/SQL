'''
Table: seat_id, free

Write a query to display all consecutive available seats order by seat_id 
'''

SELECT DISTINCT A.seat_id
FROM seats A JOIN seat_id B 
ON ABS(A.seat_id = B.seat_id) = 1
WHERE A.free = 1 AND B.free = 1
ORDER BY A.seat_id