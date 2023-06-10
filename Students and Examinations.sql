'''
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| student_name  | varchar |
+---------------+---------+
student_id is the primary key for this table.
Each row of this table contains the ID and the name of one student in the school.

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| subject_name | varchar |
+--------------+---------+
subject_name is the primary key for this table.
Each row of this table contains the name of one subject in the school.


+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| student_id   | int     |
| subject_name | varchar |
+--------------+---------+
There is no primary key for this table. It may contain duplicates.
Each student from the Students table takes every course from the Subjects table.
Each row of this table indicates that a student with ID student_id attended the exam of subject_name.


Write an SQL query to find the number of times each student attended each exam.

Return the result table ordered by student_id and subject_name
'''


WITH GEN_DATA AS (
SELECT student_id, student_name, subject_name FROM Students CROSS JOIN Subjects
),
JOINED_DATA AS (
SELECT A.*, B.subject_name AS sub FROM GEN_DATA A LEFT JOIN Examinations B
ON A.student_id = B.student_id AND A.Subject_name = B.subject_name
)
SELECT student_id, student_name, subject_name, 
SUM(CASE WHEN sub IS NOT NULL THEN 1 ELSE 0 END) AS attended_exams
FROM JOINED_DATA
GROUP BY student_id, student_name, subject_name