'''
+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| pid         | int   |
| tiv_2015    | float |
| tiv_2016    | float |
| lat         | float |
| lon         | float |
+-------------+-------+
pid is the primary key column for this table.
Each row of this table contains information about one policy where:
pid is the policyholder\'s policy ID.
tiv_2015 is the total investment value in 2015 and tiv_2016 is the total investment value in 2016.
lat is the latitude of the policy holder\'s city. It\'s guaranteed that lat is not NULL.
lon is the longitude of the policy holder\'s city. It\'s guaranteed that lon is not NULL.

Write an SQL query to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:

have the same tiv_2015 value as one or more other policyholders, and
are not located in the same city like any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).
Round tiv_2016 to two decimal places
'''

WITH FILTER_CO AS (
SELECT lat, lon, COUNT(*) AS C FROM Insurance 
GROUP BY lat, lon HAVING COUNT(*) = 1
),
ADD_PID AS (
  SELECT B.pid, A.lat, A.lon FROM FILTER_CO A INNER JOIN Insurance B 
  ON A.lat = B.lat AND A.lon = B.lon
),
FILTER_2015 AS (
SELECT DISTINCT A.pid, A.tiv_2015, A.tiv_2016 FROM Insurance A INNER JOIN Insurance B
ON A.tiv_2015 = B.tiv_2015 AND A.pid <> B.pid
)
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016 FROM Insurance WHERE pid IN (
  SELECT A.pid FROM FILTER_2015 A INNER JOIN ADD_PID B
  ON A.pid = B.pid
  )