'''
Write a SQL query to generate schedule table
1. each team plays only once with each team
2. each team plays twice with each team
'''

# Only once
SELECT 
    A.Name as Team_A, B.Name AS Team_B 
FROM teams A,  teams B
WHERE A.Name < B.Name

# Twice
SELECT 
    A.Name as Team_A, B.Name AS Team_B 
FROM teams A,  teams B
WHERE A.Name <> B.Name