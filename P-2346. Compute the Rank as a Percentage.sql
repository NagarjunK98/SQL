'''
+---------------+------+
| Column Name   | Type |
+---------------+------+
| student_id    | int  |
| department_id | int  |
| mark          | int  |
+---------------+------+
student_id is the primary key of this table.Each row of this table indicates a students ID, the ID of the department in 
which the student enrolled, and their mark in the exam.

Write an SQL query that reports the rank of each student in their department as a percentage, where the rank as a percentage is 
computed using the following formula: (student_rank_in_the_department - 1) * 100 / (the_number_of_students_in_the_department - 1). 
The percentage should be rounded to 2 decimal places. student_rank_in_the_department is determined by descending mark, 
such that the student with the highest mark is rank 1. If two students get the same mark, they also get the same rank.

Students table:
+------------+---------------+------+
| student_id | department_id | mark |
+------------+---------------+------+
| 2          | 2             | 650  |
| 8          | 2             | 650  |
| 7          | 1             | 920  |
| 1          | 1             | 610  |
| 3          | 1             | 610  |
| 9          | 1             | 480  |
+------------+---------------+------+
Output: 
+------------+---------------+------------+
| student_id | department_id | percentage |
+------------+---------------+------------+
| 7          | 1             | 0.0        |
| 1          | 1             | 33.3       |
| 3          | 1             | 33.3       |
| 9          | 1             | 100.0      |
| 2          | 2             | 0.0        |
| 8          | 2             | 0.0        |
+------------+---------------+------------+
Explanation: 
For Department 1:
 - Student 7: percentage = (1 - 1) * 100 / (4 - 1) = 0.0
 - Student 1: percentage = (2 - 1) * 100 / (4 - 1) = 33.3
 - Student 3: percentage = (2 - 1) * 100 / (4 - 1) = 33.3
 - Student 9: percentage = (4 - 1) * 100 / (4 - 1) = 100.0
For Department 2:
 - Student 2: percentage = (1 - 1) * 100 / (2 - 1) = 0.0
 - Student 8: percentage = (1 - 1) * 100 / (2 - 1) = 0.0
'''
SELECT student_id, department_id, 
ROUND((((RANK() OVER(PARTITION BY department_id ORDER BY mark DESC) - 1)*1.0)/(COUNT(*) OVER(PARTITION BY department_id)-1)*100), 2)
FROM students