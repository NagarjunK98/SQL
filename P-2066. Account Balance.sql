'''
+-------------+------+
| Column Name | Type |
+-------------+------+
| account_id  | int  |
| day         | date |
| type        | ENUM |
| amount      | int  |
+-------------+------+
(account_id, day) is the primary key for this table.
Each row contains information about one transaction, including the transaction type, the day it occurred on, and the amount.
type is an ENUM of the type (Deposit,Withdraw) 

Write an SQL query to report the balance of each user after each transaction. You may assume that the balance of each account 
before any transaction is 0 and that the balance will never be below 0 at any moment.

Input: 
Transactions table:
+------------+------------+----------+--------+
| account_id | day        | type     | amount |
+------------+------------+----------+--------+
| 1          | 2021-11-07 | Deposit  | 2000   |
| 1          | 2021-11-09 | Withdraw | 1000   |
| 1          | 2021-11-11 | Deposit  | 3000   |
| 2          | 2021-12-07 | Deposit  | 7000   |
| 2          | 2021-12-12 | Withdraw | 7000   |
+------------+------------+----------+--------+
Output: 
+------------+------------+---------+
| account_id | day        | balance |
+------------+------------+---------+
| 1          | 2021-11-07 | 2000    |
| 1          | 2021-11-09 | 1000    |
| 1          | 2021-11-11 | 4000    |
| 2          | 2021-12-07 | 7000    |
| 2          | 2021-12-12 | 0       |
+------------+------------+---------+
'''

WITH TRANSFORM_AMT AS (
    SELECT account_id, day, type, CASE WHEN type = 'Deposit' THEN amount ELSE -1*amount END AS amount
    FROM transactions
)
SELECT account_id, day, SUM(amount) OVER(PARTITION BY account_id ORDER BY day) as balance
FROM TRANSFORM_AMT