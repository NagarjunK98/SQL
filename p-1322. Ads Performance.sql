'''
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| ad_id         | int     |
| user_id       | int     |
| action        | enum    |
+---------------+---------+
(ad_id, user_id) is the primary key for this table.
Each row of this table contains the ID of an Ad, the ID of a user and the action taken by this user regarding this Ad.
The action column is an ENUM type of ('Clicked', 'Viewed', 'Ignored').

Ads table:
+-------+---------+---------+
| ad_id | user_id | action  |
+-------+---------+---------+
| 1     | 1       | Clicked |
| 2     | 2       | Clicked |
| 3     | 3       | Viewed  |
| 5     | 5       | Ignored |
| 1     | 7       | Ignored |
| 2     | 7       | Viewed  |
| 3     | 5       | Clicked |
| 1     | 4       | Viewed  |
| 2     | 11      | Viewed  |
| 1     | 2       | Clicked |
+-------+---------+---------+
Result table:
+-------+-------+
| ad_id | ctr   |
+-------+-------+
| 1     | 66.67 |
| 3     | 50.00 |
| 2     | 33.33 |
| 5     | 0.00  |
+-------+-------+

for ad_id = 1, ctr = (2/(2+1)) * 100 = 66.67
for ad_id = 2, ctr = (1/(1+2)) * 100 = 33.33
for ad_id = 3, ctr = (1/(1+1)) * 100 = 50.00
for ad_id = 5, ctr = 0.00, Note that ad_id = 5 has no clicks or views.
Note that we don\'t care about Ignored Ads.
Result table is ordered by the ctr. in case of a tie we order them by ad_id
'''

WITH AGG_DATA AS (
SELECT ad_id, action, COUNT(*) AS C 
FROM ads 
GROUP BY ad_id, action
),
PIVOT_DATA AS (
SELECT * FROM (
	select ad_id, action, C FROM AGG_DATA
) AS temp_table
PIVOT (
	MAX(C)
  	FOR action IN ([Viewed], [Clicked])
) AS pivot_table
)
SELECT ad_id,
CASE WHEN Viewed IS NULL AND Clicked IS NULL THEN 0.00
WHEN Viewed IS NULL OR Clicked IS NULL THEN 0.0
ELSE ROUND(100.0*(Clicked)/(Clicked + Viewed), 2) END as ctr
FROM PIVOT_DATA
ORDER BY ROUND(100.0*(Clicked)/(Clicked + Viewed), 2) DESC