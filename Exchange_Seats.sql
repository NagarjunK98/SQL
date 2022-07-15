'''
Query Statement -> Write an SQL query to swap the seat id of every two consecutive students. 
If the number of students is odd, the id of the last student is not swapped.
Return the result table ordered by id in ascending order
'''

# Solution - 1 -> Using CASE statement

SELECT 
    CASE 
        WHEN ID%2=0 THEN ID-1
        WHEN ID%2!=0 AND (SELECT MAX(ID) FROM SEAT)!=ID THEN ID+1
        ELSE ID
    END AS ID,
    STUDENT
FROM SEAT
ORDER BY ID