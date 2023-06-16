'''
Write a SQL query to generate weekday names Monday-Sunday
'''

with recurrive_cte(n, weekday) as (
  select 0, DATENAME(weekday, 0)
  UNION ALL
  select n+1, DATENAME(weekday, n+1) FROM recurrive_cte
  where  n < 6
  )
  select * from recurrive_cte