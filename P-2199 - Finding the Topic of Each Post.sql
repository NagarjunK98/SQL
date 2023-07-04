'''
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| topic_id    | int     |
| word        | varchar |
+-------------+---------+
(topic_id, word) is the primary key for this table.
Each row of this table contains the id of a topic and a word that is used to express this topic.
There may be more than one word to express the same topic and one word may be used to express multiple topics.

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| post_id     | int     |
| content     | varchar |
+-------------+---------+
post_id is the primary key for this table.
Each row of this table contains the ID of a post and its content.
Content will consist only of English letters and spaces.

Leetcode has collected some posts from its social media website and is interested in finding the topics of each post. 
Each topic can be expressed by one or more keywords. If a keyword of a certain topic exists in the content of a post 
(case insensitive) then the post has this topic.

Write an SQL query to find the topics of each post according to the following rules:
1. If the post does not have keywords from any topic, its topic should be "Ambiguous!".
2. If the post has at least one keyword of any topic, its topic should be a string of the IDs of its topics sorted in ascending 
order and separated by commas ','. The string should not contain duplicate IDs.

Input: 
Keywords table:
+----------+----------+
| topic_id | word     |
+----------+----------+
| 1        | handball |
| 1        | football |
| 3        | WAR      |
| 2        | Vaccine  |
+----------+----------+
Posts table:
+---------+------------------------------------------------------------------------+
| post_id | content                                                                |
+---------+------------------------------------------------------------------------+
| 1       | We call it soccer They call it football hahaha                         |
| 2       | Americans prefer basketball while Europeans love handball and football |
| 3       | stop the war and play handball                                         |
| 4       | warning I planted some flowers this morning and then got vaccinated    |
+---------+------------------------------------------------------------------------+
Output: 
+---------+------------+
| post_id | topic      |
+---------+------------+
| 1       | 1          |
| 2       | 1          |
| 3       | 1,3        |
| 4       | Ambiguous! |
+---------+------------+
'''

WITH MATCHED_ROWS AS (
    SELECT DISTINCT A.post_id, B.topic_id
    FROM posts A LEFT JOIN keywords B 
    ON CONCAT(' ', LOWER(A.content), ' ') LIKE CONCAT('% ', LOWER(B.word), ' %')
)
SELECT post_id, COALESCE(STRING_AGG(topic_id, ',') WITHIN GROUP(ORDER BY topic_id ASC), 'Ambiguous!') AS topic 
FROM MATCHED_ROWS GROUP BY post_id