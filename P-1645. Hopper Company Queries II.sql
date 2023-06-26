'''
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| driver_id   | int     |
| join_date   | date    |
+-------------+---------+
driver_id is the primary key for this table.
Each row of this table contains the drivers ID and the date they joined the Hopper company.

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| ride_id      | int     |
| user_id      | int     |
| requested_at | date    |
+--------------+---------+
ride_id is the primary key for this table.
Each row of this table contains the ID of a ride, the users ID that requested it, and the day they requested it.
There may be some ride requests in this table that were not accepted.

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| ride_id       | int     |
| driver_id     | int     |
| ride_distance | int     |
| ride_duration | int     |
+---------------+---------+
ride_id is the primary key for this table.
Each row of this table contains some information about an accepted ride.
It is guaranteed that each accepted ride exists in the Rides table.

Write an SQL query to report the percentage of working drivers (working_percentage) for each month of 2020 where:
percentage = (no of drivers accepted at least one ride during the month/available no of drivers)*100
Note that if the number of available drivers during a month is zero, we consider the working_percentage to be 0.

Return the result table ordered by month in ascending order, where month is the months number (January is 1, February is 2, etc.). 
Round working_percentage to the nearest 2 decimal places.
'''

WITH GENRATE_MONTH_NO AS (
    SELECT 1 AS month_no
    UNION ALL
    SELECT month_no+1 FROM GENRATE_MONTH_NO WHERE month_no <12
),
MONTH_DRIVER_COUNT AS (
    SELECT month_no, COUNT(month_no) AS driver_count FROM (
        SELECT driver_id, join_date, 
        CASE WHEN YEAR(join_date) < 2020 THEN 1
        WHEN YEAR(join_date) = 2020 AND MONTH(join_date) = 1  THEN 1 
        WHEN YEAR(join_date) = 2020 AND MONTH(join_date) = 2  THEN 2 
        WHEN YEAR(join_date) = 2020 AND MONTH(join_date) = 3  THEN 3
        WHEN YEAR(join_date) = 2020 AND MONTH(join_date) = 4  THEN 4 
        WHEN YEAR(join_date) = 2020 AND MONTH(join_date) = 5  THEN 5 
        WHEN YEAR(join_date) = 2020 AND MONTH(join_date) = 6  THEN 6 
        WHEN YEAR(join_date) = 2020 AND MONTH(join_date) = 7  THEN 7 
        WHEN YEAR(join_date) = 2020 AND MONTH(join_date) = 8  THEN 8 
        WHEN YEAR(join_date) = 2020 AND MONTH(join_date) = 9  THEN 9 
        WHEN YEAR(join_date) = 2020 AND MONTH(join_date) = 10  THEN 10 
        WHEN YEAR(join_date) = 2020 AND MONTH(join_date) = 11 THEN 11 
        WHEN YEAR(join_date) = 2020 AND MONTH(join_date) = 12 THEN 12 
        ELSE 0 END AS month_no
        FROM drivers
        ) A
    WHERE month_no > 0
    GROUP BY month_no
),
ACTIVE_DRIVERS AS (
    SELECT A.month_no, SUM(B.driver_count) OVER(ORDER By A.month_no) AS active_drivers
    FROM GENRATE_MONTH_NO A LEFT JOIN MONTH_DRIVER_COUNT B
    ON A.month_no = B.month_no
),
ACCEPTED_RIDES AS (
    SELECT month_no, COUNT(*) AS accepted_rides FROM (
        SELECT MONTH(B.requested_at) AS month_no FROM AcceptedRides A INNER JOIN Rides B ON A.ride_id = B.ride_id
        WHERE YEAR(requested_at) = 2020
        ) A 
    GROUP BY month_no
)
SELECT A.month_no AS month, ROUND((COALESCE(B.accepted_rides, 0)/(A.active_drivers*1.0)), 2) as working_percentage 
FROM ACTIVE_DRIVERS A LEFT JOIN ACCEPTED_RIDES B ON A.month_no = B.month_no
