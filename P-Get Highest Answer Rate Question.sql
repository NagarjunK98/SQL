'''
Table: uid, action, questionid, answerid, qnum, timestamp

answered means, first question action will be show followed by answer action
Write query to identify the question which has highest answer rate
'''

WITH AGG AS (
    SELECT questionid, 
    SUM(CASE WHEN action = 'show' THEN 1 ELSE 0 END) AS show_count,
    SUM(CASE WHEN action = 'answer' THEN 1 ELSE 0 END) AS answer_count
    FROM survey_log
    GROUP BY questionid
),
ASSIGN_RANK AS (
    SELECT questionid, DENSE_RANK() OVER (ORDER BY answer_count/show_count DESC) AS rn
)
SELECT questionid FROM ASSIGN_RANK WHERE rn = 1