-- procedural sql
-- optional trigger included in DDL as allowed by spec. 
-- recall that UID are CHAR(7), not INT, so must be passed in as strings (surrounded by '')

-- required 1 UDF
-- function to return a student's avg sensation score by UID
-- param: uid
DELIMITER !

CREATE FUNCTION get_avg_sensation_by_uid(input_uid CHAR(7))
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE avg_sensation FLOAT;
    SELECT AVG(A.sensation_score) INTO avg_sensation
    FROM student_survey_results SSR
    JOIN article A ON SSR.article_id = A.article_id
    WHERE SSR.uid = input_uid AND A.sensation_score IS NOT NULL;
    RETURN avg_sensation;
END !

DELIMITER ;


-- function to return a student's avg sensation score by username 
-- param: username VARCHAR(50)
DELIMITER !

CREATE FUNCTION get_avg_sensation_by_username(input_username VARCHAR(50))
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE avg_sensation FLOAT DEFAULT 0;

    SELECT COALESCE(AVG(A.sensation_score), 0) INTO avg_sensation
    FROM student_survey_results SSR 
    JOIN article A ON SSR.article_id = A.article_id

    -- username is not stored in student_survey_results,
    -- must join with account table
    JOIN account ACC ON SSR.uid = ACC.uid
    WHERE ACC.username = input_username;

    RETURN avg_sensation;
END !

DELIMITER ;



-- required 1 procedure
-- choose what type of ranking that you want to see
-- param: string choice, eg. house, major, year of graduation, age
-- we can see the ranking of best to worst house, major, year of graduation
DELIMITER !

CREATE PROCEDURE rank_by_choice(IN choice VARCHAR(1))
BEGIN
    -- Validate input
    IF choice NOT IN ('y', 'Y', 'h', 'H', 'm', 'M', 'a', 'A', 'f', 'F') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid input';
    END IF;

    -- Run a single query with CASE selection
    SELECT 
        CASE 
            WHEN choice IN ('y', 'Y') THEN S.grad_year
            WHEN choice IN ('h', 'H') THEN S.house
            WHEN choice IN ('m', 'M') THEN S.major
            WHEN choice IN ('a', 'A') THEN S.age
            WHEN choice IN ('f', 'F') THEN S.uid
        END AS category,
        AVG(A.sensation_score) AS avg_score
    FROM student_survey_results SSR
    JOIN article A ON SSR.article_id = A.article_id
    JOIN student S ON SSR.uid = S.uid
    GROUP BY category
    ORDER BY avg_score DESC;
    
END !

DELIMITER ;









-- see self stats (works by UID)
-- only works if you have taken the survey
-- ranking within major, ranking within year, and ranking within house
DELIMITER !

CREATE PROCEDURE view_self_stats(IN input_uid CHAR(7))
BEGIN
    DECLARE self_avg FLOAT;
    DECLARE self_total INT;

    -- Ensure the user has taken the survey.
    IF (SELECT taken_survey FROM account WHERE uid = input_uid) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Survey not completed. Please complete the survey first.';
    END IF;

    -- Calculate self stats.
    SELECT AVG(sensation_score), SUM(sensation_score) INTO self_avg, self_total
    FROM student_survey_results SSR
    JOIN article A ON SSR.article_id = A.article_id
    WHERE SSR.uid = input_uid;

    -- Rankings within major, year, and house.
    SELECT S.major, S.grad_year, S.house
    INTO @major, @grad_year, @house
    FROM student S
    WHERE S.uid = input_uid;

    -- major
    SELECT RANK() OVER (ORDER BY AVG(A.sensation_score) DESC) AS rank_in_major
    INTO @rank_in_major
    FROM student_survey_results SSR
    JOIN article A ON SSR.article_id = A.article_id
    JOIN student S ON SSR.uid = S.uid
    WHERE S.major = @major;

    -- graduation year
    SELECT RANK() OVER (ORDER BY AVG(A.sensation_score) DESC) AS rank_in_year
    INTO @rank_in_year
    FROM student_survey_results SSR
    JOIN article A ON SSR.article_id = A.article_id
    JOIN student S ON SSR.uid = S.uid
    WHERE S.grad_year = @grad_year;

    -- house
    SELECT RANK() OVER (ORDER BY AVG(A.sensation_score) DESC) AS rank_in_house
    INTO @rank_in_house
    FROM student_survey_results SSR
    JOIN article A ON SSR.article_id = A.article_id
    JOIN student S ON SSR.uid = S.uid
    WHERE S.house = @house;

    -- Return results (display with 1 view).
    SELECT 
        self_avg AS avg_score, 
        self_total AS total_score, 
        @rank_in_major AS rank_in_major, 
        @rank_in_year AS rank_in_year, 
        @rank_in_house AS rank_in_house;
END !

DELIMITER ;






-- see top x
-- param: x how much of the top list can you see
-- error handling: can't be more than in the student's table
-- returns the ranked list 
DELIMITER !

CREATE PROCEDURE view_top_x(IN x INT)
BEGIN
    DECLARE student_count INT;

    -- Check the total number of students.
    SELECT COUNT(*) INTO student_count FROM student;

    -- Error handling for exceeding the number of students.
    IF x > student_count THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Requested number exceeds the total number of students.';
    END IF;

    -- Return the top X students by average sensation score.
    SELECT S.uid, S.name, AVG(A.sensation_score) AS avg_score
    FROM student_survey_results SSR
    JOIN article A ON SSR.article_id = A.article_id
    JOIN student S ON SSR.uid = S.uid
    GROUP BY S.uid, S.name
    ORDER BY avg_score ASC
    LIMIT x;
END !

DELIMITER ;
