
-- DROP PROCEDURE / FUNCTION STATEMENTS
DROP PROCEDURE IF EXISTS sp_change_password; 
DROP PROCEDURE IF EXISTS sp_add_user; 
DROP FUNCTION IF EXISTS authenticate; 
DROP FUNCTION IF EXISTS make_salt; 



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
-- - password (VARCHAR(20)): The plaintext password to be hashed and stored.
-- Behavior:
-- - Generates an 8-character salt using the `make_salt` function.
-- - Hashes the password with the generated salt using SHA-256.
-- - Inserts the new user record into the `account` table.
DELIMITER !
CREATE PROCEDURE sp_add_user(uid CHAR(7), new_username VARCHAR(50), email VARCHAR(100), password VARCHAR(20))
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
-- - input_password (VARCHAR(20)): The plaintext password to validate.
-- Returns:
-- - 1 (TINYINT): If the username and password are correct.
-- - 0 (TINYINT): If the credentials are invalid.
-- Behavior:
-- - Combines the user's salt with the input password and hashes the result using SHA-256.
-- - Checks if the resulting hash matches the stored password hash.
DELIMITER !
CREATE FUNCTION authenticate(input_username VARCHAR(20), input_password VARCHAR(20))
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
CREATE PROCEDURE sp_change_password(username VARCHAR(50), new_password VARCHAR(100))
BEGIN
  DECLARE new_salt VARCHAR(8); 
  DECLARE user_exists TINYINT;

  -- Check if the user exists
  SELECT COUNT(*) > 0
  INTO user_exists
  FROM biaslensDB.account
  WHERE username = username;

  IF user_exists THEN
    -- Generate a new salt
    SET new_salt = make_salt(8);

    -- Update the password hash and salt
    UPDATE biaslensDB.account
    SET salt = new_salt,
        password_hash = SHA2(CONCAT(new_salt, new_password), 256)
    WHERE username = username;
  ELSE
    -- Signal an error if the user does not exist
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Username does not exist';
  END IF;
END !
DELIMITER ;