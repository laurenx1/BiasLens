SELECT user FROM mysql.user;

-- Creating student & admin users for BiasLens
CREATE USER 'biaslensadmin'@'localhost' IDENTIFIED BY 'adminpw';
CREATE USER 'biaslensstudent'@'localhost' IDENTIFIED BY 'studentpw';

-- See the default privileges for users
SELECT user, execute_priv FROM mysql.user;

-- Admins can do all the things
GRANT ALL PRIVILEGES ON *.* TO 'airbnbadmin'@'localhost';

-- Clients (e.g. app developers interacting with the database) may only have SELECT
-- privileges granted
GRANT SELECT ON airbnbdb.* TO 'airbnbclient'@'localhost';

-- Flush the GRANT commands to update the privileges
FLUSH PRIVILEGES;

-- -- Let's see the results!
-- SELECT user, execute_priv FROM mysql.user WHERE user LIKE 'airbnb%';
-- -- Now, only airbnbadmin has admin privileges, airbnbclient only has SELECT
-- privileges (e.g. no procedures)
-- -- Permissions in action (after logging in with mysql -u airbnbclient -p)
-- USE airbnbdb;
-- -- Client doesn't have execute permissions, thus this CALL to a superhosts()
-- procedure
-- -- will cause an error
-- CALL superhosts();
-- -- ERROR 1370 (42000): execute command denied to user 'airbnbclient'@'localhost'
-- for routine 'airbnbdb.superhosts'
