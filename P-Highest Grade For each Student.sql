'''
Enrollments: student_id, course_id, grade

Write SQL query to find highest grade with its corresponding course for each student.
In case of a tie, you should find course with the smallest course_id.
The output must be sorted by increasing student id
'''

WITH ASSIGN_RANK AS (
    SELECT student_id, course_id, grade,
    DENSE_RANK() OVER(PARTITION BY student_id ORDER BY grade DESC, course_id ASC) AS rn
    FROM Enrollments
)
SELECT student_id, course_id, grade
FROM ASSIGN_RANK
WHERE rn = 1