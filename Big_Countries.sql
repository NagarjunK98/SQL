'''
Query Statement -> 
A country is big if:
    1. it has an area of at least three million (i.e., 3000000 km2), or
    2. it has a population of at least twenty-five million (i.e., 25000000)
'''

# Solution - 1 -> Using conditions

SELECT NAME, POPULATION, AREA FROM WORLD WHERE AREA >=3000000 OR POPULATION >=25000000