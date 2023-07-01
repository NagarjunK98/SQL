'''
+-----------------+------+
| Column Name     | Type |
+-----------------+------+
| experiment_id   | int  |
| platform        | enum |
| experiment_name | enum |
+-----------------+------+
experiment_id is the primary key for this table.
platform is an enum with one of the values (Android, IOS, Web).
experiment_name is an enum with one of the values (Reading, Sports, Programming).
This table contains information about the ID of an experiment done with a random person, the platform used to do the experiment, 
and the name of the experiment.

Write an SQL query to report the number of experiments done on each of the three platforms for each of the three given experiments. 
Notice that all the pairs of (platform, experiment) should be included in the output including the pairs with zero experiments.

Input:
Experiments table:
+---------------+----------+-----------------+
| experiment_id | platform | experiment_name |
+---------------+----------+-----------------+
| 4             | IOS      | Programming     |
| 13            | IOS      | Sports          |
| 14            | Android  | Reading         |
| 8             | Web      | Reading         |
| 12            | Web      | Reading         |
| 18            | Web      | Programming     |
+---------------+----------+-----------------+
Output: 
+----------+-----------------+-----------------+
| platform | experiment_name | num_experiments |
+----------+-----------------+-----------------+
| Android  | Reading         | 1               |
| Android  | Sports          | 0               |
| Android  | Programming     | 0               |
| IOS      | Reading         | 0               |
| IOS      | Sports          | 1               |
| IOS      | Programming     | 1               |
| Web      | Reading         | 2               |
| Web      | Sports          | 0               |
| Web      | Programming     | 1               |
+----------+-----------------+-----------------+
Explanation: 
On the platform "Android", we had only one "Reading" experiment.
On the platform "IOS", we had one "Sports" experiment and one "Programming" experiment.
On the platform "Web", we had two "Reading" experiments and one "Programming" experiment.
'''

WITH PLATFORM AS (
    SELECT 'IOS' AS P_NAME
    UNION
    SELECT 'Andriod' AS P_NAME
    UNION
    SELECT 'Web' AS P_NAME
),
EXPERIMENTS AS ( 
    SELECT 'Programming' AS E_NAME
    UNION
    SELECT 'Sports' AS E_NAME
    UNION
    SELECT 'Reading' AS E_NAME
),
COMBINATIONS AS (
    SELECT P_NAME, E_NAME FROM PLATFORM CROSS JOIN EXPERIMENTS
)
SELECT A.P_NAME AS platform, A.E_NAME AS experiment_name, 
SUM(CASE WHEN B.experiment_id IS NOT NULL THEN 1 ELSE 0 END) AS num_experiments 
FROM COMBINATIONS A LEFT JOIN experiments_1 B 
ON A.P_NAME = B.platform AND A.E_NAME = B.experiment_name
GROUP BY A.P_NAME, A.E_NAME