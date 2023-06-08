'''
From the students table, write a SQL query to interchange the adjacent student names.
If there are no adjacent student then the student name should stay the same
'''

select id, student_name, 
CASE
	WHEN id%2=0 THEN LAG(student_name, 1) OVER(ORDER by id)
   	WHEN id%2!=0 THEN LEAD(student_name, 1, student_name) OVER(ORDER by id)
END AS adj_name
FROM students
ORDER by id