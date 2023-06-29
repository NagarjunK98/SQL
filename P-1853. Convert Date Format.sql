'''
+-------------+------+
| Column Name | Type |
+-------------+------+
| day         | date |
+-------------+------+
day is the primary key for this table.

Write an SQL query to convert each date in Days into a string formatted as “day_name, month_name day, year”.

Days table:
+------------+
| day        |
+------------+
| 2022-04-12 |
| 2021-08-09 |
| 2020-06-26 |
+------------+

Result table:
+-------------------------+
| day                     |
+-------------------------+
| Tuesday, April 12, 2022 |
| Monday, August 9, 2021  |
| Friday, June 26, 2020   |
+-------------------------+
Please note that the output is case-sensitive.
'''

SELECT CONCAT(DATENAME(WEEKDAY, day), ', ', DATENAME(MONTH, day), ', ', DATEPART(DAY, day), ', ', DATEPART(YEAR, day)) AS day
FROM days