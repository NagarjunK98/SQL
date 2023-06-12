'''
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| title         | varchar |
+---------------+---------+
movie_id is the primary key for this table.
title is the name of the movie.

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| name          | varchar |
+---------------+---------+
user_id is the primary key for this table.

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| movie_id      | int     |
| user_id       | int     |
| rating        | int     |
| created_at    | date    |
+---------------+---------+
(movie_id, user_id) is the primary key for this table.
This table contains the rating of a movie by a user in their review.
created_at is the user\'s review date.

Write an SQL query to:

Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.
'''
WITH USER_PART AS (
  SELECT A.user_id, B.name, COUNT(*) AS C FROM MovieRating A INNER JOIN Users B
  ON A.user_id = B.user_id 
  GROUP BY A.user_id, B.name
),
ASSIGN_USER_RANK AS (
SELECT name, RANK() OVER(ORDER BY C DESC, name) as rk FROM USER_PART
),
MOVIE_PART AS (
  SELECT A.movie_id, B.title, SUM(A.rating)/(COUNT(*)*1.0) AS avg_rtg 
  FROM MovieRating A INNER JOIN Movies B
  ON A.movie_id = B.movie_id
  WHERE year(created_at) = 2020 AND month(created_at) = 2
  GROUP BY A.movie_id, B.title
),
ASSIGN_MOVIE_RANK AS (
  SELECT title, RANK() OVER(ORDER BY avg_rtg DESC, title) as rk FROM MOVIE_PART
)
SELECT name AS results FROM ASSIGN_USER_RANK WHERE rk=1
UNION ALL
SELECT title AS results FROM ASSIGN_MOVIE_RANK WHERE rk=1