
-- DROP PROCEDURE / FUNCTION STATEMENTS
DROP PROCEDURE IF EXISTS sp_change_password; 
DROP PROCEDURE IF EXISTS sp_add_user; 
DROP FUNCTION IF EXISTS authenticate; 
DROP FUNCTION IF EXISTS make_salt; 
DROP PROCEDURE IF EXISTS sp_add_student_to_db;
DROP PROCEDURE IF EXISTS sp_delete_student;
DROP PROCEDURE IF EXISTS sp_add_article;
DROP PROCEDURE IF EXISTS sp_delete_article;
DROP PROCEDURE IF EXISTS sp_update_student_account_info;
DROP PROCEDURE IF EXISTS sp_update_article_info;



-- This function generates a specified number of characters for using as a
-- salt in passwords.
DELIMITER !
CREATE FUNCTION make_salt(num_chars INT)
RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
    DECLARE salt VARCHAR(20) DEFAULT '';

    -- Don't want to generate more than 20 characters of salt.
    SET num_chars = LEAST(20, num_chars);

    -- Generate the salt!  Characters used are ASCII code 32 (space)
    -- through 126 ('z').
    WHILE num_chars > 0 DO
        SET salt = CONCAT(salt, CHAR(32 + FLOOR(RAND() * 95)));
        SET num_chars = num_chars - 1;
    END WHILE;

    RETURN salt;
END !
DELIMITER ;



-- Procedure that adds a new user to the `biaslensDB.account` table with a hashed password and a generated salt.
-- Params:
-- - uid (CHAR(7)): Unique identifier for the user.
-- - new_username (VARCHAR(50)): The username of the new user.
-- - email (VARCHAR(100)): The email address of the new user.
-- - password (VARCHAR(100)): The plaintext password to be hashed and stored.
-- Behavior:
-- - Generates an 8-character salt using the `make_salt` function.
-- - Hashes the password with the generated salt using SHA-256.
-- - Inserts the new user record into the `account` table.
DELIMITER !
CREATE PROCEDURE sp_add_user(uid CHAR(7), new_username VARCHAR(50), email VARCHAR(100), password VARCHAR(100))
BEGIN
  DECLARE salt CHAR(8);
  SET salt = make_salt(8); -- makes 8-char salt

  INSERT INTO biaslensDB.account (
    uid, username, email, salt, password_hash
  ) VALUES (
    uid, new_username, email, salt, SHA2(CONCAT(salt, password), 256)
  );
  
END !
DELIMITER ;




-- Function to verify a user's credentials by checking the hashed password and salt.
-- Params:
-- - input_username (VARCHAR(20)): The username to authenticate.
-- - input_password (VARCHAR(100)): The plaintext password to validate.
-- Returns:
-- - 1 (TINYINT): If the username and password are correct.
-- - 0 (TINYINT): If the credentials are invalid.
-- Behavior:
-- - Combines the user's salt with the input password and hashes the result using SHA-256.
-- - Checks if the resulting hash matches the stored password hash.
DELIMITER !
CREATE FUNCTION authenticate(input_username VARCHAR(20), input_password VARCHAR(100))
RETURNS TINYINT DETERMINISTIC
BEGIN
  DECLARE user_exists TINYINT;

  SELECT COUNT(*) > 0
  INTO user_exists
  FROM biaslensDB.account
  WHERE username = input_username
    AND SHA2(CONCAT(salt, input_password), 256) = password_hash;

  RETURN user_exists;
END !
DELIMITER ;


-- Procedure that updates the password for an existing user in the `biaslensDB.account` table.
-- Params:
-- - username (VARCHAR(50)): The username of the account to update.
-- - new_password (VARCHAR(100)): The new plaintext password to store.
-- Behavior:
-- - Checks if the user exists in the `account` table.
-- - If the user exists:
--   - Generates a new 8-character salt using the `make_salt` function.
--   - Hashes the new password with the new salt using SHA-256.
--   - Updates the `salt` and `password_hash` fields in the `account` table.
-- - If the user does not exist, raises an SQL error with a descriptive message.
DELIMITER !
CREATE PROCEDURE sp_change_password(input_username VARCHAR(50), new_password VARCHAR(100))
BEGIN
  DECLARE new_salt VARCHAR(8); 
  DECLARE user_exists TINYINT;

  -- Check if the user exists
  SELECT COUNT(*) > 0
  INTO user_exists
  FROM biaslensDB.account
  WHERE username = input_username;

  IF user_exists THEN
    -- Generate a new salt
    SET new_salt = make_salt(8);

    -- Update the password hash and salt
    UPDATE biaslensDB.account
    SET salt = new_salt,
        password_hash = SHA2(CONCAT(new_salt, new_password), 256)
    WHERE username = input_username;
  ELSE
    -- Signal an error if the user does not exist
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Username does not exist';
  END IF;
END !
DELIMITER ;


-- auxillary administrative functions 

-- Delete Student
DELIMITER !

CREATE PROCEDURE sp_delete_student(
    IN p_uid CHAR(7)
)
BEGIN
    DELETE FROM account WHERE uid = p_uid;
END !

DELIMITER ;



