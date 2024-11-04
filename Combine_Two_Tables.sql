'''
Query Statement -> Write an SQL query to report the first name, last name, city, and state of each person in the Person table. 
If the address of a personId is not present in the Address table, report null instead
'''

# Solution - 1 -> Using JOIN function 

SELECT FirstName, Lastname, City, State FROM Person p OUTER JOIN Address a ON p.PersonId = a.PersonId

res_df = person.alias("A").join(address.alias("B"), person.person_id == address.person_id, "outer") \
            .select("A.firstname", "A.lastname", "B.city", "B.state")