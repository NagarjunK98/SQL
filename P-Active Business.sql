'''
Events: business_id, event_type, occurences

Write a SQl query to find all active business.

An active business is a business that has more than one event type with occurences 
greater than average occurences of that event type among all business
'''

WITH FIND_AVG AS (
    SELECT event_type, AVG(occurences*1.0) AS avg_occ 
    FROM Events GROUP BY event_type
)
ADD_AVG AS (
    SELECT A.business_id, A.event_type, 
    A.occurences > B.avg_occ
    FROM Events A INNER JOIN FIND_AVG 
    A.event_type = B.event_type
)
SELECT business_id FROM ADD_AVG 
GROUP BY business_id HAVING COUNT(*) > 1