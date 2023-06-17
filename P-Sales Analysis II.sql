'''
Product: product_id, product_name

Sales: seller_id, product_id, buyer_id, sale_date, quantity, price

Write a SQL query that reports buyers who have bought S8 but not Iphone. 
NOte that S8 & Iphone are products present in Product table
'''

WITH S8_BUYERS AS (
select A.buyer_id, A.product_id, B.product_name 
FROM sales A INNER JOIN product B
ON A.product_id = B.product_id AND B.product_name = 'S8'
),
IPHONE_BUYERS AS (
select A.buyer_id, A.product_id, B.product_name 
FROM sales A INNER JOIN product B
ON A.product_id = B.product_id AND B.product_name = 'iphone'
)
SELECT DISTINCT buyer_id FROM S8_BUYERS 
WHERE buyer_id NOT IN (SELECT DISTINCT buyer_id FROM IPHONE_BUYERS)
