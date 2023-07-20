'''
+-------------+------+
 | Column Name | Type |
 +-------------+------+
 | user1 | int |
 | user2 | int |
 +-------------+------+
(user1, user2) is the primary key of this table.
Each row contains information about friendship where user1 and user2 are friends.
 
Write an SQL query to find the popularity percentage for each user on Meta/Facebook. The popularity percentage is defined as the 
total number of friends the user has divided by the total number of users on the platform, then converted into a percentage by
multiplying by 100, rounded to 2 decimal places.

Return the result table ordered by user1 in ascending order.
'''
WITH AGG_DATA AS (
    SELECT usr, COUNT(*) as usr_count FROM (
        SELECT user1 as usr FROM friends
        UNION ALL
        SELECT user2 as usr FROM friends
    ) A
    GROUP BY A.usr
)

SELECT usr, ROUND(100.*usr_count/(SELECT COUNT(DISTINCT usr) FROM AGG_DATA), 2)
FROM AGG_DATA
GROUP BY usr, usr_count