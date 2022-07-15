'''
Query Statement ->Write an SQL query to report all customers who never order anything.
Return the result table in any order
'''

# Solution - 1 -> Using Sub-queries

SELECT C.name AS Customers  FROM CUSTOMERS C WHERE C.id NOT IN (SELECT O.customerId FROM ORDERS O) 
