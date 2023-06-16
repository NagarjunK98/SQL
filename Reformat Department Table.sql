'''
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| revenue     | int     |
| month       | varchar |
+-------------+---------+
(id, month) is the primary key of this table.
The table has information about the revenue of each department per month.
The month has values in ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"].

Write an SQL query to reformat the table such that there is a department id column and a revenue column for each month.
'''

SELECT 
    id,[Jan] AS Jan_Revenue, [Feb] AS Feb_Revenue, [Mar] AS Mar_Revenue, 
    [Apr] AS Apr_Revenue,  [May] AS May_Revenue, [Jun] AS Jun_Revenue, 
    [Jul] AS Jul_Revenue, [Aug] AS Aug_Revenue, [Sep] AS Sep_Revenue, 
    [Oct] AS Oct_Revenue, [Nov] AS Nov_Revenue, [Dec] AS Dec_Revenue  
FROM (
    SELECT 
        id, revenue, month
    FROM Department
) temp_table
PIVOT (
    MAX(revenue)
    FOR month IN ([Jan], [Feb], [Mar], [Apr], [May], [Jun], [Jul], [Aug], [Sep], [Oct], [Nov], [Dec])
) As pivot_table