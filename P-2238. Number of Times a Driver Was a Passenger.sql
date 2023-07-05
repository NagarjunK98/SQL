'''
+--------------+------+
| Column Name  | Type |
+--------------+------+
| ride_id      | int  |
| driver_id    | int  |
| passenger_id | int  |
+--------------+------+
ride_id is the primary key for this table.
Each row of this table contains the ID of the driver and the ID of the passenger that rode in ride_id.
Note that driver_id != passenger_id.

Write an SQL query to report the ID of each driver and the number of times they were a passenger.

Input: 
Rides table:
+---------+-----------+--------------+
| ride_id | driver_id | passenger_id |
+---------+-----------+--------------+
| 1       | 7         | 1            |
| 2       | 7         | 2            |
| 3       | 11        | 1            |
| 4       | 11        | 7            |
| 5       | 11        | 7            |
| 6       | 11        | 3            |
+---------+-----------+--------------+
Output: 
+-----------+-----+
| driver_id | cnt |
+-----------+-----+
| 7         | 2   |
| 11        | 0   |
+-----------+-----+
Explanation: 
There are two drivers in all the given rides: 7 and 11.
The driver with ID = 7 was a passenger two times.
The driver with ID = 11 was never a passenger.
'''

WITH DRIVERS AS (
    SELECT DISTINCT driver_id FROM rides
)
SELECT A.driver_id, COALESCE(COUNT(B.passenger_id), 0) AS cnt  
FROM DRIVERS A LEFT JOIN rides B ON A.driver_id = B.passenger_id
GROUP by A.driver_id