'''
Query Statement -> Write an SQL query to report the names of the customer that are not referred by the customer with id = 2
'''

# Solution - 1 -> Using conditions

SELECT name FROM Customer  WHERE referee_id<>2 OR referee_id IS NULL
