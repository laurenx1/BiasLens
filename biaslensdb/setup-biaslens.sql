
/*
 * table that stores information on all users (both students and administrators)
 * in the db (who have already created an account)
 */
CREATE TABLE account (
    uid CHAR(7) PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_admin BOOLEAN DEFAULT 0,
    taken_survey BOOLEAN DEFAULT 0
);


CREATE TABLE student (
    uid CHAR(7) PRIMARY KEY
)


-- INSERT INTO users (uid, username, email, password_hash)
--     VALUES ('123456789', 'test1', 'fake@test.com', '12345678')


-- GRANT ALL PRIVILEGES ON your_database.* TO 'your_user'@'localhost' IDENTIFIED BY 'your_password';
-- FLUSH PRIVILEGES;

-- GRANT ALL PRIVILEGES ON biaslensDB.* TO adminuser@localhost IDENTIFIED BY fakepassword123;
-- FLUSH PRIVILEGES;