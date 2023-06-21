'''
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| visit_date    | date    |
+---------------+---------+
(user_id, visit_date) is the primary key for this table.
Each row of this table indicates that user_id has visited the bank in visit_date.

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| user_id          | int     |
| transaction_date | date    |
| amount           | int     |
+------------------+---------+
There is no primary key for this table, it may contain duplicates.
Each row of this table indicates that user_id has done a transaction of amount in transaction_date.
It is guaranteed that the user has visited the bank in the transaction_date.(i.e The Visits table contains (user_id, transaction_date) in one row)

Write an SQL query to find how many users visited the bank and didn\'t do any transactions, how many visited the bank and did one transaction and so on.

The result table will contain two columns:
    1. transactions_count which is the number of transactions done in one visit.
    2. visits_count which is the corresponding number of users who did transactions_count in one visit to the bank.
transactions_count should take all values from 0 to max(transactions_count) done by one or more users

Visits table:
+---------+------------+
| user_id | visit_date |
+---------+------------+
| 1       | 2020-01-01 |
| 2       | 2020-01-02 |
| 12      | 2020-01-01 |
| 19      | 2020-01-03 |
| 1       | 2020-01-02 |
| 2       | 2020-01-03 |
| 1       | 2020-01-04 |
| 7       | 2020-01-11 |
| 9       | 2020-01-25 |
| 8       | 2020-01-28 |
+---------+------------+
Transactions table:
+---------+------------------+--------+
| user_id | transaction_date | amount |
+---------+------------------+--------+
| 1       | 2020-01-02       | 120    |
| 2       | 2020-01-03       | 22     |
| 7       | 2020-01-11       | 232    |
| 1       | 2020-01-04       | 7      |
| 9       | 2020-01-25       | 33     |
| 9       | 2020-01-25       | 66     |
| 8       | 2020-01-28       | 1      |
| 9       | 2020-01-25       | 99     |
+---------+------------------+--------+
Result table:
+--------------------+--------------+
| transactions_count | visits_count |
+--------------------+--------------+
| 0                  | 4            |
| 1                  | 5            |
| 2                  | 0            |
| 3                  | 1            |
+--------------------+--------------+
* For transactions_count = 0, The visits (1, "2020-01-01"), (2, "2020-01-02"), (12, "2020-01-01") and (19, "2020-01-03") 
did no transactions so visits_count = 4.
* For transactions_count = 1, The visits (2, "2020-01-03"), (7, "2020-01-11"), (8, "2020-01-28"), (1, "2020-01-02") 
and (1, "2020-01-04") did one transaction so visits_count = 5.
* For transactions_count = 2, No customers visited the bank and did two transactions so visits_count = 0.
* For transactions_count = 3, The visit (9, "2020-01-25") did three transactions so visits_count = 1.
* For transactions_count >= 4, No customers visited the bank and did more than three transactions so we will 
stop at transactions_count = 3
'''

WITH JOINED_DATA AS (
SELECT A.user_id, A.visit_date, B.transaction_date
FROM Visits A LEFT JOIN t B
ON A.user_id = B.user_id AND A.visit_date = B.transaction_date
),
GROUP_TRANS_DATE as (
SELECT transaction_date, COUNT(*) AS trans_count FROM JOINED_DATA
GROUP BY transaction_date
),
ADD_NEW_TRANS_COUNT AS (
SELECT transaction_date, trans_count,
CASE WHEN transaction_date IS NULL THEN 0
ELSE trans_count
END AS new_trans_count,
CASE WHEN transaction_date IS NOT NULL THEN 1
 ELSE trans_count
  END AS visit_count
FROM GROUP_TRANS_DATE
),
GROUP_VISITS_COUNT AS (
SELECT new_trans_count, SUM(visit_count) AS visit_count  FROM ADD_NEW_TRANS_COUNT
GROUP BY new_trans_count
),
-- MAX trans count is maintained in separate cte as we can't apply MAX(), or any GROUP BY function 
-- in not allowed in the recursive part of a recursive CTE. IN this case, recursive CTE used to generate numbers between min and max 
MAX_TRANS_COUNT AS (
  SELECT MAX(new_trans_count) AS new_trans_count FROM GROUP_VISTS_COUNT
),
GENERATE_NO AS (
SELECT MIN(new_trans_count) AS trans_count FROM GROUP_VISTS_COUNT
UNION ALL
SELECT trans_count+1 from GENERATE_NO WHERE trans_count < (SELECT new_trans_count FROM MAX_TRANS_COUNT)
)

SELECT A.trans_count, COALESCE(visit_count, 0) AS visit_count 
FROM GENERATE_NO A LEFT JOIN GROUP_VISITS_COUNT B
ON A.trans_count = B.new_trans_count
ORDER BY A.trans_count
