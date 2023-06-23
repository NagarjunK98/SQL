'''
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| customer_id   | int     |
| order_date    | date    |
| item_id       | varchar |
| quantity      | int     |
+---------------+---------+
(ordered_id, item_id) is the primary key for this table.
This table contains information of the orders placed.
order_date is the date when item_id was ordered by the customer with id customer_id.

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| item_id             | varchar |
| item_name           | varchar |
| item_category       | varchar |
+---------------------+---------+
item_id is the primary key for this table.
item_name is the name of the item.
item_category is the category of the item.

You are the business owner and would like to obtain a sales report for category items and day of the week.

Write an SQL query to report how many units in each category have been ordered on each day of the week.

Return the result table ordered by category.

Orders table:
+------------+--------------+-------------+--------------+-------------+
| order_id   | customer_id  | order_date  | item_id      | quantity    |
+------------+--------------+-------------+--------------+-------------+
| 1          | 1            | 2020-06-01  | 1            | 10          |
| 2          | 1            | 2020-06-08  | 2            | 10          |
| 3          | 2            | 2020-06-02  | 1            | 5           |
| 4          | 3            | 2020-06-03  | 3            | 5           |
| 5          | 4            | 2020-06-04  | 4            | 1           |
| 6          | 4            | 2020-06-05  | 5            | 5           |
| 7          | 5            | 2020-06-05  | 1            | 10          |
| 8          | 5            | 2020-06-14  | 4            | 5           |
| 9          | 5            | 2020-06-21  | 3            | 5           |
+------------+--------------+-------------+--------------+-------------+

Items table:
+------------+----------------+---------------+
| item_id    | item_name      | item_category |
+------------+----------------+---------------+
| 1          | LC Alg. Book   | Book          |
| 2          | LC DB. Book    | Book          |
| 3          | LC SmarthPhone | Phone         |
| 4          | LC Phone 2020  | Phone         |
| 5          | LC SmartGlass  | Glasses       |
| 6          | LC T-Shirt XL  | T-Shirt       |
+------------+----------------+---------------+

Result table:
+------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
| Category   | Monday    | Tuesday   | Wednesday | Thursday  | Friday    | Saturday  | Sunday    |
+------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
| Book       | 20        | 5         | 0         | 0         | 10        | 0         | 0         |
| Glasses    | 0         | 0         | 0         | 0         | 5         | 0         | 0         |
| Phone      | 0         | 0         | 5         | 1         | 0         | 0         | 10        |
| T-Shirt    | 0         | 0         | 0         | 0         | 0         | 0         | 0         |
+------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+
'''
# Solution-1
WITH FIND_WEEKDAY AS (
    SELECT A.order_date, A.quantity, B.item_category,
    datename(weekday, A.order_date) week_day
    FROM orders_1 A RIGHT JOIN items B
    ON A.item_id = B.item_id
),
AGG_DATA AS (
    SELECT item_category, week_day, COALESCE(SUM(quantity), 0) as quantity
    FROM FIND_WEEKDAY
    GROUP by item_category, week_day
),
PIVOT_DATA AS (
    SELECT * FROM (
        SELECT item_category AS Category, week_day, quantity
    FROM AGG_DATA
) AS temp_table
PIVOT (
    MAX(quantity)
    FOR week_day IN ([Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Satuarday], [Sunday])
    ) AS pivot_table
)
SELECT Category, COALESCE([Monday], 0) AS Monday, COALESCE([Tuesday], 0) AS Tuesday, COALESCE([Wednesday], 0) AS Wednesday,
COALESCE([Thursday], 0) AS Thursday, COALESCE([Friday], 0) AS Friday, COALESCE([Satuarday], 0) AS Satuarday, 
COALESCE([Sunday], 0) AS Sunday
from PIVOT_DATA ORDER by Category

# Solution-2:  
SELECT B.item_category,
SUM(CASE WHEN datename(weekday, A.order_date) = 'Monday' THEN quantity ELSE 0 END) AS 'Monday',
SUM(CASE WHEN datename(weekday, A.order_date) = 'Tuesday' THEN quantity ELSE 0  END) AS 'Tuesday',
SUM(CASE WHEN datename(weekday, A.order_date) = 'Wednesday' THEN quantity ELSE 0  END) AS 'Wednesday',
SUM(CASE WHEN datename(weekday, A.order_date) = 'Thursday' THEN quantity ELSE 0  END) AS 'Thursday',
SUM(CASE WHEN datename(weekday, A.order_date) = 'Friday' THEN quantity ELSE 0  END) AS 'Friday',
SUM(CASE WHEN datename(weekday, A.order_date) = 'Satuarday' THEN quantity ELSE 0 END) AS 'Satuarday',
SUM(CASE WHEN datename(weekday, A.order_date) = 'Sunday' THEN quantity ELSE 0 END) AS 'Sunday'
FROM orders_1 A RIGHT JOIN items B
ON A.item_id = B.item_id
GROUP BY B.item_category
ORDER BY B.item_category
