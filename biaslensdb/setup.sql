-- DDL
/*
 * creation of the BiasLens database
 */
DROP DATABASE IF EXISTS biaslensDB;
CREATE DATABASE biaslensDB;

USE biaslensDB;


-- DROP TABLE IF EXISTS statements
DROP TABLE IF EXISTS student_survey_results;
DROP TABLE IF EXISTS article;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS keyword_list;


/*
 * Stores predefined keywords for articles.
 */
CREATE TABLE keyword_list (
    keyword VARCHAR(20) PRIMARY KEY -- Ensures only valid keywords are used
);


/*
 * table that stores information on all users (students and administrators)
 * in the db (who have already created an account)
 */
CREATE TABLE account (
    -- uid given by Caltech, unique to each student 
    -- uniqueness implied by primary key 
    -- first 2 digits of uid is of matriculation
    -- is_admin uids hard-coded as: 0000000 and 1111111 
    -- ^ because these cannot be real given uids
    uid CHAR(7) PRIMARY KEY,

    -- created upon account creation
    username VARCHAR(50) UNIQUE NOT NULL,

    -- unique email to prevent duplicate signups
    email VARCHAR(100) NOT NULL UNIQUE,

    salt CHAR(8) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- flag for whether or not the account is an administrative account 
    -- 1 = admin, 0 = student
    is_admin TINYINT(1) DEFAULT 0 NOT NULL,

    -- flag for if the student has taken the survey or not
    -- if flag false (0) upon signing in, student account will 
    -- be required to take survey before all else
    taken_survey TINYINT(1) DEFAULT 0 NOT NULL
);



/*
 * trigger to set account.is_admin to true if account has 
 * specified admin uid
 * is_admin uids hard-coded as: 0000000 and 1111111 
 * ^ because these cannot be real given uids
 */

DELIMITER !

CREATE TRIGGER set_admin_flag
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    IF NEW.uid IN ('0000000', '1111111') THEN
        SET NEW.is_admin = 1;
    END IF;
END !

DELIMITER ;

/*
 * Stores student-specific information.
 */
CREATE TABLE student (
    -- uid given by Caltech, unique to each student 
    -- first 2 digits of uid is of matriculation
    uid CHAR(7) PRIMARY KEY,

    -- student's name (can be first or last or both)
    name VARCHAR(50) NOT NULL,

    -- info about the student
    age INT CHECK (age >= 10 AND age <= 120), -- ensure valid range
    major VARCHAR(50) NOT NULL, 
    house VARCHAR(10) NOT NULL,
    grad_year YEAR NOT NULL, 

    FOREIGN KEY (uid) REFERENCES account(uid) ON DELETE CASCADE
);

/*
 * Stores all articles.
 */
CREATE TABLE article (
    -- unique identifier for each article
    article_id INT AUTO_INCREMENT PRIMARY KEY,

    keyword VARCHAR(20) NOT NULL,

    -- basic info about the article
    article_title VARCHAR(500) NOT NULL, 
    author VARCHAR(100), 
    publisher VARCHAR(100), 

    -- engine used to search for article 
    -- (ChatGPT(3) or Google Chrome)
    ai_or_web ENUM('ai', 'web') NOT NULL, 

    -- score that our sensationalism model gives to the
    -- article based on its headline
    sensation_score INT NOT NULL, 

    -- score that nltk model gives to article
    -- based soley on headline
    sentiment_score INT,

    FOREIGN KEY (keyword) REFERENCES keyword_list(keyword) ON UPDATE CASCADE ON DELETE CASCADE
);

/*
 * Stores students' survey selections.
 */
CREATE TABLE student_survey_results (
    uid CHAR(7),
    keyword VARCHAR(20) NOT NULL,
    article_id INT NOT NULL,

    -- since student chooses 5 articles per keyword (there are 8 keywords), 
    -- each uid will be associated with 5*8=40 entries in this table BUT
    -- student can only select an article once BUT more than one student 
    -- can select the same article. 
    -- the unique combination is thus (uid, article_id)
    PRIMARY KEY (uid, article_id),
    FOREIGN KEY (article_id) REFERENCES article(article_id) ON DELETE CASCADE,
    FOREIGN KEY (uid) REFERENCES student(uid) ON DELETE CASCADE,
    FOREIGN KEY (keyword) REFERENCES keyword_list(keyword) ON UPDATE CASCADE ON DELETE CASCADE
);




-- INSERT INTO keyword_list (keyword) VALUES
--     ('Vaccines'),
--     ('COVID-19'),
--     ('American Medicine'),
--     ('Wellness'),
--     ('Public Health'),
--     ('Bird Flu'),
--     ('Global Medicine'),
--     ('Cancer');