-- procedural sql
-- optional trigger included in DDL as allowed by spec. 

-- required 1 UDF
-- function to return a student's avg sensation score by UID
-- param: uid


-- function to return a student's avg sensation score by username 
-- param: username


-- required 1 procedure
-- choose what type of ranking that you want to see
-- param: string choice, eg. house, major, year of graduation
-- we can see the ranking of best to worst house, major, year of graduation


-- see self stats 
-- only works if you have taken the survey
-- procedure to see:  your ranking, average score, and total score
-- ranking within major, ranking within year, and ranking within house


-- see top x
-- param: x how much of the top list can you see
-- error handling: can't be more than in the student's table
-- returns the ranked list 