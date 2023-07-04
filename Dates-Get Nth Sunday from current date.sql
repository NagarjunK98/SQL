'''
Write a sql query to get Nth sunday date from current date
'''

/*
sunday - 1
monday - 2
tuesday - 3
wednesday - 4
thursday - 5
friday - 6
saturday - 7
*/

DECLARE @WEEKDAY INT = 1; # Change number according to which day you want to find; 1 being sunday and 7 being saturday; 
DECLARE @NTHOCCURANCE INT = 1; # Nth day; Here passed first occurance of sunday

SELECT
CASE 
    WHEN  @WEEKDAY-datepart(weekday, GETDATE()) > 0 
    THEN DATEADD(day, (@NTHOCCURANCE - 1) * 7 , dateadd(day, @WEEKDAY - datepart(weekday, GETDATE()), GETDATE()))
    ELSE DATEADD(day, @NTHOCCURANCE * 7 , dateadd(day, @WEEKDAY - datepart(weekday, GETDATE()), GETDATE()))
END AS NTH_DAY