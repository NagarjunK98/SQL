'''
Query Statement -> Write an SQL query to report all the duplicate emails
'''

# Solution - 1 -> Using GROUP BY function

SELECT email FROM Person GROUP BY email HAVING COUNT(email) > 1;