'''
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| patient_id   | int     |
| patient_name | varchar |
| conditions   | varchar |
+--------------+---------+
patient_id is the primary key for this table.
'conditions' contains 0 or more code separated by spaces. 
This table contains information of the patients in the hospital.

Write an SQL query to report the patient_id, patient_name and conditions of the patients who have Type I Diabetes.
Type I Diabetes always starts with DIAB1 prefix.
'''
WITH FIND_INDEX AS (
SELECT *, 
CASE 
  WHEN CHARINDEX('DIAB1', conditions) = 1 THEN 1
  WHEN CHARINDEX('DIAB1', conditions) > 1 AND SUBSTRING(conditions, CHARINDEX('DIAB1', conditions)-1, 1) = ' ' THEN 1
  ELSE 0
  END AS flag
FROM Patients 
)
SELECT patient_id, patient_name, conditions FROM FIND_INDEX WHERE flag=1