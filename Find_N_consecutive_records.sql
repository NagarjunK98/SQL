'''
SQL Query to fetch “N” consecutive records from a table based on a certain condition

1. when the table has a primary key

2. When table does not have a primary key

3. Query logic based on data field

Idea here is generate consecutive count for all matched rows, then display rows based on N passed value

Question no 10: https://techtfq.com/blog/learn-how-to-write-sql-queries-practice-complex-sql-queries#google_vignette=
'''

1. when the table has a primary key

-- id column is PK here and it is integer means we can do add, sub operation

WITH find_diff AS (
SELECT *, (id - ROW_NUMBER() over(order by id)) as diff
FROM weather where temperature < 0
),
count_diff AS (
SELECT *, COUNT(*) OVER(PARTITION by diff ORDER by diff) as consecutive_count FROM find_diff
)
select * FROM count_diff where consecutive_count = 'N' -- Pass N consecutive number to find those records



2. When table does not have a primary key

-- primary key is not available, we need to generate it by using ROW_NUMBER function instead

WITH generate_pk AS (
select city, temperature, ROW_NUMBER() over() as pk from vw_weather
),
find_diff AS (
SELECT *, pk - ROW_NUMBER() over (ORDER by pk) as diff FROM generate_pk WHERE temperature < 0
),
find_consecutive_no AS (
select *, count(*) OVER(PARTITION by diff order by diff) as consecutive_no from find_diff
)

select * from find_consecutive_no WHERE consecutive_no = 'N' -- Pass N consecutive number to find those records



3. Query logic based on data field

-- Here we have string data type primary key, and order_date column is consecutive column we need to consider  

WITH find_diff AS (
SELECT *, ROW_NUMBER() OVER(order by order_date), 
order_date - cast(row_number() over(order by order_date)::numeric as int) as diff
from orders
),
find_consecutive_no AS (
SELECT *, count(*) OVER(PARTITION by diff) as consecutive_no
FROM find_diff 
)

select * from find_consecutive_no where consecutive_no = 'N' -- Pass N consecutive number to find those records

