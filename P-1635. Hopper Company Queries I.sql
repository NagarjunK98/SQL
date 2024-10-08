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

Write an SQL query to report the following statistics for each month of 2020:

The number of drivers currently with the Hopper company by the end of the month (active_drivers).
The number of accepted rides in that month (accepted_rides).
Return the result table ordered by month in ascending order, where month is the months number (January is 1, February is 2, etc.)

Drivers table:
+-----------+------------+
| driver_id | join_date  |
+-----------+------------+
| 10        | 2019-12-10 |
| 8         | 2020-1-13  |
| 5         | 2020-2-16  |
| 7         | 2020-3-8   |
| 4         | 2020-5-17  |
| 1         | 2020-10-24 |
| 6         | 2021-1-5   |
+-----------+------------+

Rides table:
+---------+---------+--------------+
| ride_id | user_id | requested_at |
+---------+---------+--------------+
| 6       | 75      | 2019-12-9    |
| 1       | 54      | 2020-2-9     |
| 10      | 63      | 2020-3-4     |
| 19      | 39      | 2020-4-6     |
| 3       | 41      | 2020-6-3     |
| 13      | 52      | 2020-6-22    |
| 7       | 69      | 2020-7-16    |
| 17      | 70      | 2020-8-25    |
| 20      | 81      | 2020-11-2    |
| 5       | 57      | 2020-11-9    |
| 2       | 42      | 2020-12-9    |
| 11      | 68      | 2021-1-11    |
| 15      | 32      | 2021-1-17    |
| 12      | 11      | 2021-1-19    |
| 14      | 18      | 2021-1-27    |
+---------+---------+--------------+

AcceptedRides table:
+---------+-----------+---------------+---------------+
| ride_id | driver_id | ride_distance | ride_duration |
+---------+-----------+---------------+---------------+
| 10      | 10        | 63            | 38            |
| 13      | 10        | 73            | 96            |
| 7       | 8         | 100           | 28            |
| 17      | 7         | 119           | 68            |
| 20      | 1         | 121           | 92            |
| 5       | 7         | 42            | 101           |
| 2       | 4         | 6             | 38            |
| 11      | 8         | 37            | 43            |
| 15      | 8         | 108           | 82            |
| 12      | 8         | 38            | 34            |
| 14      | 1         | 90            | 74            |
+---------+-----------+---------------+---------------+

Result table:
+-------+----------------+----------------+
| month | active_drivers | accepted_rides |
+-------+----------------+----------------+
| 1     | 2              | 0              |
| 2     | 3              | 0              |
| 3     | 4              | 1              |
| 4     | 4              | 0              |
| 5     | 5              | 0              |
| 6     | 5              | 1              |
| 7     | 5              | 1              |
| 8     | 5              | 1              |
| 9     | 5              | 0              |
| 10    | 6              | 0              |
| 11    | 6              | 2              |
| 12    | 6              | 1              |
+-------+----------------+----------------+

By the end of January --> two active drivers (10, 8) and no accepted rides.
By the end of February --> three active drivers (10, 8, 5) and no accepted rides.
By the end of March --> four active drivers (10, 8, 5, 7) and one accepted ride (10).
By the end of April --> four active drivers (10, 8, 5, 7) and no accepted rides.
By the end of May --> five active drivers (10, 8, 5, 7, 4) and no accepted rides.
By the end of June --> five active drivers (10, 8, 5, 7, 4) and one accepted ride (13).
By the end of July --> five active drivers (10, 8, 5, 7, 4) and one accepted ride (7).
By the end of August --> five active drivers (10, 8, 5, 7, 4) and one accepted ride (17).
By the end of Septemeber --> five active drivers (10, 8, 5, 7, 4) and no accepted rides.
By the end of October --> six active drivers (10, 8, 5, 7, 4, 1) and no accepted rides.
By the end of November --> six active drivers (10, 8, 5, 7, 4, 1) and two accepted rides (20, 5).
By the end of December --> six active drivers (10, 8, 5, 7, 4, 1) and one accepted ride (2).
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
SELECT A.month_no AS month, A.active_drivers, COALESCE(B.accepted_rides, 0) AS accepted_rides
FROM ACTIVE_DRIVERS A LEFT JOIN ACCEPTED_RIDES B ON A.month_no = B.month_no
