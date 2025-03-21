-- procedural sql
-- optional trigger included in DDL as allowed by spec. 

-- required 1 UDF
-- function to return a student's avg sensation score by UID
-- param: uid
DELIMITER !
CREATE FUNCTION get_avg_sensation_by_uid(input_uid CHAR(7))
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE avg_sensation FLOAT;
    SELECT AVG(sensation_score) INTO avg_sensation
    FROM student_survey_results SSR
    JOIN article A ON SSR.article_id = A.article_id
    WHERE SSR.uid = input_uid;
    RETURN avg_sensation;
END $$
DELIMITER !


-- function to return a student's avg sensation score by username 
-- param: username
DELIMITER !
CREATE FUNCTION get_avg_sensation_by_username(input_username VARCHAR(7))
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE avg_sensation FLOAT;
    SELECT AVG(sensation_score) INTO avg_sensation
    FROM student_survey_results SSR
    JOIN article A ON SSR.article_id = A.article_id
    WHERE SSR.uid = input_uid;
    RETURN avg_sensation;
END $$
DELIMITER !

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