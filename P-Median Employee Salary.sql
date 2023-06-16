'''
Table: id, company, salary

Write a SQL query to find median salary of each company.
'''

WITH ASSIGN_RANK AS (
SELECT *,ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary ASC) AS rn,
CONCAT(company, '_', ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary ASC)) AS concat_col
FROM EMP
),
GET_COMPANY_MAX AS (
SELECT company, MAX(rn) as max_rn 
FROM ASSIGN_RANK GROUP BY company
)
SELECT id, company, salary FROM ASSIGN_RANK WHERE concat_col IN (
  SELECT CONCAT(company, '_', IIF(max_rn%2=0, max_rn/2, (max_rn/2)+1)) FROM GET_COMPANY_MAX
  UNION 
  SELECT CONCAT(company, '_', IIF(max_rn%2=0, (max_rn/2)+1, NULL)) FROM GET_COMPANY_MAX
)