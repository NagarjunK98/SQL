'''
Table: followee, follower

Write a sql query to get amount of each follower\'s follower if heshe has one.
'''

select A.followee, COUNT(DISTINCT A.follower)
from fb A Join fb B
ON A.f1 = B.f2
GROUP BY A.followee