'''
+-------------+------+
| Column Name | Type |
+-------------+------+
| account_id  | int  |
| income      | int  |
+-------------+------+
account_id is the primary key for this table.
Each row contains information about the monthly income for one bank account.

Write an SQL query to report the number of bank accounts of each salary category. The salary categories are:

"Low Salary": All the salaries strictly less than $20000.
"Average Salary": All the salaries in the inclusive range [$20000, $50000].
"High Salary": All the salaries strictly greater than $50000.
The result table must contain all three categories. If there are no accounts in a category, then report 0.
'''
WITH ADD_FLAG AS (
    SELECT account_id, income,
    CASE 
        WHEN income < 20000 THEN 'Low Salary'
        WHEN income >= 20000 AND income <= 50000 THEN 'Average Salary'
        ELSE 'High Salary'
    END AS category
    FROM Accounts
),
CATEGORY AS (
    SELECT 'Low Salary' AS cagr
    UNION
    SELECT 'Average Salary' AS cagr
     UNION
    SELECT 'High Salary' AS cagr
)
SELECT A.cagr AS category, 
SUM(CASE WHEN B.category IS NULL THEN 0 ELSE 1 END) AS accounts_count
FROM CATEGORY A LEFT JOIN ADD_FLAG B
ON A.cagr = B.category
GROUP BY A.cagr