'''
Views: article_id, author_id, viewer_id, view_date

Write a query to find all people who viewed more than one article on the same date, sorted in ascending order by their id

'''

SELECT DISTINCT viewer_id FROM Views
GROUP BY viewer_id, view_date 
HAVING COUNT(DISTINCT article_id) > 1
ORDER BY viewer_id