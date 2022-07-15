'''
Query Statement -> Write an SQL query to report the first name, last name, city, and state of each person in the Person table. 
If the address of a personId is not present in the Address table, report null instead
'''

# Solution - 1 -> Using JOIN function 

SELECT FirstName, Lastname, City, State FROM Person p OUTER JOIN Address a ON p.PersonId = a.PersonId