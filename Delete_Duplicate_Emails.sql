'''
Write an SQL query to delete all the duplicate emails, keeping only one unique email with the smallest id. 
Note that you are supposed to write a DELETE statement and not a SELECT one
'''

# Solution - 1 -> Using select and delete statement

WITH rank_email AS(
    SELECT 
        id, 
        email, 
        DENSE_RANK() OVER(PARTITION BY email ORDER BY id) AS rank
    FROM Person
 )
DELETE FROM Person WHERE id IN (SELECT id FROM rank_email WHERE rank > 1)

# Solution - 2 -> Using only delete statement

DELETE FROM Person A, Person B ON A.email = B.email AND A.id > B.id

# Solution -3 -> Using Group By

DELETE FROM Person WHERE id NOT IN (SELECT MIN(id) FROM Person GROUP BY email)