-- Add Student
DELIMITER !

CREATE PROCEDURE sp_add_student_to_db(
    IN p_uid CHAR(7),
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_name VARCHAR(50),
    IN p_age INT,
    IN p_major VARCHAR(50),
    IN p_house VARCHAR(20),
    IN p_grad_year YEAR
)
BEGIN
    DECLARE salt CHAR(8);
    DECLARE user_exists TINYINT;

    -- Check if the uid already exists
    SELECT COUNT(*) INTO user_exists
    FROM account
    WHERE uid = p_uid;

    IF user_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User with this UID already exists';
    END IF;

    -- Validate input parameters
    IF p_age < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Age must be a positive integer';
    END IF;

    IF p_grad_year < 1900 OR p_grad_year > YEAR(CURDATE()) + 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid graduation year';
    END IF;

    -- Generate salt
    SET salt = make_salt(8);

    -- Start transaction
    START TRANSACTION;

    -- Add to account table
    INSERT INTO account (uid, username, email, salt, password_hash)
    VALUES (p_uid, p_username, p_email, salt, SHA2(CONCAT(salt, p_password), 256));

    -- Add to student table
    INSERT INTO student (uid, name, age, major, house, grad_year)
    VALUES (p_uid, p_name, p_age, p_major, p_house, p_grad_year);

    -- Commit transaction
    COMMIT;

    -- Return success
    SELECT 1 AS success;
END !
DELIMITER ;






-- Add Article
DELIMITER !

CREATE PROCEDURE sp_add_article(
    IN p_keyword VARCHAR(20),
    IN p_article_title VARCHAR(500),
    IN p_author VARCHAR(100),
    IN p_publisher VARCHAR(100),
    IN p_ai_or_web ENUM('ai', 'web'),
    IN p_sensation_score FLOAT,
    IN p_sentiment_score INT
)
BEGIN
    INSERT INTO article (keyword, article_title, author, publisher, ai_or_web, sensation_score, sentiment_score)
    VALUES (p_keyword, p_article_title, p_author, p_publisher, p_ai_or_web, p_sensation_score, p_sentiment_score);
END !

DELIMITER ;




-- Delete Article
DELIMITER !

CREATE PROCEDURE sp_delete_article(
    IN p_article_id INT
)
BEGIN
    DELETE FROM article WHERE article_id = p_article_id;
END !
DELIMITER ;









-- Update Student/Account Information
DELIMITER !

CREATE PROCEDURE sp_update_student_account_info(
    IN p_uid CHAR(7),
    IN p_field VARCHAR(50),
    IN p_value VARCHAR(255)
)
BEGIN
    DECLARE valid_fields VARCHAR(255) DEFAULT 'username,email,password_hash,name,age,major,house,grad_year';
    
    -- Check if the field is valid
    IF FIND_IN_SET(p_field, valid_fields) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid field specified';
    END IF;

    -- Update the appropriate field
    CASE p_field
        WHEN 'username' THEN
            UPDATE account SET username = p_value WHERE uid = p_uid;
        WHEN 'email' THEN
            UPDATE account SET email = p_value WHERE uid = p_uid;
        WHEN 'password_hash' THEN
            UPDATE account SET password_hash = p_value WHERE uid = p_uid;
        WHEN 'name' THEN
            UPDATE student SET name = p_value WHERE uid = p_uid;
        WHEN 'age' THEN
            UPDATE student SET age = CAST(p_value AS SIGNED) WHERE uid = p_uid;
        WHEN 'major' THEN
            UPDATE student SET major = p_value WHERE uid = p_uid;
        WHEN 'house' THEN
            UPDATE student SET house = p_value WHERE uid = p_uid;
        WHEN 'grad_year' THEN
            UPDATE student SET grad_year = CAST(p_value AS YEAR) WHERE uid = p_uid;
    END CASE;
END !

DELIMITER ;

-- Update Article Information
DELIMITER !

CREATE PROCEDURE sp_update_article_info(
    IN p_article_id INT,
    IN p_field VARCHAR(50),
    IN p_value VARCHAR(255)
)
BEGIN
    IF p_field = 'keyword' THEN
        UPDATE article SET keyword = p_value WHERE article_id = p_article_id;
    ELSEIF p_field = 'article_title' THEN
        UPDATE article SET article_title = p_value WHERE article_id = p_article_id;
    ELSEIF p_field = 'author' THEN
        UPDATE article SET author = p_value WHERE article_id = p_article_id;
    ELSEIF p_field = 'publisher' THEN
        UPDATE article SET publisher = p_value WHERE article_id = p_article_id;
    ELSEIF p_field = 'ai_or_web' THEN
        UPDATE article SET ai_or_web = p_value WHERE article_id = p_article_id;
    ELSEIF p_field = 'sensation_score' THEN
        UPDATE article SET sensation_score = CAST(p_value AS FLOAT) WHERE article_id = p_article_id;
    ELSEIF p_field = 'sentiment_score' THEN
        UPDATE article SET sentiment_score = CAST(p_value AS SIGNED) WHERE article_id = p_article_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid field specified';
    END IF;
END !

DELIMITER ;