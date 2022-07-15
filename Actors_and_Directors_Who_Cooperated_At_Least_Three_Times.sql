'''
Query Statement -> Write a SQL query for a report that provides the pairs (actor_id, director_id) 
where the actor has cooperated with the director at least three times
'''

# Solution - 1 -> Using Aggregate function

SELECT ACTOR_ID, DIRECTOR_ID FROM ACTORDIRECTOR GROUP BY ACTOR_ID, DIRECTOR_ID HAVING COUNT(*) >=3