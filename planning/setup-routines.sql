-- ADMIN PROCEDURES 
-- [Admin Procedure #1: add_user]
DELIMITER !

CREATE PROCEDURE add_account(
    user_id          CHAR(7),
    username         VARCHAR(50),
    email            VARCHAR(100),
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    orig_password    VARCHAR(100),
    is_admin         TINYINT DEFAULT 0,
    articles_chosen  { VARCHAR(100) }
)
BEGIN
    -- Need to add a user and add to the user database.
 
    -- declaration of all variables 
    DECLARE salt VARCHAR(8);
    DECLARE final_password VARCHAR(1000);

    -- adds user to USER
    SELECT CONCAT(salt, password) INTO final_password;
    SELECT SHA2(final_password, 256) INTO final_password;

    SET salt = make_salt(8);
    INSERT INTO 
    user 
    VALUES 
    (   
        user_id,
        username, 
        first_name, 
        last_name, 
        salt,
        final_passwrd
    );

    

END !

DELIMITER ;

-- [Admin Procedure 2: add_user]
DELIMITER !

CREATE PROCEDURE add_student (
    user_id           CHAR(7),
    age               INT,
    major             VARCHAR(100),
    house             VARCHAR(60),
    grad_year         YEAR,
    articles_chosen   { VARCHAR(1000) }
)
BEGIN
    -- NEED TO ADD TO STUDENT. Also need to add to student_selections.
    -- declare all variables
    DECLARE student_sensation_score INT;
    SET student_sensation_score = calc_student_sensation_score(articles_chosen);

    -- add to STUDENT
    INSERT INTO student (user_id, age, major, house, grad_year)
    VALUES 
    (
        user_id,
        age,
        major,
        house,
        grad_year
    );

    -- add to STUDENT_SELECTIONS 
    INSERT INTO student_selections (
        ( SELECT s.student_id WHERE s.user_id = user_id),
        articles_chosen,
        student_sensation_score 
    );
END!

DELIMITER ;

-- [Admin Procedure 3: add_admin]
DELIMITER!

CREATE PROCEDURE add_admin (
    user_id     CHAR(7)
)
BEGIN
(
    INSERT INTO administrator (user_id)
    VALUES 
    (
        user_id
    )
);
END!

DELIMITER ;

-- [Admin Procedure 4: delete_user]
DELIMITER ! 

CREATE PROCEDURE delete_user (
    uid_num    CHAR(7)
)
BEGIN (
    DELETE FROM user 
    WHERE user_id = uid_num; 
)
END!

DELIMITER;

-- [Admin Procedure 5: add_article]
DELIMITER !

CREATE PROCEDURE add_article (
    title              VARCHAR(1000),
    author             VARCHAR(1000),
    is_ai              BOOLEAN,
    publisher          VARCHAR(500),
    sensation_score    FLOAT
)
BEGIN (
    INSERT INTO article (article_title, article_author, is_ai, 
    publisher, sensation_score)
    VALUES  (
        title,
        author,
        is_ai,
        publisher,
        sensation_score
    );
)
END!

DELIMITER;

-- [Admin Procedure 6: delete_article]
DELIMITER !
CREATE PROCEDURE delete_article (
    article_id    INT
)
BEGIN (
    DELETE FROM article 
    WHERE article_id = article_id
);
END!

DELIMITER ;

-- [Admin Procedure 7: update_leaderboard]
DELIMITER !
CREATE PROCEDURE update_leaderboard (
    first_name        VARCHAR(100),
    last_name         VARCHAR(100),
    username          VARCHAR(100),
    sensation_score   INT   
)
BEGIN
    CREATE OR REPLACE view current_leaderboard AS
    SELECT 


-- [Admin Function 1: calculate_student_sensation_score]
CREATE FUNCTION calculate_student_sensation_score(student_id INT)
RETURNS INT
AS
    SELECT AVG(a.sensation_score)
    FROM article a 
    JOIN student_selections s 
    ON a.article_id = s.article_id 
    WHERE s.student_id = student_id;


-- [User Procedure 1: add_student_article]
DELIMITER ! 
CREATE PROCEDURE add_student_article (
    uid  CHAR(7),
    keyword  VARCHAR(20) NOT NULL,
    article_id  INT NOT NULL
)
BEGIN (
    INSERT INTO student_survey_results 
    VALUES 
    (
        uid,
        keyword, 
        article_id 
    );
)
END !
CREATE TRIGGER check_num_articles BEFORE INSERT
    ON student_survey_results FOR EACH ROW
BEGIN
    -- Example of calling our helper procedure, passing in the new row's information
    DECLARE count_curr_articles INT;
    SET count_curr_articles = (
        SELECT COUNT(*)
        FROM student_survey_articles ssa
        WHERE ssa.keyword = keyword and ssa.uid = uid
    );
    IF (count_curr_articles + 1 >= 5) THEN (
        RAISE EXCEPTION 'Students can only select 5 articles per category.'
    );
    END IF;
END !

-- [User View 1: display_results_by_major]
CREATE VIEW display_results_by_major AS 
SELECT u.username, u.first_name, u.last_name, s.major, ss.sensation_score 
FROM user u 
JOIN student s ON s.user_id = u.user_id 
JOIN student_selections ss ON s.student_id = ss.student_id
GROUP BY s.major;

-- [User View 2: display_results_by_grade]
CREATE VIEW display_results_by_grade AS 
SELECT u.username, u.first_name, u.last_name, s.grad_year, ss.sensation_score 
FROM user u 
JOIN student s ON s.user_id = u.user_id 
JOIN student_selections ss ON s.student_id = ss.student_id
GROUP BY s.grad_year;


-- [User View 3: display_results_by_grade]
CREATE VIEW display_results_by_grade AS 
SELECT u.username, u.first_name, u.last_name, s.grad_year, ss.sensation_score 
FROM user u 
JOIN student s ON s.user_id = u.user_id 
JOIN student_selections ss ON s.student_id = ss.student_id
GROUP BY s.grad_year;
