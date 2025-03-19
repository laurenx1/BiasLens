
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


-- 
DELIMITER !
CREATE PROCEDURE sp_add_user(uid CHAR(7), new_username VARCHAR(50), email VARCHAR(100), password VARCHAR(20))
BEGIN
  DECLARE salt CHAR(8);
  SET salt = make_salt(8);

  INSERT INTO biaslensDB.account (
    uid, username, email, salt, password_hash
  ) VALUES (
    uid, new_username, email, salt, SHA2(CONCAT(salt, password), 256)
  );
  
END !
DELIMITER ;



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