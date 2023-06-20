'''
Table: Transactions

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| id             | int     |
| country        | varchar |
| state          | enum    |
| amount         | int     |
| trans_date     | date    |
+----------------+---------+
id is the primary key of this table.The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].

Table: Chargebacks

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| trans_id       | int     |
| trans_date     | date    |
+----------------+---------+
Chargebacks contains basic information regarding incoming chargebacks from some transactions placed in Transactions table.
trans_id is a foreign key to the id column of Transactions table.Each chargeback corresponds to a transaction made previously 
even if they were not approved.

Write an SQL query to find for each month and country: the number of approved transactions and their total amount, 
the number of chargebacks, and their total amount.

Note: In your query, given the month and country, ignore rows with all zeros.

Input: 
Transactions table:
+-----+---------+----------+--------+------------+
| id  | country | state    | amount | trans_date |
+-----+---------+----------+--------+------------+
| 101 | US      | approved | 1000   | 2019-05-18 |
| 102 | US      | declined | 2000   | 2019-05-19 |
| 103 | US      | approved | 3000   | 2019-06-10 |
| 104 | US      | declined | 4000   | 2019-06-13 |
| 105 | US      | approved | 5000   | 2019-06-15 |
+-----+---------+----------+--------+------------+

Chargebacks table:
+----------+------------+
| trans_id | trans_date |
+----------+------------+
| 102      | 2019-05-29 |
| 101      | 2019-06-30 |
| 105      | 2019-09-18 |
+----------+------------+


Output: 
+---------+---------+----------------+-----------------+------------------+-------------------+
| month   | country | approved_count | approved_amount | chargeback_count | chargeback_amount |
+---------+---------+----------------+-----------------+------------------+-------------------+
| 2019-05 | US      | 1              | 1000            | 1                | 2000              |
| 2019-06 | US      | 2              | 8000            | 1                | 1000              |
| 2019-09 | US      | 0              | 0               | 1                | 5000              |
+---------+---------+----------------+-----------------+------------------+-------------------+
'''

WITH APPROVED_TRANS AS (
SELECT year_month, country, COUNT(*) AS approved_count, SUM(amount) AS approved_amount FROM (
SELECT country, CONCAT(YEAR(trans_date), '-', RIGHT(CONCAT('0', MONTH(trans_date)),2)) AS year_month, amount
FROM transaction WHERE state = 'approved'
 ) AS A
GROUP BY year_month, country
),
CHARGEBACK_DATA AS (
  SELECT year_month, country, COUNT(*) AS chargeback_count, SUM(amount) AS chargeback_amount FROM 
  	( 
      SELECT CONCAT(YEAR(A.trans_date), '-', RIGHT(CONCAT('0', MONTH(A.trans_date)),2)) AS year_month,
      B.amount, B.country
      FROM chargeback A INNER JOIN trans B
      ON A.trans_id = B.id
	) as A
 GROUP BY year_month, country 
)
SELECT B.year_month, B.country, COALESCE(A.approved_count, 0) AS approved_count, 
COALESCE(A.approved_amount, 0) AS approved_amount, COALESCE(B.chargeback_count, 0) AS chargeback_count, 
COALESCE(B.chargeback_amount, 0) AS chargeback_amount
FROM CHARGEBACK_DATA B LEFT JOIN APPROVED_TRANS A
ON A.year_month = B.year_month AND A.country = B.country
