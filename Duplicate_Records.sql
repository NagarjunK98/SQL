'''
Write a SQL Query to fetch duplicates user records from table
'''

WITH assign_row_no AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY user_name) as rn FROM User
)

SELECT * FROM assign_row_no WHERE rn > 1