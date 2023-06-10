'''
+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
(sale_id, year) is the primary key of this table.
product_id is a foreign key to Product table.
Each row of this table shows a sale on the product product_id in a certain year.
Note that the price is per unit.

Write an SQL query that selects the product id, year, quantity, and price for the first year of every product sold.

For a product_id if we have multiple rows with first year, then display all rows. Hence use RANK function instead of ROW_NUMBER
'''
WITH FIND_FIRST_YEAR AS (
    SELECT *, RANK() OVER(PARTITION BY product_id ORDER BY year) AS rn
    FROM Sales
)
SELECT product_id, year AS first_year, quantity, price 
FROM FIND_FIRST_YEAR
WHERE rn=1
