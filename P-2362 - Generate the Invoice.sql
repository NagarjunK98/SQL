'''
+-------------+------+
| Column Name | Type |
+-------------+------+
| product_id  | int  |
| price       | int  |
+-------------+------+
product_id is the primary key for this table.
Each row in this table shows the ID of a product and the price of one unit.

+-------------+------+
| Column Name | Type |
+-------------+------+
| invoice_id  | int  |
| product_id  | int  |
| quantity    | int  |
+-------------+------+
(invoice_id, product_id) is the primary key for this table.
Each row in this table shows the quantity ordered from one product in an invoice

Write an SQL query to show the details of the invoice with the highest price. If two or more invoices have the same price, 
return the details of the one with the smallest invoice_id.

Input: 
Products table:
+------------+-------+
| product_id | price |
+------------+-------+
| 1          | 100   |
| 2          | 200   |
+------------+-------+
Purchases table:
+------------+------------+----------+
| invoice_id | product_id | quantity |
+------------+------------+----------+
| 1          | 1          | 2        |
| 3          | 2          | 1        |
| 2          | 2          | 3        |
| 2          | 1          | 4        |
| 4          | 1          | 10       |
+------------+------------+----------+
Output: 
+------------+----------+-------+
| product_id | quantity | price |
+------------+----------+-------+
| 2          | 3        | 600   |
| 1          | 4        | 400   |
+------------+----------+-------+
Explanation: 
Invoice 1: price = (2 * 100) = $200
Invoice 2: price = (4 * 100) + (3 * 200) = $1000
Invoice 3: price = (1 * 200) = $200
Invoice 4: price = (10 * 100) = $1000

The highest price is $1000, and the invoices with the highest prices are 2 and 4. We return the details of the one with the smallest ID,
which is invoice 2.
'''

WITH FIND_TOTAL_PRICE AS (
    SELECT A.invoice_id, SUM(A.quantity*B.price) as total_price 
    FROM purchases A INNER JOIN products B 
    ON A.product_id = B.product_id
    GROUP BY A.invoice_id
),
GET_INVC_ID AS (
    SELECT invoice_id FROM (
        SELECT invoice_id, total_price, ROW_NUMBER() OVER(ORDER BY total_price DESC, invoice_id) AS RN
        FROM FIND_TOTAL_PRICE
    ) A 
    WHERE A.RN = 1
)
SELECT A.product_id, A.quantity, C.price
FROM purchases A INNER JOIN GET_INVC_ID B ON A.invoice_id = B.invoice_id 
INNER JOIN products C ON A.product_id = C.product_id