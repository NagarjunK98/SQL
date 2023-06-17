'''
Books: nook_id, name, available_from

Orders: order_id, book_id, quantity, dispatch_date

Writa a SQL query that reports the books that have sold less than 10 copies in the last year, 
excluding books that have been available for less than 1 month from today. 
Assume today is 2019-06-23 
'''

WITH FILTER_BOOKS AS (
    SELECT book_id, name, available_from FROM Books 
    WHERE available_from < '2019-05-23'
),
FILTER_ORDERS AS (
    SELECT book_id, SUM(quantity) AS total_sales
    FROM Orders
    WHERE dispatch_date BETWEEN '2018-06-23' AND '2019-06-22'
    GROUP BY book_id
),
FIND_SALES AS (
    SELECT A.book_id, A.name, B.total_sales
    FROM FILTER_BOOKS A LEFT JOIN FILTER_ORDERS B 
    ON A.book_id = B.book_id
)
SELECT book_id, name FROM FIND_SALES 
WHERE total_sales < 10 OR total_sales IS NULL
