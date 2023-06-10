    '''
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| country       | varchar |
| state         | enum    |
| amount        | int     |
| trans_date    | date    |
+---------------+---------+
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].

Write an SQL query to find for each month and country, the number of transactions and their total amount, 
the number of approved transactions and their total amount.

Display month in 2 digits
'''
WITH AGG_DATA AS (
SELECT 
  YEAR(trans_date) AS YEAR, 
  RIGHT(CONVERT(varchar(7),trans_date,102),2) AS MONTH, 
  country, COUNT(*) AS trans_count, 
  SUM(CASE WHEN state='approved' THEN 1 ELSE 0 END) AS approved_count,
  SUM(amount) AS trans_total_amount,
  SUM(CASE WHEN state='approved' THEN amount ELSE 0 END) AS approved_total_amount 
FROM Transactions
GROUP BY YEAR(trans_date), right(CONVERT(varchar(7),trans_date,102),2), country
)
SELECT CONCAT(YEAR, '-', MONTH) AS month, country, trans_count,  approved_count, trans_total_amount, approved_total_amount
FROM AGG_DATA
