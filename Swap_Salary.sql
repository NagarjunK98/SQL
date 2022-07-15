'''
Query Statement -> Write an SQL query to swap all 'f' and 'm' values (i.e., change all 'f' values to 'm' and vice versa) 
with a single update statement and no intermediate temporary tables
'''

# Solution - 1 -> Using conditional update statement

UPDATE SALARY SET SEX = IF(SEX='m', 'f', 'm')
