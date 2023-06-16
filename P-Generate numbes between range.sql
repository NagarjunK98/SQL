'''
Write a query to generate numbers between given range (eg: 1,10)
'''

with recurrive_cte(n) as (
  select 0
  UNION ALL
  select n+1 FROM recurrive_cte
  where  n < 10
  )
  select * from recurrive_cte