'''
Users: user_id, join_date, favorite_brand

orders: order_id, order_date, item_id, buyer_id, seller_id, buyer

Items: item_id, item_brand

Write a query to find for each user, whether the brand of second item(by date) they sold is their favorite brand.
If a user sold less than two items, report the answer as no. It is guaranteed that no seller sold more than one item on a day.

'''

WITH JOINED_DATA AS (
    SELECT * FROM (
        SELECT A.item_id, B.item_brand. A.seller_id,
        DENSE_RANK() OVER(PARTITION BY A.seller_id ORDER BY A.order_date) AS rn
        FROM orders A LEFT JOIN items B ON A.item_id = B.item_id
    ) A
    WHERE rn = 2
)
SELECT A.seller_id,
CASE WHEN A.favorite_brand = B.item_brand THEN 'yes'
ELSE 'no' END AS 2nd_item_fav_brand
FROM users A LEFT JOIN JOINED_DATA 
ON A.seller_id = B.seller_id