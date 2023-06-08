'''
Write a SQL Query to print meaning full name from the given table.
Table has id, comment, translation columns
ex:
1,good,null
2,sggs,sad
3,awesome,null
'''

# Approach-1 
SELECT 
    CASE 
    WHEN translation IS NULL THEN comment
    ELSE translation
    END AS meaning_full_names
FROM TABLE

# Approach-2
SELECT COALESCE(translation, comment) AS meaning_full_names FROM TABLE

# Approach-3
SELECT IF(translation IS NULL, comment, translation) AS meaning_full_names FROM TABLE