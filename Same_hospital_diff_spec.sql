'''
From the doctors table, fetch the details of doctors who work in the same hospital 
but in different specialty.
'''

# Approach-1 -> self join

SELECT 
	A.name, A.speciality, A.hospital 
FROM doctors A, doctors B
where A.hospital = B.hospital AND A.speciality <> B.speciality


'''
 Write SQL query to fetch the doctors who work in same hospital irrespective of their specialty.
'''
SELECT 
	A.name, A.hospital, A.speciality
FROM doctors A, doctors B
where A.hospital = B.hospital 